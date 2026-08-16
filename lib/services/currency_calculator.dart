class CurrencyCalculator {
  // أسعار الصرف بالنسبة للدولار الأمريكي (1 دولار = X عملة محلية)
  // يمكن تحديث هذه القيم من API مستقبلاً
  static const Map<String, double> _rates = {
    'EGP': 49.50, // الجنيه المصري
    'SAR': 3.75,  // الريال السعودي
    'AED': 3.67,  // الدرهم الإماراتي
    'DZD': 134.0, // الدينار الجزائري
    'TND': 3.10,  // الدينار التونسي
    'LYD': 4.80,  // الدينار الليبي
    'IQD': 1310.0,// الدينار العراقي
    'SDG': 1800.0,// الجنيه السوداني
    'OMR': 0.385, // الريال العماني
    'JOD': 0.71,  // الدينار الأردني
  };

  /// جلب سعر الصرف لعملة معينة بالنسبة للدولار
  static double getRate(String currencyCode) {
    return _rates[currencyCode] ?? 1.0;
  }

  /// تحويل من العملة المحلية إلى عملة أخرى
  static double convert({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) {
    double amountInUsd = amount / getRate(fromCurrency);
    return amountInUsd * getRate(toCurrency);
  }
}