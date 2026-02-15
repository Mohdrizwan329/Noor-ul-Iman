import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/content_service.dart';
import '../../core/utils/app_utils.dart';
import '../../data/models/firestore_models.dart';
import '../../providers/language_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/common/banner_ad_widget.dart';

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

  double _totalAssets = 0;
  double _totalLiabilities = 0;
  double _netWorth = 0;
  double _zakatAmount = 0;
  bool _isEligible = false;

  // Firebase content
  final ContentService _contentService = ContentService();
  ZakatCalculatorContentFirestore? _calcContent;
  bool _isContentLoading = true;

  // Current country
  CountryZakatDataEntry? _countryData;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final content = await _contentService.getZakatCalculatorContent();
    if (mounted) {
      setState(() {
        _calcContent = content;
        _isContentLoading = false;
        if (content != null && content.countries.isNotEmpty) {
          final countryCode = context.read<SettingsProvider>().countryCode;
          _countryData = content.getByCountryCode(countryCode);
        }
      });
    }
  }

  String _t(String key) {
    if (_calcContent == null) return key;
    final langCode = context.read<LanguageProvider>().languageCode;
    return _calcContent!.getString(key, langCode);
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

  String _getCurrencySymbol() {
    if (_countryData == null) return '';
    final langCode = context.read<LanguageProvider>().languageCode;
    return _countryData!.currencySymbol.get(langCode);
  }

  NumberFormat get _currencyFormat => NumberFormat.currency(
    symbol: _getCurrencySymbol(),
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

    final goldValue = gold * (_countryData?.goldPricePerGram ?? 0);
    final silverValue = silver * (_countryData?.silverPricePerGram ?? 0);

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

      final nisabSilverGrams = _calcContent?.nisabSilverGrams ?? 612.36;
      final nisabValue = nisabSilverGrams * (_countryData?.silverPricePerGram ?? 0);

      _isEligible = _netWorth >= nisabValue;
      _zakatAmount = _isEligible ? _netWorth * 0.025 : 0;
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
            Container(
              width: responsive.spacing(40),
              height: responsive.spacing(4),
              margin: EdgeInsets.only(bottom: responsive.spaceXLarge),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(responsive.radiusSmall),
              ),
            ),
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
            Text(
              _isEligible ? _t('zakat_is_due') : _t('zakat_not_required'),
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
                _t('net_worth_below_nisab'),
                style: TextStyle(
                  fontSize: responsive.textMedium,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            SizedBox(height: responsive.spaceLarge),
            _buildSummaryRow(_t('total_assets'), _totalAssets, responsive: responsive),
            _buildSummaryRow(_t('total_liabilities'), _totalLiabilities, responsive: responsive),
            Divider(height: responsive.spaceLarge),
            _buildSummaryRow(_t('net_zakatable_wealth'), _netWorth, responsive: responsive, isBold: true),
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
                      _t('your_zakat_amount'),
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
                      _t('percentage_of_net_worth'),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(_t('done')),
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
                color: AppColors.primary,
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
    final responsive = context.responsive;

    // Watch for language and country changes
    final countryCode = context.watch<SettingsProvider>().countryCode;
    context.watch<LanguageProvider>();

    // Update country data from Firebase content
    if (_calcContent != null && _calcContent!.countries.isNotEmpty) {
      _countryData = _calcContent!.getByCountryCode(countryCode);
    }

    if (_isContentLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: AppColors.primary),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          _t('zakat_calculator'),
          style: TextStyle(color: Colors.white, fontSize: responsive.textLarge),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: responsive.paddingRegular,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCountryCard(responsive),
                    SizedBox(height: responsive.spaceRegular),
                    _buildNisabCard(responsive),
                    SizedBox(height: responsive.spaceLarge),
                    Text(
                      _t('assets'),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: responsive.textXLarge,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: responsive.spaceMedium),
                    _buildInputField(
                      controller: _cashController,
                      label: _t('cash_on_hand'),
                      icon: Icons.payments,
                      hint: _t('enter_cash_amount'),
                      responsive: responsive,
                    ),
                    _buildInputField(
                      controller: _bankBalanceController,
                      label: _t('bank_balance'),
                      icon: Icons.account_balance,
                      hint: _t('enter_bank_balance'),
                      responsive: responsive,
                    ),
                    _buildInputField(
                      controller: _goldController,
                      label: _t('gold_in_grams'),
                      icon: Icons.diamond,
                      hint: _t('enter_gold_weight'),
                      suffix: 'g',
                      responsive: responsive,
                    ),
                    _buildInputField(
                      controller: _silverController,
                      label: _t('silver_in_grams'),
                      icon: Icons.circle,
                      hint: _t('enter_silver_weight'),
                      suffix: 'g',
                      responsive: responsive,
                    ),
                    _buildInputField(
                      controller: _investmentsController,
                      label: _t('investments_stocks'),
                      icon: Icons.trending_up,
                      hint: _t('enter_investment_value'),
                      responsive: responsive,
                    ),
                    _buildInputField(
                      controller: _propertyController,
                      label: _t('business_trade_assets'),
                      icon: Icons.business,
                      hint: _t('enter_business_assets'),
                      responsive: responsive,
                    ),
                    _buildInputField(
                      controller: _receivablesController,
                      label: _t('money_owed_to_you'),
                      icon: Icons.money,
                      hint: _t('enter_receivables'),
                      responsive: responsive,
                    ),
                    SizedBox(height: responsive.spaceLarge),
                    Text(
                      _t('liabilities'),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: responsive.textXLarge,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: responsive.spaceMedium),
                    _buildInputField(
                      controller: _debtsController,
                      label: _t('debts_loans'),
                      icon: Icons.credit_card,
                      hint: _t('enter_debts'),
                      responsive: responsive,
                    ),
                    SizedBox(height: responsive.spaceXXLarge),
                    SizedBox(
                      width: double.infinity,
                      height: responsive.spacing(56),
                      child: ElevatedButton(
                        onPressed: _calculateZakat,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(responsive.radiusLarge),
                          ),
                        ),
                        child: Text(
                          _t('calculate_zakat'),
                          style: TextStyle(
                            color: Colors.white,
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
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildCountryCard(ResponsiveUtils responsive) {
    final langCode = context.read<LanguageProvider>().languageCode;
    final countryName = _countryData?.countryName.get(langCode) ?? '';
    final currencyName = _countryData?.currencyName.get(langCode) ?? '';
    final currencyCode = _countryData?.currencyCode ?? '';
    final countryCode = _countryData?.countryCode ?? '';
    final flag = _countryData?.flag ?? '';

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
                flag,
                style: TextStyle(color: AppColors.primary, fontSize: responsive.fontSize(28)),
              ),
            ),
          ),
          SizedBox(width: responsive.spaceRegular),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$countryName ($countryCode)',
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
                  '$currencyName ($currencyCode)',
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
            tooltip: _t('change_country'),
          ),
        ],
      ),
    );
  }

  Widget _buildNisabCard(ResponsiveUtils responsive) {
    final nisabGoldGrams = _calcContent?.nisabGoldGrams ?? 87.48;
    final nisabSilverGrams = _calcContent?.nisabSilverGrams ?? 612.36;
    final goldNisab = nisabGoldGrams * (_countryData?.goldPricePerGram ?? 0);
    final silverNisab = nisabSilverGrams * (_countryData?.silverPricePerGram ?? 0);

    return Container(
      padding: responsive.paddingRegular,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F3ED),
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: const Color(0xFF8AAF9A),
          width: 1.5,
        ),
        boxShadow: [
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
                  _t('current_nisab_threshold'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.textRegular,
                    color: AppColors.textPrimary,
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
                      _t('gold_nisab'),
                      style: TextStyle(
                        fontSize: responsive.textSmall,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _currencyFormat.format(goldNisab),
                      style: TextStyle(
                        fontSize: responsive.textMedium,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '(${nisabGoldGrams}g)',
                      style: TextStyle(
                        fontSize: responsive.textXSmall,
                        color: AppColors.textSecondary,
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
                      _t('silver_nisab'),
                      style: TextStyle(
                        fontSize: responsive.textSmall,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _currencyFormat.format(silverNisab),
                      style: TextStyle(
                        fontSize: responsive.textMedium,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '(${nisabSilverGrams}g)',
                      style: TextStyle(
                        fontSize: responsive.textXSmall,
                        color: AppColors.textSecondary,
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
                  _t('gold_per_gram'),
                  _countryData?.goldPricePerGram ?? 0,
                  responsive,
                ),
              ),
              SizedBox(width: responsive.spaceMedium),
              Expanded(
                child: _buildPriceInfo(
                  _t('silver_per_gram'),
                  _countryData?.silverPricePerGram ?? 0,
                  responsive,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo(String label, double price, ResponsiveUtils responsive) {
    return Container(
      padding: responsive.paddingSymmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(responsive.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: responsive.textXSmall,
              color: AppColors.textSecondary,
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
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(
            fontSize: responsive.textMedium,
            color: AppColors.textSecondary,
          ),
          hintStyle: TextStyle(
            fontSize: responsive.textMedium,
            color: AppColors.textHint,
          ),
          prefixIcon: Icon(icon, color: AppColors.primary, size: responsive.iconMedium),
          suffixText: suffix ?? _getCurrencySymbol(),
          suffixStyle: TextStyle(
            fontSize: responsive.textSmall,
            color: AppColors.textSecondary,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(responsive.radiusLarge),
            borderSide: BorderSide(
              color: const Color(0xFF8AAF9A),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(responsive.radiusLarge),
            borderSide: BorderSide(
              color: const Color(0xFF8AAF9A),
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
              return _t('please_enter_valid_number');
            }
          }
          return null;
        },
      ),
    );
  }

  void _showCountrySelector() {
    if (_calcContent == null) return;
    final responsive = context.responsive;
    final langCode = context.read<LanguageProvider>().languageCode;
    final countries = _calcContent!.countries;

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
                    _t('select_your_country'),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: responsive.textLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: countries.length,
                    itemBuilder: (context, index) {
                      final country = countries[index];
                      final isSelected =
                          country.countryCode == _countryData?.countryCode;
                      return ListTile(
                        leading: Text(
                          country.flag,
                          style: const TextStyle(color: AppColors.primary, fontSize: 28),
                        ),
                        title: Text('${country.countryName.get(langCode)} (${country.countryCode})'),
                        subtitle: Text('${country.currencyName.get(langCode)} (${country.currencyCode})'),
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
