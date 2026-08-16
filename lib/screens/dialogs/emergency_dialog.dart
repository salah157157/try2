import 'package:flutter/material.dart';

class EmergencyDialogHelper {
  /// --- نافذة أرقام الطوارئ الديناميكية بناءً على المطار/الدولة ---
  static void show(BuildContext context, {String airportCode = 'EGY'}) {
    // جلب بيانات الطوارئ الخاصة بالدولة بناءً على كود المطار أو الدولة
    final emergencyData = _getEmergencyDataForAirport(airportCode);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.phone_in_talk_outlined, color: Colors.teal),
                          const SizedBox(width: 8),
                          Text(
                            "أرقام طوارئ ودعم (${emergencyData['countryName']})",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  
                  // الإسعاف الطبي
                  _buildEmergencyCard(
                    context,
                    title: "الإسعاف الطبي",
                    number: emergencyData['ambulance'],
                    icon: Icons.local_hospital,
                    color: Colors.red,
                  ),
                  
                  // الشرطة / النجدة
                  _buildEmergencyCard(
                    context,
                    title: emergencyData['policeTitle'],
                    number: emergencyData['police'],
                    icon: Icons.local_police,
                    color: Colors.blue,
                  ),
                  
                  // طوارئ الدعم أو السفارة الخاصة بالدولة
                  _buildEmergencyCard(
                    context,
                    title: emergencyData['supportTitle'],
                    number: emergencyData['supportNumber'],
                    subtitle: emergencyData['supportSubtitle'],
                    icon: Icons.support_agent,
                    color: Colors.teal,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// دالة لترجع البيانات بحسب كود المطار أو الدولة
  static Map<String, dynamic> _getEmergencyDataForAirport(String code) {
    switch (code.toUpperCase()) {
      // مصر (مثل مطار القاهرة CAI)
      case 'EGY':
      case 'CAI':
        return {
          'countryName': 'مصر',
          'ambulance': '123',
          'policeTitle': 'شرطة النجدة والسياحة',
          'police': '122',
          'supportTitle': 'خط الطوارئ السياحي والدعم',
          'supportNumber': '19654',
          'supportSubtitle': 'الدعم الموحد للزوار والرعايا',
        };
      
      // السعودية (مثل مطار الملك خالد RUH أو جدة JED)
      case 'KSA':
      case 'RUH':
      case 'JED':
        return {
          'countryName': 'السعودية',
          'ambulance': '997',
          'policeTitle': 'الأمن العام والشرطة',
          'police': '999',
          'supportTitle': 'طوارئ أمن الطرق والجهات المساعدة',
          'supportNumber': '911',
          'supportSubtitle': 'مركز القيادة الأمنية الموحد',
        };

      // الإمارات (مثل مطار دبي DXB أو أبوظبي AUH)
      case 'UAE':
      case 'DXB':
      case 'AUH':
        return {
          'countryName': 'الإمارات',
          'ambulance': '998',
          'policeTitle': 'الشرطة والنجدة',
          'police': '999',
          'supportTitle': 'الخدمات الإنسانية والطوارئ',
          'supportNumber': '993',
          'supportSubtitle': 'الدعم والمساعدة الفورية',
        };

      // الأردن (مثل مطار عمان AMM)
      case 'JOR':
      case 'AMM':
        return {
          'countryName': 'الأردن',
          'ambulance': '193',
          'policeTitle': 'الأمن العام (النجدة)',
          'police': '911',
          'supportTitle': 'شرطة السياحة',
          'supportNumber': '117129',
          'supportSubtitle': 'دعم وحماية السياح',
        };

      // الجزائر (مثل مطار الجزائرALG)
      case 'ALG':
      case 'DZA':
        return {
          'countryName': 'الجزائر',
          'ambulance': '14',
          'policeTitle': 'الأمن الوطني (الشرطة)',
          'police': '1548',
          'supportTitle': 'درك وطني / طوارئ',
          'supportNumber': '1055',
          'supportSubtitle': 'المساعدة والدعم السريع',
        };

      // السودان (مثل مطار الخرطوم KRT)
      case 'SDN':
      case 'KRT':
        return {
          'countryName': 'السودان',
          'ambulance': '333',
          'policeTitle': 'الشرطة والنجدة',
          'police': '999',
          'supportTitle': 'الإسعاف المركزي والدعم',
          'supportNumber': '791111',
          'supportSubtitle': 'طوارئ وخدمات الرعايا',
        };

      // ليبيا (مثل مطار طرابلس TIP أو بنغازي BEN)
      case 'LBY':
      case 'TIP':
      case 'BEN':
        return {
          'countryName': 'ليبيا',
          'ambulance': '193',
          'policeTitle': 'الشرطة والنجدة',
          'police': '193',
          'supportTitle': 'السلامة الوطنية والطوارئ',
          'supportNumber': '1515',
          'supportSubtitle': 'الدعم والمساعدة السريعة',
        };

      // عمان (مثل مطار مسقط MCT)
      case 'OMN':
      case 'MCT':
        return {
          'countryName': 'عمان',
          'ambulance': '9999',
          'policeTitle': 'شرطة عمان السلطانية',
          'police': '9999',
          'supportTitle': 'الهيئة العامة للدفاع المدني',
          'supportNumber': '24343666',
          'supportSubtitle': 'طوارئ الإغاثة والدعم',
        };

      // القيمة الافتراضية (مصر أو عام)
      default:
        return {
          'countryName': 'الدولة الحالية',
          'ambulance': '123',
          'policeTitle': 'الشرطة والنجدة',
          'police': '122',
          'supportTitle': 'دعم الطوارئ الشامل',
          'supportNumber': '112',
          'supportSubtitle': 'رقم الطوارئ الموحد',
        };
    }
  }

  static Widget _buildEmergencyCard(
    BuildContext context, {
    required String title,
    required String number,
    String? subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  number,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: color,
                    fontSize: 15,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filledTonal(
                style: IconButton.styleFrom(
                  backgroundColor: color.withOpacity(0.2),
                ),
                icon: Icon(Icons.call, color: color, size: 20),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("جاري الاتصال بـ $title ($number)...")),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}