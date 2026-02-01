import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/language_provider.dart';
import '../../providers/settings_provider.dart';

class ZakatCalculatorScreen extends StatefulWidget {
  const ZakatCalculatorScreen({super.key});

  @override
  State<ZakatCalculatorScreen> createState() => _ZakatCalculatorScreenState();
}

class _ZakatCalculatorScreenState extends State<ZakatCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final _cashController = TextEditingController();
  final _bankBalanceController = TextEditingController();
  final _goldController = TextEditingController();
  final _silverController = TextEditingController();
  final _investmentsController = TextEditingController();
  final _propertyController = TextEditingController();
  final _receivablesController = TextEditingController();
  final _debtsController = TextEditingController();

  // Nisab constants (grams)
  static const double nisabGoldGrams = 87.48; // grams
  static const double nisabSilverGrams = 612.36; // grams

  double _totalAssets = 0;
  double _totalLiabilities = 0;
  double _netWorth = 0;
  double _zakatAmount = 0;
  bool _isEligible = false;

  // Country-specific data - default to India
  late CountryZakatData _countryData;
  String? _lastLanguageCode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = context.read<LanguageProvider>().languageCode;
    final countryCode = context.read<SettingsProvider>().countryCode;

    // Reload country data if language changed
    if (_lastLanguageCode != languageCode) {
      _countryData = CountryZakatData.getByCountryCode(countryCode, context);
      _lastLanguageCode = languageCode;
    }
  }

  @override
  void dispose() {
    _cashController.dispose();
    _bankBalanceController.dispose();
    _goldController.dispose();
    _silverController.dispose();
    _investmentsController.dispose();
    _propertyController.dispose();
    _receivablesController.dispose();
    _debtsController.dispose();
    super.dispose();
  }

  NumberFormat get _currencyFormat => NumberFormat.currency(
    symbol: _countryData.currencySymbol,
    decimalDigits: 2,
  );

  void _calculateZakat() {
    if (!_formKey.currentState!.validate()) return;

    final cash = double.tryParse(_cashController.text) ?? 0;
    final bankBalance = double.tryParse(_bankBalanceController.text) ?? 0;
    final gold = double.tryParse(_goldController.text) ?? 0;
    final silver = double.tryParse(_silverController.text) ?? 0;
    final investments = double.tryParse(_investmentsController.text) ?? 0;
    final property = double.tryParse(_propertyController.text) ?? 0;
    final receivables = double.tryParse(_receivablesController.text) ?? 0;
    final debts = double.tryParse(_debtsController.text) ?? 0;

    // Calculate gold and silver values in local currency
    final goldValue = gold * _countryData.goldPricePerGram;
    final silverValue = silver * _countryData.silverPricePerGram;

    setState(() {
      _totalAssets =
          cash +
          bankBalance +
          goldValue +
          silverValue +
          investments +
          property +
          receivables;
      _totalLiabilities = debts;
      _netWorth = _totalAssets - _totalLiabilities;

      // Calculate Nisab (using silver as it's lower threshold)
      final nisabValue = nisabSilverGrams * _countryData.silverPricePerGram;

      _isEligible = _netWorth >= nisabValue;
      _zakatAmount = _isEligible ? _netWorth * 0.025 : 0; // 2.5%
    });

    _showResultDialog();
  }

  void _showResultDialog() {
    final responsive = context.responsive;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(responsive.radiusXLarge)),
      ),
      builder: (context) => Container(
        padding: responsive.paddingXLarge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: responsive.spacing(40),
              height: responsive.spacing(4),
              margin: EdgeInsets.only(bottom: responsive.spaceXLarge),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(responsive.radiusSmall),
              ),
            ),

            // Result Icon
            Container(
              width: responsive.iconXXLarge * 2,
              height: responsive.iconXXLarge * 2,
              decoration: BoxDecoration(
                color: _isEligible
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isEligible ? Icons.volunteer_activism : Icons.info_outline,
                size: responsive.iconXLarge,
                color: _isEligible ? AppColors.primary : Colors.grey,
              ),
            ),
            SizedBox(height: responsive.spaceXLarge),

            // Title
            Text(
              _isEligible ? context.tr('zakat_is_due') : context.tr('zakat_not_required'),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(
                fontSize: responsive.textXLarge,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.spaceSmall),

            if (!_isEligible) ...[
              Text(
                context.tr('net_worth_below_nisab'),
                style: TextStyle(
                  fontSize: responsive.textMedium,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            SizedBox(height: responsive.spaceLarge),

            // Summary
            _buildSummaryRow(context.tr('total_assets'), _totalAssets, responsive: responsive),
            _buildSummaryRow(context.tr('total_liabilities'), _totalLiabilities, responsive: responsive),
            Divider(height: responsive.spaceLarge),
            _buildSummaryRow(context.tr('net_zakatable_wealth'), _netWorth, responsive: responsive, isBold: true),
            Divider(height: responsive.spaceLarge),

            if (_isEligible) ...[
              Container(
                width: double.infinity,
                padding: responsive.paddingLarge,
                decoration: BoxDecoration(
                  gradient: AppColors.headerGradient,
                  borderRadius: BorderRadius.circular(responsive.radiusLarge),
                ),
                child: Column(
                  children: [
                    Text(
                      context.tr('your_zakat_amount'),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: responsive.textMedium,
                      ),
                    ),
                    SizedBox(height: responsive.spaceSmall),
                    Text(
                      _currencyFormat.format(_zakatAmount),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.fontSize(36),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: responsive.spaceXSmall),
                    Text(
                      context.tr('percentage_of_net_worth'),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: responsive.textSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: responsive.spaceLarge),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.tr('done')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {required ResponsiveUtils responsive, bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.spaceXSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: responsive.textMedium,
                fontWeight: isBold ? FontWeight.bold : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: responsive.spaceSmall),
          Expanded(
            flex: 2,
            child: Text(
              _currencyFormat.format(value),
              style: TextStyle(
                fontSize: responsive.textMedium,
                fontWeight: isBold ? FontWeight.bold : null,
                color: isBold ? AppColors.primary : null,
              ),
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<SettingsProvider>().isDarkMode;
    final responsive = context.responsive;

    // Update country data when country code or language changes
    final countryCode = context.watch<SettingsProvider>().countryCode;
    context.watch<LanguageProvider>(); // Watch for language changes
    // Always reload country data to ensure translations are updated
    _countryData = CountryZakatData.getByCountryCode(countryCode, context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          context.tr('zakat_calculator'),
          style: TextStyle(fontSize: responsive.textLarge),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: responsive.paddingRegular,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Country Info Card
              _buildCountryCard(isDark, responsive),
              SizedBox(height: responsive.spaceRegular),

              // Nisab Info Card
              _buildNisabCard(isDark, responsive),
              SizedBox(height: responsive.spaceLarge),

              // Assets Section
              Text(
                context.tr('assets'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: responsive.textXLarge,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: responsive.spaceMedium),

              _buildInputField(
                controller: _cashController,
                label: context.tr('cash_on_hand'),
                icon: Icons.payments,
                hint: context.tr('enter_cash_amount'),
                isDark: isDark,
                responsive: responsive,
              ),
              _buildInputField(
                controller: _bankBalanceController,
                label: context.tr('bank_balance'),
                icon: Icons.account_balance,
                hint: context.tr('enter_bank_balance'),
                isDark: isDark,
                responsive: responsive,
              ),
              _buildInputField(
                controller: _goldController,
                label: context.tr('gold_in_grams'),
                icon: Icons.diamond,
                hint: context.tr('enter_gold_weight'),
                suffix: 'g',
                isDark: isDark,
                responsive: responsive,
              ),
              _buildInputField(
                controller: _silverController,
                label: context.tr('silver_in_grams'),
                icon: Icons.circle,
                hint: context.tr('enter_silver_weight'),
                suffix: 'g',
                isDark: isDark,
                responsive: responsive,
              ),
              _buildInputField(
                controller: _investmentsController,
                label: context.tr('investments_stocks'),
                icon: Icons.trending_up,
                hint: context.tr('enter_investment_value'),
                isDark: isDark,
                responsive: responsive,
              ),
              _buildInputField(
                controller: _propertyController,
                label: context.tr('business_trade_assets'),
                icon: Icons.business,
                hint: context.tr('enter_business_assets'),
                isDark: isDark,
                responsive: responsive,
              ),
              _buildInputField(
                controller: _receivablesController,
                label: context.tr('money_owed_to_you'),
                icon: Icons.money,
                hint: context.tr('enter_receivables'),
                isDark: isDark,
                responsive: responsive,
              ),

              SizedBox(height: responsive.spaceLarge),

              // Liabilities Section
              Text(
                context.tr('liabilities'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: responsive.textXLarge,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: responsive.spaceMedium),

              _buildInputField(
                controller: _debtsController,
                label: context.tr('debts_loans'),
                icon: Icons.credit_card,
                hint: context.tr('enter_debts'),
                isDark: isDark,
                responsive: responsive,
              ),

              SizedBox(height: responsive.spaceXXLarge),

              // Calculate Button
              SizedBox(
                width: double.infinity,
                height: responsive.spacing(56),
                child: ElevatedButton(
                  onPressed: _calculateZakat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(responsive.radiusLarge),
                    ),
                  ),
                  child: Text(
                    context.tr('calculate_zakat'),
                    style: TextStyle(
                      fontSize: responsive.textLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: responsive.spaceLarge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountryCard(bool isDark, ResponsiveUtils responsive) {
    return Container(
      padding: responsive.paddingRegular,
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: responsive.iconXLarge * 1.5,
            height: responsive.iconXLarge * 1.5,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(responsive.radiusMedium),
            ),
            child: Center(
              child: Text(
                _countryData.flag,
                style: TextStyle(fontSize: responsive.fontSize(28)),
              ),
            ),
          ),
          SizedBox(width: responsive.spaceRegular),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_countryData.countryName} (${_countryData.countryCode})',
                  style: TextStyle(
                    fontSize: responsive.textLarge,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: responsive.spaceXSmall),
                Text(
                  '${_countryData.currencyName} (${_countryData.currencyCode})',
                  style: TextStyle(
                    fontSize: responsive.textSmall,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _showCountrySelector,
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: context.tr('change_country'),
          ),
        ],
      ),
    );
  }

  Widget _buildNisabCard(bool isDark, ResponsiveUtils responsive) {
    final goldNisab = nisabGoldGrams * _countryData.goldPricePerGram;
    final silverNisab = nisabSilverGrams * _countryData.silverPricePerGram;

    return Container(
      padding: responsive.paddingRegular,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCard
            : const Color(0xFFE8F3ED),
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : const Color(0xFF8AAF9A),
          width: 1.5,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: const Color(0xFF0A5C36).withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: AppColors.secondary, size: responsive.iconMedium),
              SizedBox(width: responsive.spaceSmall),
              Expanded(
                child: Text(
                  context.tr('current_nisab_threshold'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.textRegular,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spaceMedium),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('gold_nisab'),
                      style: TextStyle(
                        fontSize: responsive.textSmall,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _currencyFormat.format(goldNisab),
                      style: TextStyle(
                        fontSize: responsive.textMedium,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '(${nisabGoldGrams}g)',
                      style: TextStyle(
                        fontSize: responsive.textXSmall,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('silver_nisab'),
                      style: TextStyle(
                        fontSize: responsive.textSmall,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _currencyFormat.format(silverNisab),
                      style: TextStyle(
                        fontSize: responsive.textMedium,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '(${nisabSilverGrams}g)',
                      style: TextStyle(
                        fontSize: responsive.textXSmall,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spaceMedium),
          Row(
            children: [
              Expanded(
                child: _buildPriceInfo(
                  context.tr('gold_per_gram'),
                  _countryData.goldPricePerGram,
                  isDark,
                  responsive,
                ),
              ),
              SizedBox(width: responsive.spaceMedium),
              Expanded(
                child: _buildPriceInfo(
                  context.tr('silver_per_gram'),
                  _countryData.silverPricePerGram,
                  isDark,
                  responsive,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo(String label, double price, bool isDark, ResponsiveUtils responsive) {
    return Container(
      padding: responsive.paddingSymmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary.withValues(alpha: 0.2)
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(responsive.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: responsive.textXSmall,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: responsive.spaceXSmall),
          Text(
            _currencyFormat.format(price),
            style: TextStyle(
              fontSize: responsive.textSmall,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    required bool isDark,
    required ResponsiveUtils responsive,
    String? suffix,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: responsive.spaceMedium),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(
          fontSize: responsive.textMedium,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(
            fontSize: responsive.textMedium,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
          hintStyle: TextStyle(
            fontSize: responsive.textMedium,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textHint,
          ),
          prefixIcon: Icon(icon, color: AppColors.primary, size: responsive.iconMedium),
          suffixText: suffix ?? _countryData.currencySymbol,
          suffixStyle: TextStyle(
            fontSize: responsive.textSmall,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
          filled: true,
          fillColor: isDark ? AppColors.darkCard : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(responsive.radiusLarge),
            borderSide: BorderSide(
              color: isDark ? Colors.grey.shade700 : const Color(0xFF8AAF9A),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(responsive.radiusLarge),
            borderSide: BorderSide(
              color: isDark ? Colors.grey.shade700 : const Color(0xFF8AAF9A),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(responsive.radiusLarge),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        validator: (value) {
          if (value != null && value.isNotEmpty) {
            if (double.tryParse(value) == null) {
              return context.tr('please_enter_valid_number');
            }
          }
          return null;
        },
      ),
    );
  }

  void _showCountrySelector() {
    final responsive = context.responsive;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(responsive.radiusXLarge)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  width: responsive.spacing(40),
                  height: responsive.spacing(4),
                  margin: EdgeInsets.only(
                    top: responsive.spaceMedium,
                    bottom: responsive.spaceSmall,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(responsive.radiusSmall),
                  ),
                ),
                Padding(
                  padding: responsive.paddingRegular,
                  child: Text(
                    context.tr('select_your_country'),
                    style: TextStyle(
                      fontSize: responsive.textLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: CountryZakatData.getAllCountries(context).length,
                    itemBuilder: (context, index) {
                      final country = CountryZakatData.getAllCountries(context)[index];
                      final isSelected =
                          country.countryCode == _countryData.countryCode;
                      return ListTile(
                        leading: Text(
                          country.flag,
                          style: const TextStyle(fontSize: 28),
                        ),
                        title: Text('${country.countryName} (${country.countryCode})'),
                        subtitle: Text('${country.currencyName} (${country.currencyCode})'),
                        trailing: isSelected
                            ? Icon(Icons.check_circle, color: AppColors.primary)
                            : null,
                        selected: isSelected,
                        onTap: () {
                          context.read<SettingsProvider>().setCountryCode(
                            country.countryCode,
                          );
                          setState(() {
                            _countryData = country;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// Country-specific Zakat data model
class CountryZakatData {
  final String countryCode;
  final String countryName;
  final String currencyCode;
  final String currencyName;
  final String currencySymbol;
  final String flag;
  final double goldPricePerGram;
  final double silverPricePerGram;

  const CountryZakatData({
    required this.countryCode,
    required this.countryName,
    required this.currencyCode,
    required this.currencyName,
    required this.currencySymbol,
    required this.flag,
    required this.goldPricePerGram,
    required this.silverPricePerGram,
  });

  static CountryZakatData getByCountryCode(String code, BuildContext context) {
    final countries = getAllCountries(context);
    return countries.firstWhere(
      (c) => c.countryCode == code,
      orElse: () => countries.first, // Default to India
    );
  }

  // All supported countries with approximate gold/silver prices (2024)
  static List<CountryZakatData> getAllCountries(BuildContext context) => [
    // South Asia (India first as default)
    CountryZakatData(
      countryCode: 'IN',
      countryName: context.tr('country_india'),
      currencyCode: 'INR',
      currencyName: context.tr('currency_inr'),
      currencySymbol: context.tr('currency_symbol_inr'),
      flag: '🇮🇳',
      goldPricePerGram: 5400.0,
      silverPricePerGram: 66.0,
    ),
    CountryZakatData(
      countryCode: 'PK',
      countryName: context.tr('country_pakistan'),
      currencyCode: 'PKR',
      currencyName: context.tr('currency_pkr'),
      currencySymbol: context.tr('currency_symbol_pkr'),
      flag: '🇵🇰',
      goldPricePerGram: 18000.0,
      silverPricePerGram: 220.0,
    ),
    CountryZakatData(
      countryCode: 'BD',
      countryName: context.tr('country_bangladesh'),
      currencyCode: 'BDT',
      currencyName: context.tr('currency_bdt'),
      currencySymbol: context.tr('currency_symbol_bdt'),
      flag: '🇧🇩',
      goldPricePerGram: 7100.0,
      silverPricePerGram: 88.0,
    ),
    // Middle East
    CountryZakatData(
      countryCode: 'SA',
      countryName: context.tr('country_saudi_arabia'),
      currencyCode: 'SAR',
      currencyName: context.tr('currency_sar'),
      currencySymbol: context.tr('currency_symbol_sar'),
      flag: '🇸🇦',
      goldPricePerGram: 244.0,
      silverPricePerGram: 3.0,
    ),
    CountryZakatData(
      countryCode: 'AE',
      countryName: context.tr('country_uae'),
      currencyCode: 'AED',
      currencyName: context.tr('currency_aed'),
      currencySymbol: context.tr('currency_symbol_aed'),
      flag: '🇦🇪',
      goldPricePerGram: 239.0,
      silverPricePerGram: 2.95,
    ),
    CountryZakatData(
      countryCode: 'KW',
      countryName: context.tr('country_kuwait'),
      currencyCode: 'KWD',
      currencyName: context.tr('currency_kwd'),
      currencySymbol: context.tr('currency_symbol_kwd'),
      flag: '🇰🇼',
      goldPricePerGram: 20.0,
      silverPricePerGram: 0.25,
    ),
    CountryZakatData(
      countryCode: 'QA',
      countryName: context.tr('country_qatar'),
      currencyCode: 'QAR',
      currencyName: context.tr('currency_qar'),
      currencySymbol: context.tr('currency_symbol_qar'),
      flag: '🇶🇦',
      goldPricePerGram: 237.0,
      silverPricePerGram: 2.9,
    ),
    CountryZakatData(
      countryCode: 'BH',
      countryName: context.tr('country_bahrain'),
      currencyCode: 'BHD',
      currencyName: context.tr('currency_bhd'),
      currencySymbol: context.tr('currency_symbol_bhd'),
      flag: '🇧🇭',
      goldPricePerGram: 24.5,
      silverPricePerGram: 0.30,
    ),
    CountryZakatData(
      countryCode: 'OM',
      countryName: context.tr('country_oman'),
      currencyCode: 'OMR',
      currencyName: context.tr('currency_omr'),
      currencySymbol: context.tr('currency_symbol_omr'),
      flag: '🇴🇲',
      goldPricePerGram: 25.0,
      silverPricePerGram: 0.31,
    ),
    CountryZakatData(
      countryCode: 'JO',
      countryName: context.tr('country_jordan'),
      currencyCode: 'JOD',
      currencyName: context.tr('currency_jod'),
      currencySymbol: context.tr('currency_symbol_jod'),
      flag: '🇯🇴',
      goldPricePerGram: 46.0,
      silverPricePerGram: 0.57,
    ),
    CountryZakatData(
      countryCode: 'EG',
      countryName: context.tr('country_egypt'),
      currencyCode: 'EGP',
      currencyName: context.tr('currency_egp'),
      currencySymbol: context.tr('currency_symbol_egp'),
      flag: '🇪🇬',
      goldPricePerGram: 2000.0,
      silverPricePerGram: 25.0,
    ),
    CountryZakatData(
      countryCode: 'TR',
      countryName: context.tr('country_turkey'),
      currencyCode: 'TRY',
      currencyName: context.tr('currency_try'),
      currencySymbol: context.tr('currency_symbol_try'),
      flag: '🇹🇷',
      goldPricePerGram: 2100.0,
      silverPricePerGram: 26.0,
    ),
    CountryZakatData(
      countryCode: 'IR',
      countryName: context.tr('country_iran'),
      currencyCode: 'IRR',
      currencyName: context.tr('currency_irr'),
      currencySymbol: context.tr('currency_symbol_irr'),
      flag: '🇮🇷',
      goldPricePerGram: 2730000.0,
      silverPricePerGram: 33600.0,
    ),
    CountryZakatData(
      countryCode: 'IQ',
      countryName: context.tr('country_iraq'),
      currencyCode: 'IQD',
      currencyName: context.tr('currency_iqd'),
      currencySymbol: context.tr('currency_symbol_iqd'),
      flag: '🇮🇶',
      goldPricePerGram: 85000.0,
      silverPricePerGram: 1050.0,
    ),
    // Europe
    CountryZakatData(
      countryCode: 'GB',
      countryName: context.tr('country_uk'),
      currencyCode: 'GBP',
      currencyName: context.tr('currency_gbp'),
      currencySymbol: context.tr('currency_symbol_gbp'),
      flag: '🇬🇧',
      goldPricePerGram: 51.5,
      silverPricePerGram: 0.63,
    ),
    CountryZakatData(
      countryCode: 'DE',
      countryName: context.tr('country_germany'),
      currencyCode: 'EUR',
      currencyName: context.tr('currency_eur'),
      currencySymbol: context.tr('currency_symbol_eur'),
      flag: '🇩🇪',
      goldPricePerGram: 60.0,
      silverPricePerGram: 0.74,
    ),
    CountryZakatData(
      countryCode: 'FR',
      countryName: context.tr('country_france'),
      currencyCode: 'EUR',
      currencyName: context.tr('currency_eur'),
      currencySymbol: context.tr('currency_symbol_eur'),
      flag: '🇫🇷',
      goldPricePerGram: 60.0,
      silverPricePerGram: 0.74,
    ),
    // Southeast Asia
    CountryZakatData(
      countryCode: 'MY',
      countryName: context.tr('country_malaysia'),
      currencyCode: 'MYR',
      currencyName: context.tr('currency_myr'),
      currencySymbol: context.tr('currency_symbol_myr'),
      flag: '🇲🇾',
      goldPricePerGram: 305.0,
      silverPricePerGram: 3.75,
    ),
    CountryZakatData(
      countryCode: 'ID',
      countryName: context.tr('country_indonesia'),
      currencyCode: 'IDR',
      currencyName: context.tr('currency_idr'),
      currencySymbol: context.tr('currency_symbol_idr'),
      flag: '🇮🇩',
      goldPricePerGram: 1020000.0,
      silverPricePerGram: 12600.0,
    ),
    CountryZakatData(
      countryCode: 'SG',
      countryName: context.tr('country_singapore'),
      currencyCode: 'SGD',
      currencyName: context.tr('currency_sgd'),
      currencySymbol: context.tr('currency_symbol_sgd'),
      flag: '🇸🇬',
      goldPricePerGram: 87.0,
      silverPricePerGram: 1.07,
    ),
    // Africa
    CountryZakatData(
      countryCode: 'NG',
      countryName: context.tr('country_nigeria'),
      currencyCode: 'NGN',
      currencyName: context.tr('currency_ngn'),
      currencySymbol: context.tr('currency_symbol_ngn'),
      flag: '🇳🇬',
      goldPricePerGram: 52000.0,
      silverPricePerGram: 640.0,
    ),
    CountryZakatData(
      countryCode: 'ZA',
      countryName: context.tr('country_south_africa'),
      currencyCode: 'ZAR',
      currencyName: context.tr('currency_zar'),
      currencySymbol: context.tr('currency_symbol_zar'),
      flag: '🇿🇦',
      goldPricePerGram: 1200.0,
      silverPricePerGram: 14.8,
    ),
    CountryZakatData(
      countryCode: 'MA',
      countryName: context.tr('country_morocco'),
      currencyCode: 'MAD',
      currencyName: context.tr('currency_mad'),
      currencySymbol: context.tr('currency_symbol_mad'),
      flag: '🇲🇦',
      goldPricePerGram: 650.0,
      silverPricePerGram: 8.0,
    ),
    // Australia
    CountryZakatData(
      countryCode: 'AU',
      countryName: context.tr('country_australia'),
      currencyCode: 'AUD',
      currencyName: context.tr('currency_aud'),
      currencySymbol: context.tr('currency_symbol_aud'),
      flag: '🇦🇺',
      goldPricePerGram: 100.0,
      silverPricePerGram: 1.23,
    ),
    // Canada
    CountryZakatData(
      countryCode: 'CA',
      countryName: context.tr('country_canada'),
      currencyCode: 'CAD',
      currencyName: context.tr('currency_cad'),
      currencySymbol: context.tr('currency_symbol_cad'),
      flag: '🇨🇦',
      goldPricePerGram: 88.0,
      silverPricePerGram: 1.08,
    ),
    // North America
    CountryZakatData(
      countryCode: 'US',
      countryName: context.tr('country_usa'),
      currencyCode: 'USD',
      currencyName: context.tr('currency_usd'),
      currencySymbol: context.tr('currency_symbol_usd'),
      flag: '🇺🇸',
      goldPricePerGram: 65.0,
      silverPricePerGram: 0.80,
    ),
  ];
}
