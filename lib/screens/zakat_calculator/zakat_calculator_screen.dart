import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import 'zakat_guide_screen.dart';

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
  CountryZakatData _countryData = CountryZakatData.getByCountryCode('IN');
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final countryCode = context.read<SettingsProvider>().countryCode;
      _countryData = CountryZakatData.getByCountryCode(countryCode);
      _initialized = true;
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Result Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _isEligible
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isEligible ? Icons.volunteer_activism : Icons.info_outline,
                size: 40,
                color: _isEligible ? AppColors.primary : Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              _isEligible ? 'Zakat is Due' : 'Zakat Not Required',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            if (!_isEligible) ...[
              Text(
                'Your net worth is below the Nisab threshold.',
                style: TextStyle(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),

            // Summary
            _buildSummaryRow('Total Assets', _totalAssets),
            _buildSummaryRow('Total Liabilities', _totalLiabilities),
            const Divider(height: 24),
            _buildSummaryRow('Net Zakatable Wealth', _netWorth, isBold: true),
            const Divider(height: 24),

            if (_isEligible) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.headerGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Your Zakat Amount',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currencyFormat.format(_zakatAmount),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '2.5% of Net Worth',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : null),
          ),
          Text(
            _currencyFormat.format(value),
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : null,
              color: isBold ? AppColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<SettingsProvider>().isDarkMode;

    // Update country data when it changes
    final countryCode = context.watch<SettingsProvider>().countryCode;
    if (_countryData.countryCode != countryCode) {
      _countryData = CountryZakatData.getByCountryCode(countryCode);
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Zakat Calculator'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Country Info Card
              _buildCountryCard(isDark),
              const SizedBox(height: 16),

              // Zakat Guide Button
              _buildZakatGuideButton(isDark),
              const SizedBox(height: 16),

              // Nisab Info Card
              _buildNisabCard(isDark),
              const SizedBox(height: 24),

              // Assets Section
              Text(
                'Assets',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _cashController,
                label: 'Cash on Hand',
                icon: Icons.payments,
                hint: 'Enter cash amount',
                isDark: isDark,
              ),
              _buildInputField(
                controller: _bankBalanceController,
                label: 'Bank Balance',
                icon: Icons.account_balance,
                hint: 'Enter total bank balance',
                isDark: isDark,
              ),
              _buildInputField(
                controller: _goldController,
                label: 'Gold (in grams)',
                icon: Icons.diamond,
                hint: 'Enter gold weight in grams',
                suffix: 'g',
                isDark: isDark,
              ),
              _buildInputField(
                controller: _silverController,
                label: 'Silver (in grams)',
                icon: Icons.circle,
                hint: 'Enter silver weight in grams',
                suffix: 'g',
                isDark: isDark,
              ),
              _buildInputField(
                controller: _investmentsController,
                label: 'Investments & Stocks',
                icon: Icons.trending_up,
                hint: 'Enter current market value',
                isDark: isDark,
              ),
              _buildInputField(
                controller: _propertyController,
                label: 'Business/Trade Assets',
                icon: Icons.business,
                hint: 'Enter value of business inventory',
                isDark: isDark,
              ),
              _buildInputField(
                controller: _receivablesController,
                label: 'Money Owed to You',
                icon: Icons.money,
                hint: 'Enter receivables amount',
                isDark: isDark,
              ),

              const SizedBox(height: 24),

              // Liabilities Section
              Text(
                'Liabilities',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _debtsController,
                label: 'Debts & Loans',
                icon: Icons.credit_card,
                hint: 'Enter total debts',
                isDark: isDark,
              ),

              const SizedBox(height: 32),

              // Calculate Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _calculateZakat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Calculate Zakat',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountryCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(16),
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                _countryData.flag,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _countryData.countryName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Currency: ${_countryData.currencyName} (${_countryData.currencySymbol})',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _showCountrySelector,
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: 'Change Country',
          ),
        ],
      ),
    );
  }

  Widget _buildZakatGuideButton(bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ZakatGuideScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(18),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.menu_book_rounded,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zakat Guide',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Zakat kya hai? Kisko deni hai? Kyun zaroori hai?',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildNisabCard(bool isDark) {
    final goldNisab = nisabGoldGrams * _countryData.goldPricePerGram;
    final silverNisab = nisabSilverGrams * _countryData.silverPricePerGram;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCard
            : const Color(0xFFE8F3ED),
        borderRadius: BorderRadius.circular(18),
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
              Icon(Icons.info, color: AppColors.secondary),
              const SizedBox(width: 8),
              Text(
                'Current Nisab Threshold',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gold Nisab',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      _currencyFormat.format(goldNisab),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '(${nisabGoldGrams}g)',
                      style: TextStyle(
                        fontSize: 10,
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
                      'Silver Nisab',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      _currencyFormat.format(silverNisab),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '(${nisabSilverGrams}g)',
                      style: TextStyle(
                        fontSize: 10,
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildPriceInfo(
                  'Gold/g',
                  _countryData.goldPricePerGram,
                  isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPriceInfo(
                  'Silver/g',
                  _countryData.silverPricePerGram,
                  isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo(String label, double price, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary.withValues(alpha: 0.2)
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          Text(
            _currencyFormat.format(price),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
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
    String? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
          hintStyle: TextStyle(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textHint,
          ),
          prefixIcon: Icon(icon, color: AppColors.primary),
          suffixText: suffix ?? _countryData.currencySymbol,
          suffixStyle: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
          filled: true,
          fillColor: isDark ? AppColors.darkCard : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: isDark ? Colors.grey.shade700 : const Color(0xFF8AAF9A),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: isDark ? Colors.grey.shade700 : const Color(0xFF8AAF9A),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        validator: (value) {
          if (value != null && value.isNotEmpty) {
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
          }
          return null;
        },
      ),
    );
  }

  void _showCountrySelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Select Your Country',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: CountryZakatData.allCountries.length,
                    itemBuilder: (context, index) {
                      final country = CountryZakatData.allCountries[index];
                      final isSelected =
                          country.countryCode == _countryData.countryCode;
                      return ListTile(
                        leading: Text(
                          country.flag,
                          style: const TextStyle(fontSize: 28),
                        ),
                        title: Text(country.countryName),
                        subtitle: Text(
                          '${country.currencyName} (${country.currencySymbol})',
                        ),
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

  static CountryZakatData getByCountryCode(String code) {
    return allCountries.firstWhere(
      (c) => c.countryCode == code,
      orElse: () => allCountries.first, // Default to India
    );
  }

  // All supported countries with approximate gold/silver prices (2024)
  static const List<CountryZakatData> allCountries = [
    // South Asia (India first as default)
    CountryZakatData(
      countryCode: 'IN',
      countryName: 'India',
      currencyCode: 'INR',
      currencyName: 'Indian Rupee',
      currencySymbol: '₹',
      flag: '🇮🇳',
      goldPricePerGram: 5400.0,
      silverPricePerGram: 66.0,
    ),
    CountryZakatData(
      countryCode: 'PK',
      countryName: 'Pakistan',
      currencyCode: 'PKR',
      currencyName: 'Pakistani Rupee',
      currencySymbol: 'Rs',
      flag: '🇵🇰',
      goldPricePerGram: 18000.0,
      silverPricePerGram: 220.0,
    ),
    CountryZakatData(
      countryCode: 'BD',
      countryName: 'Bangladesh',
      currencyCode: 'BDT',
      currencyName: 'Bangladeshi Taka',
      currencySymbol: '৳',
      flag: '🇧🇩',
      goldPricePerGram: 7100.0,
      silverPricePerGram: 88.0,
    ),
    // Middle East
    CountryZakatData(
      countryCode: 'SA',
      countryName: 'Saudi Arabia',
      currencyCode: 'SAR',
      currencyName: 'Saudi Riyal',
      currencySymbol: 'ر.س',
      flag: '🇸🇦',
      goldPricePerGram: 244.0,
      silverPricePerGram: 3.0,
    ),
    CountryZakatData(
      countryCode: 'AE',
      countryName: 'United Arab Emirates',
      currencyCode: 'AED',
      currencyName: 'UAE Dirham',
      currencySymbol: 'د.إ',
      flag: '🇦🇪',
      goldPricePerGram: 239.0,
      silverPricePerGram: 2.95,
    ),
    CountryZakatData(
      countryCode: 'KW',
      countryName: 'Kuwait',
      currencyCode: 'KWD',
      currencyName: 'Kuwaiti Dinar',
      currencySymbol: 'د.ك',
      flag: '🇰🇼',
      goldPricePerGram: 20.0,
      silverPricePerGram: 0.25,
    ),
    CountryZakatData(
      countryCode: 'QA',
      countryName: 'Qatar',
      currencyCode: 'QAR',
      currencyName: 'Qatari Riyal',
      currencySymbol: 'ر.ق',
      flag: '🇶🇦',
      goldPricePerGram: 237.0,
      silverPricePerGram: 2.9,
    ),
    CountryZakatData(
      countryCode: 'BH',
      countryName: 'Bahrain',
      currencyCode: 'BHD',
      currencyName: 'Bahraini Dinar',
      currencySymbol: 'د.ب',
      flag: '🇧🇭',
      goldPricePerGram: 24.5,
      silverPricePerGram: 0.30,
    ),
    CountryZakatData(
      countryCode: 'OM',
      countryName: 'Oman',
      currencyCode: 'OMR',
      currencyName: 'Omani Rial',
      currencySymbol: 'ر.ع',
      flag: '🇴🇲',
      goldPricePerGram: 25.0,
      silverPricePerGram: 0.31,
    ),
    CountryZakatData(
      countryCode: 'JO',
      countryName: 'Jordan',
      currencyCode: 'JOD',
      currencyName: 'Jordanian Dinar',
      currencySymbol: 'د.أ',
      flag: '🇯🇴',
      goldPricePerGram: 46.0,
      silverPricePerGram: 0.57,
    ),
    CountryZakatData(
      countryCode: 'EG',
      countryName: 'Egypt',
      currencyCode: 'EGP',
      currencyName: 'Egyptian Pound',
      currencySymbol: 'ج.م',
      flag: '🇪🇬',
      goldPricePerGram: 2000.0,
      silverPricePerGram: 25.0,
    ),
    CountryZakatData(
      countryCode: 'TR',
      countryName: 'Turkey',
      currencyCode: 'TRY',
      currencyName: 'Turkish Lira',
      currencySymbol: '₺',
      flag: '🇹🇷',
      goldPricePerGram: 2100.0,
      silverPricePerGram: 26.0,
    ),
    CountryZakatData(
      countryCode: 'IR',
      countryName: 'Iran',
      currencyCode: 'IRR',
      currencyName: 'Iranian Rial',
      currencySymbol: '﷼',
      flag: '🇮🇷',
      goldPricePerGram: 2730000.0,
      silverPricePerGram: 33600.0,
    ),
    CountryZakatData(
      countryCode: 'IQ',
      countryName: 'Iraq',
      currencyCode: 'IQD',
      currencyName: 'Iraqi Dinar',
      currencySymbol: 'ع.د',
      flag: '🇮🇶',
      goldPricePerGram: 85000.0,
      silverPricePerGram: 1050.0,
    ),
    // Europe
    CountryZakatData(
      countryCode: 'GB',
      countryName: 'United Kingdom',
      currencyCode: 'GBP',
      currencyName: 'British Pound',
      currencySymbol: '£',
      flag: '🇬🇧',
      goldPricePerGram: 51.5,
      silverPricePerGram: 0.63,
    ),
    CountryZakatData(
      countryCode: 'DE',
      countryName: 'Germany',
      currencyCode: 'EUR',
      currencyName: 'Euro',
      currencySymbol: '€',
      flag: '🇩🇪',
      goldPricePerGram: 60.0,
      silverPricePerGram: 0.74,
    ),
    CountryZakatData(
      countryCode: 'FR',
      countryName: 'France',
      currencyCode: 'EUR',
      currencyName: 'Euro',
      currencySymbol: '€',
      flag: '🇫🇷',
      goldPricePerGram: 60.0,
      silverPricePerGram: 0.74,
    ),
    // Southeast Asia
    CountryZakatData(
      countryCode: 'MY',
      countryName: 'Malaysia',
      currencyCode: 'MYR',
      currencyName: 'Malaysian Ringgit',
      currencySymbol: 'RM',
      flag: '🇲🇾',
      goldPricePerGram: 305.0,
      silverPricePerGram: 3.75,
    ),
    CountryZakatData(
      countryCode: 'ID',
      countryName: 'Indonesia',
      currencyCode: 'IDR',
      currencyName: 'Indonesian Rupiah',
      currencySymbol: 'Rp',
      flag: '🇮🇩',
      goldPricePerGram: 1020000.0,
      silverPricePerGram: 12600.0,
    ),
    CountryZakatData(
      countryCode: 'SG',
      countryName: 'Singapore',
      currencyCode: 'SGD',
      currencyName: 'Singapore Dollar',
      currencySymbol: 'S\$',
      flag: '🇸🇬',
      goldPricePerGram: 87.0,
      silverPricePerGram: 1.07,
    ),
    // Africa
    CountryZakatData(
      countryCode: 'NG',
      countryName: 'Nigeria',
      currencyCode: 'NGN',
      currencyName: 'Nigerian Naira',
      currencySymbol: '₦',
      flag: '🇳🇬',
      goldPricePerGram: 52000.0,
      silverPricePerGram: 640.0,
    ),
    CountryZakatData(
      countryCode: 'ZA',
      countryName: 'South Africa',
      currencyCode: 'ZAR',
      currencyName: 'South African Rand',
      currencySymbol: 'R',
      flag: '🇿🇦',
      goldPricePerGram: 1200.0,
      silverPricePerGram: 14.8,
    ),
    CountryZakatData(
      countryCode: 'MA',
      countryName: 'Morocco',
      currencyCode: 'MAD',
      currencyName: 'Moroccan Dirham',
      currencySymbol: 'د.م',
      flag: '🇲🇦',
      goldPricePerGram: 650.0,
      silverPricePerGram: 8.0,
    ),
    // Australia
    CountryZakatData(
      countryCode: 'AU',
      countryName: 'Australia',
      currencyCode: 'AUD',
      currencyName: 'Australian Dollar',
      currencySymbol: 'A\$',
      flag: '🇦🇺',
      goldPricePerGram: 100.0,
      silverPricePerGram: 1.23,
    ),
    // Canada
    CountryZakatData(
      countryCode: 'CA',
      countryName: 'Canada',
      currencyCode: 'CAD',
      currencyName: 'Canadian Dollar',
      currencySymbol: 'C\$',
      flag: '🇨🇦',
      goldPricePerGram: 88.0,
      silverPricePerGram: 1.08,
    ),
    // North America
    CountryZakatData(
      countryCode: 'US',
      countryName: 'United States',
      currencyCode: 'USD',
      currencyName: 'US Dollar',
      currencySymbol: '\$',
      flag: '🇺🇸',
      goldPricePerGram: 65.0,
      silverPricePerGram: 0.80,
    ),
  ];
}
