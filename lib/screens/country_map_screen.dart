import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/modern_background.dart';
import '../services/timezone_service.dart'; // 👈 استيراد خدمة التوقيت

class CurrencyHelper {
  static String getCurrencyCode(String airportCode) {
    switch (airportCode) {
      case 'CAI': case 'HBE': case 'SSH': case 'HRG': case 'LXR': case 'ASW': return 'EGP';
      case 'RUH': case 'JED': case 'DMM': case 'MED': case 'TIF': return 'SAR';
      case 'DXB': case 'AUH': case 'SHJ': case 'RKT': return 'AED';
      case 'ALG': case 'ORN': return 'DZD';
      case 'TUN': return 'TND';
      case 'TIP': return 'LYD';
      case 'BGW': return 'IQD';
      case 'KRT': case 'PZU': return 'SDG';
      case 'MCT': return 'OMR';
      case 'AMM': return 'JOD';
      default: return 'USD';
    }
  }
}

class CountryMapScreen extends StatelessWidget {
  final String airportCode;
  final String airportName;
  final String cityName;
  final bool isDarkMode;

  const CountryMapScreen({
    super.key,
    required this.airportCode,
    required this.airportName,
    required this.cityName,
    this.isDarkMode = true,
  });

  static const Map<String, LatLng> _airportCoordinates = {
    'CAI': LatLng(30.1219, 31.4056), 'HBE': LatLng(30.9856, 29.6974),
    'SSH': LatLng(27.9773, 34.3946), 'HRG': LatLng(27.1818, 33.7997),
    'LXR': LatLng(25.6725, 32.7093), 'ASW': LatLng(23.9632, 32.7845),
    'RUH': LatLng(24.9576, 46.6985), 'JED': LatLng(21.6796, 39.1566),
    'DMM': LatLng(26.4711, 49.7978), 'MED': LatLng(24.5513, 39.7046),
    'TIF': LatLng(21.4828, 40.5401),
    'DXB': LatLng(25.2532, 55.3657), 'AUH': LatLng(24.4330, 54.6511),
    'SHJ': LatLng(25.3289, 55.5160), 'RKT': LatLng(25.6120, 55.9320),
    'ALG': LatLng(36.6908, 3.2131), 'ORN': LatLng(35.6267, -0.6200),
    'TUN': LatLng(36.8510, 10.2272), 'TIP': LatLng(32.8427, 13.2925),
    'BGW': LatLng(33.2618, 44.2370),
    'KRT': LatLng(15.5894, 32.5532), 'PZU': LatLng(19.5392, 37.2136),
    'MCT': LatLng(23.5933, 58.2838), 'AMM': LatLng(31.7223, 35.9933),
  };

  LatLng _getCityCoordinates() {
    return _airportCoordinates[airportCode] ?? const LatLng(30.0444, 31.2357);
  }

