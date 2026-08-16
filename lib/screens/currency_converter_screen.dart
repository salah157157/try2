import 'package:flutter/material.dart';
import '../widgets/modern_background.dart';

class CurrencyConverterScreen extends StatefulWidget {
  final String airportCode; // رمز المطار لتحديد العملة المحلية تلقائياً
  final bool isDarkMode; // متغير الوضع الليلي المتوافق مع باقي الشاشات

  const CurrencyConverterScreen({
    super.key,
    this.airportCode = 'CAI',
    required this.isDarkMode,
  });

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _AirportCurrency {
  final String code;
  final String name;
  final double rateToUsd; // سعر الصرف مقابل الدولار كعملة وسيطة مرجعية

  _AirportCurrency({required this.code, required this.name, required this.rateToUsd});
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();

  // قائمة بجميع العملات المعتمدة للمطارات والدول السابقة
  final List<_AirportCurrency> _currencies = [
    _AirportCurrency(code: 'LYD', name: 'دينار ليبي (LYD)', rateToUsd: 4.80),
    _AirportCurrency(code: 'USD', name: 'دولار أمريكي (USD)', rateToUsd: 1.00),
    _AirportCurrency(code: 'EUR', name: 'يورو أوروبي (EUR)', rateToUsd: 0.92),
    _AirportCurrency(code: 'SAR', name: 'ريال سعودي (SAR)', rateToUsd: 3.75),
    _AirportCurrency(code: 'AED', name: 'درهم إماراتي (AED)', rateToUsd: 3.67),
    _AirportCurrency(code: 'EGP', name: 'جنيه مصري (EGP)', rateToUsd: 49.50),
    _AirportCurrency(code: 'DZD', name: 'دينار جزائري (DZD)', rateToUsd: 134.00),
    _AirportCurrency(code: 'TND', name: 'دينار تونسي (TND)', rateToUsd: 3.10),
    _AirportCurrency(code: 'IQD', name: 'دينار عراقي (IQD)', rateToUsd: 1310.00),
    _AirportCurrency(code: 'SDG', name: 'جنيه سوداني (SDG)', rateToUsd: 1800.00),
    _AirportCurrency(code: 'OMR', name: 'ريال عماني (OMR)', rateToUsd: 0.385),
    _AirportCurrency(code: 'JOD', name: 'دينار أردني (JOD)', rateToUsd: 0.71),
  ];

  late _AirportCurrency _selectedCurrency;
  late String _localCurrencyCode;
  late String _localCurrencyName;
  double _convertedAmount = 0.0;

  @override
  void initState() {
    super.initState();
    // تحديد العملة المحلية بناءً على رمز المطار المرسل
    _initLocalCurrency();
    _selectedCurrency = _currencies.first;
    _amountController.addListener(_calculateConversion);
  }

  // ربط رمز المطار بالعملة المحلية الخاصة به
  void _initLocalCurrency() {
    switch (widget.airportCode) {
      case 'RUH': case 'JED': case 'DMM': case 'MED': case 'TIF':
        _localCurrencyCode = 'SAR';
        _localCurrencyName = 'ريال سعودي';
        break;
      case 'DXB': case 'AUH': case 'SHJ': case 'RKT':
        _localCurrencyCode = 'AED';
        _localCurrencyName = 'درهم إماراتي';
        break;
      case 'ALG': case 'ORN':
        _localCurrencyCode = 'DZD';
        _localCurrencyName = 'دينار جزائري';
        break;
      case 'TUN':
        _localCurrencyCode = 'TND';
        _localCurrencyName = 'دينار تونسي';
        break;
      case 'TIP':
        _localCurrencyCode = 'LYD';
        _localCurrencyName = 'دينار ليبي';
        break;
      case 'BGW':
        _localCurrencyCode = 'IQD';
        _localCurrencyName = 'دينار عراقي';
        break;
      case 'KRT': case 'PZU':
        _localCurrencyCode = 'SDG';
        _localCurrencyName = 'جنيه سوداني';
        break;
      case 'MCT':
        _localCurrencyCode = 'OMR';
        _localCurrencyName = 'ريال عماني';
        break;
      case 'AMM':
        _localCurrencyCode = 'JOD';
        _localCurrencyName = 'دينار أردني';
        break;
      case 'CAI': case 'HBE': case 'SSH': case 'HRG': case 'LXR': case 'ASW':
      default:
        _localCurrencyCode = 'EGP';
        _localCurrencyName = 'جنيه مصري';
        break;
    }
  }

  // حساب التحويل لأي عملة محلية عبر الدولار كعملة وسيطة
  void _calculateConversion() {
    final double input = double.tryParse(_amountController.text) ?? 0.0;
    
    // جلب بيانات العملة المحلية للمطار
    final localCurrObj = _currencies.firstWhere(
      (c) => c.code == _localCurrencyCode,
      orElse: () => _currencies.first,
    );

    setState(() {
      // التحويل: المبلغ ÷ سعر عملة الإدخال (للحصول على الدولار) × سعر العملة المحلية
      double amountInUsd = input / _selectedCurrency.rateToUsd;
      _convertedAmount = amountInUsd * localCurrObj.rateToUsd;
    });
  }

  void _setQuickAmount(double amount) {
    _amountController.text = amount.toStringAsFixed(0);
    _calculateConversion();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // حساب سعر الصرف الفردي للعرض بين العملة المختارة والعملة المحلية
    final localCurrObj = _currencies.firstWhere((c) => c.code == _localCurrencyCode, orElse: () => _currencies.first);
    double singleRate = localCurrObj.rateToUsd / _selectedCurrency.rateToUsd;

    // توحيد الألوان بناءً على المتغير القادم (مطابق لـ CountryMapScreen)
    final bool isDark = widget.isDarkMode;
    final Color bgColor = isDark ? const Color(0xFF0B1212) : const Color(0xFFF5F7F8);
    final Color appBarColor = isDark ? const Color(0xFF0F171A) : const Color(0xFF8c834a);
    final Color cardBgColor = isDark ? const Color(0xFF15201F) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subtitleColor = isDark ? Colors.grey.shade300 : Colors.grey.shade600;
    final Color inputFillColor = isDark ? const Color(0xFF1B2625) : Colors.grey.shade50;
    final Color borderColor = isDark ? Colors.white12 : Colors.grey.shade300;

    return Theme(
      data: isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "حاسبة العملات ($_localCurrencyCode)",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: appBarColor,
          centerTitle: true,
        ),
        body: ModernBackground(
          isDarkMode: isDark,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // كارت إدخال العملة والمبلغ
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "اختر العملة والمبلغ",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: inputFillColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: borderColor),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<_AirportCurrency>(
                                value: _selectedCurrency,
                                isExpanded: true,
                                dropdownColor: cardBgColor,
                                icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFFFB300)),
                                items: _currencies.map((currency) {
                                  return DropdownMenuItem<_AirportCurrency>(
                                    value: currency,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.monetization_on_outlined, color: Color(0xFFFFB300), size: 20),
                                        const SizedBox(width: 10),
                                        Text(
                                          currency.name,
                                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedCurrency = val;
                                      _calculateConversion();
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                            decoration: InputDecoration(
                              labelText: "المبلغ المراد تحويله",
                              labelStyle: TextStyle(color: subtitleColor),
                              hintText: "0.0",
                              hintStyle: TextStyle(color: subtitleColor.withOpacity(0.5)),
                              prefixIcon: const Icon(Icons.attach_money, color: Color(0xFFFFB300)),
                              suffixText: _selectedCurrency.code,
                              suffixStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFB300)),
                              filled: true,
                              fillColor: inputFillColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: borderColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: borderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Color(0xFFFFB300), width: 1.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [10, 50, 100, 200, 500, 1000].map((amount) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: ActionChip(
                                    label: Text("$amount ${_selectedCurrency.code}"),
                                    backgroundColor: isDark ? const Color(0xFF1B2625) : Colors.grey.shade200,
                                    labelStyle: TextStyle(
                                      color: isDark ? const Color(0xFFFFB300) : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(color: borderColor),
                                    ),
                                    onPressed: () => _setQuickAmount(amount.toDouble()),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // كارت النتيجة النهائية
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "المبلغ المقابل بالعملة المحلية ($_localCurrencyCode)",
                            style: TextStyle(color: subtitleColor, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 12),
                          FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  _convertedAmount.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _localCurrencyName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFB300),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "سعر الصرف التقريبي: 1 ${_selectedCurrency.code} ≈ ${singleRate.toStringAsFixed(2)} $_localCurrencyCode",
                              style: TextStyle(color: subtitleColor, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}