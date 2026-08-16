import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimezoneService {
  // 🌍 خريطة تربط رموز المطارات (Airport Codes) بالمناطق الزمنية العالمية
  static const Map<String, String> airportTimezones = {
    // مصر
    'CAI': 'Africa/Cairo', 'HBE': 'Africa/Cairo', 'SSH': 'Africa/Cairo',
    'HRG': 'Africa/Cairo', 'LXR': 'Africa/Cairo', 'ASW': 'Africa/Cairo',
    // السعودية
    'RUH': 'Asia/Riyadh', 'JED': 'Asia/Riyadh', 'DMM': 'Asia/Riyadh',
    'MED': 'Asia/Riyadh', 'TIF': 'Asia/Riyadh',
    // الإمارات
    'DXB': 'Asia/Dubai', 'AUH': 'Asia/Dubai', 'SHJ': 'Asia/Dubai', 'RKT': 'Asia/Dubai',
    // الجزائر
    'ALG': 'Africa/Algiers', 'ORN': 'Africa/Algiers',
    // تونس
    'TUN': 'Africa/Tunis',
    // ليبيا
    'TIP': 'Africa/Tripoli',
    // العراق
    'BGW': 'Asia/Baghdad',
    // السودان
    'KRT': 'Africa/Khartoum', 'PZU': 'Africa/Khartoum',
    // عمان
    'MCT': 'Asia/Muscat',
    // الأردن
    'AMM': 'Asia/Amman',
  };

  // خريطة قديمة للدعم (الربط باستخدام مفتاح الدولة)
  static const Map<String, String> countryTimezones = {
    'egypt': 'Africa/Cairo',
    'saudi': 'Asia/Riyadh',
    'uae': 'Asia/Dubai',
    'algeria': 'Africa/Algiers',
    'tunisia': 'Africa/Tunis',
    'libya': 'Africa/Tripoli',
    'iraq': 'Asia/Baghdad',
    'sudan': 'Africa/Khartoum',
    'oman': 'Asia/Muscat',
    'jordan': 'Asia/Amman',
  };

  /// يجب استدعاء هذه الدالة في [main] عند بدء التطبيق
  static void initialize() {
    tz.initializeTimeZones();
  }

  /// 🕒 دالة جديدة ومباشرة للحصول على الوقت المحلي لأي مطار أوفلاين
  static DateTime getTimeByAirport(String airportCode, List<Map<String, String>> airportsList) {
    // الحصول على معرف المنطقة الزمنية للمطار، أو الافتراضي UTC في حال لم يُعثر عليه
    final String tzId = airportTimezones[airportCode] ?? 'UTC';
    final location = tz.getLocation(tzId);
    return tz.TZDateTime.now(location);
  }

  /// تحويل الوقت من منطقة زمنية لبلد إلى منطقة زمنية لبلد آخر
  static DateTime convertTime(DateTime dateTime, String fromCountryKey, String toCountryKey) {
    final fromLocation = tz.getLocation(countryTimezones[fromCountryKey] ?? 'UTC');
    final toLocation = tz.getLocation(countryTimezones[toCountryKey] ?? 'UTC');

    // تحويل الوقت المدخل إلى توقيت المصدر
    final sourceTime = tz.TZDateTime.from(dateTime, fromLocation);
    // تحويل الوقت من المصدر إلى الهدف
    return tz.TZDateTime.from(sourceTime, toLocation);
  }
}