  Map<String, String> _getCountryInfo() {
    if (cityName.contains('مصر')) {
      return {'country': 'جمهورية مصر العربية', 'capital': 'القاهرة', 'currency': 'الجنيه المصري (EGP)', 'timezone': 'GMT+2', 'emergency': 'النجدة: 122 | الإسعاف: 123', 'desc': 'أرض الحضارة والتاريخ ونهر النيل الخالد.'};
    } else if (cityName.contains('السعودية')) {
      return {'country': 'المملكة العربية السعودية', 'capital': 'الرياض', 'currency': 'الريال السعودي (SAR)', 'timezone': 'GMT+3', 'emergency': 'الطوارئ: 911', 'desc': 'مهبط الوحي وقبلة المسلمين، وأرض التطور والنمو.'};
    } else if (cityName.contains('الإمارات')) {
      return {'country': 'الإمارات العربية المتحدة', 'capital': 'أبوظبي', 'currency': 'الدرهم الإماراتي (AED)', 'timezone': 'GMT+4', 'emergency': 'الشرطة: 999', 'desc': 'نموذج عالمي للحداثة والابتكار والوجهة السياحية الأولى.'};
    } else if (cityName.contains('الجزائر')) {
      return {'country': 'الجمهورية الجزائرية', 'capital': 'الجزائر', 'currency': 'الدينار الجزائري (DZD)', 'timezone': 'GMT+1', 'emergency': 'الشرطة: 17', 'desc': 'بلد المليون ونصف المليون شهيد، وتتميز بطبيعتها المتنوعة.'};
    } else if (cityName.contains('تونس')) {
      return {'country': 'الجمهورية التونسية', 'capital': 'تونس', 'currency': 'الدينار التونسي (TND)', 'timezone': 'GMT+1', 'emergency': 'الشرطة: 197', 'desc': 'جوهرة البحر الأبيض المتوسط وتاريخها الفينيقي العريق.'};
    } else if (cityName.contains('ليبيا')) {
      return {'country': 'دولة ليبيا', 'capital': 'طرابلس', 'currency': 'الدينار الليبي (LYD)', 'timezone': 'GMT+2', 'emergency': 'الشرطة: 1515', 'desc': 'أرض الصحراء الشاسعة والآثار الرومانية التاريخية.'};
    } else if (cityName.contains('العراق')) {
      return {'country': 'جمهورية العراق', 'capital': 'بغداد', 'currency': 'الدينار العراقي (IQD)', 'timezone': 'GMT+3', 'emergency': 'الشرطة: 104', 'desc': 'مهد الحضارات وبلاد ما بين النهرين الخالدة.'};
    } else if (cityName.contains('السودان')) {
      return {'country': 'جمهورية السودان', 'capital': 'الخرطوم', 'currency': 'الجنيه السوداني (SDG)', 'timezone': 'GMT+2', 'emergency': 'الشرطة: 999', 'desc': 'ملتقى النيلين وأرض الحضارات النوبية القديمة.'};
    } else if (cityName.contains('عمان')) {
      return {'country': 'سلطنة عمان', 'capital': 'مسقط', 'currency': 'الريال العماني (OMR)', 'timezone': 'GMT+4', 'emergency': 'الشرطة: 9999', 'desc': 'أرض الأصالة والهدوء وسحر الطبيعة والجبال.'};
    } else if (cityName.contains('الأردن')) {
      return {'country': 'المملكة الأردنية الهاشمية', 'capital': 'عمان', 'currency': 'الدينار الأردني (JOD)', 'timezone': 'GMT+3', 'emergency': 'الطوارئ: 911', 'desc': 'أرض التاريخ والبتراء وعبق الضيافة العربية.'};
    } else {
      return {'country': 'دولة عربية', 'capital': 'غير محدد', 'currency': 'غير محدد', 'timezone': 'GMT', 'emergency': 'الطوارئ: 112', 'desc': 'دليل المطار والمنطقة الجغرافية التابعة له.'};
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = _getCountryInfo();
    final LatLng cityCoordinates = _getCityCoordinates();

    // الاعتماد المباشر على airportCode وجلب الوقت الفعلي المحلي عبر TimezoneService
    final List<Map<String, String>> currentAirportList = [
      {'code': airportCode, 'name': airportName}
    ];
    DateTime localDt = TimezoneService.getTimeByAirport(airportCode, currentAirportList);
    String formattedTime = "${localDt.hour.toString().padLeft(2, '0')}:${localDt.minute.toString().padLeft(2, '0')} (${info['timezone'] ?? ''})";

    final bgColor = isDarkMode ? const Color(0xFF0B1212) : const Color(0xFFF5F7F8);
    final appBarColor = isDarkMode ? const Color(0xFF0F171A) : const Color(0xFF8c834a);

    return Theme(
      data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "دليل: ${info['country']}",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: appBarColor,
        ),
        body: ModernBackground(
          isDarkMode: isDarkMode,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildInfoCard(info),
                    const SizedBox(height: 20),
                    _buildMap(cityCoordinates),
                    const SizedBox(height: 20),
                    _buildInfoRow(Icons.location_city, "العاصمة", info['capital']!),
                    _buildInfoRow(Icons.monetization_on, "العملة", info['currency']!),
                    _buildInfoRow(Icons.access_time, "التوقيت", formattedTime),
                    _buildInfoRow(Icons.emergency, "الطوارئ", info['emergency']!),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(Map<String, String> info) {
    final cardBgColors = isDarkMode
        ? [const Color(0xFF15201F), const Color(0xFF1B2625)]
        : [Colors.white, Colors.white];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: cardBgColors,
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDarkMode ? Colors.white12 : Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            airportName,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            info['desc']!,
            style: TextStyle(
              color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(LatLng coord) {
    return SizedBox(
      height: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FlutterMap(
          options: MapOptions(initialCenter: coord, initialZoom: 13.0),
          children: [
           TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  // أضف هذا السطر إجبارياً لكي يتطابق مع معرف تطبيقك على الأندرويد:
  userAgentPackageName: 'com.rahhal.app',
),
            MarkerLayer(
              markers: [
                Marker(
                  point: coord,
                  child: const Icon(Icons.location_pin, color: Color(0xFFFFB300), size: 40),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    final rowBgColor = isDarkMode ? const Color(0xFF15201F) : Colors.white;
    final titleColor = isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700;
    final valueColor = isDarkMode ? Colors.white : Colors.black87;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: rowBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB300).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFFFFB300), size: 20),
          ),
          const SizedBox(width: 14),
          Text(
            title,
            style: TextStyle(color: titleColor, fontSize: 13),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}