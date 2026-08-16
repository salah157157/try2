import 'package:flutter/material.dart';

class TelecomDialogHelper {
  /// --- نافذة شرائح الاتصال مع دعم المطارات ---
  static void show(BuildContext context, {required String airportCode}) {
    // جلب بيانات الشركات الخاصة بالمطار المحدد
    final List<Map<String, dynamic>> telecomList = _getTelecomDataForAirport(airportCode);

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
                      const Row(
                        children: [
                          Icon(Icons.cell_tower, color: Colors.teal),
                          SizedBox(width: 8),
                          Text(
                            "شرائح النت والاتصالات",
                            style: TextStyle(
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
                  
                  // عرض الشركات المتاحة للمطار أو رسالة في حال عدم توفر بيانات
                  if (telecomList.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          "لا توجد بيانات متاحة لشرائح الاتصال لهذا المطار حالياً",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                    )
                  else
                    ...telecomList.map((data) => _buildTelecomCard(
                          context,
                          companyName: data['companyName'],
                          location: data['location'],
                          package: data['package'],
                          documents: data['documents'],
                          logoColor: data['logoColor'],
                          badgeText: data['badgeText'],
                        )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// قاعدة بيانات مبسطة لشركات الاتصالات حسب كود المطار
  static List<Map<String, dynamic>> _getTelecomDataForAirport(String airportCode) {
    switch (airportCode) {
      // 🇪🇬 مصر
      case 'CAI':
      case 'HBE':
      case 'SSH':
      case 'HRG':
      case 'LXR':
      case 'ASW':
        return [
          {
            'companyName': "Vodafone / فودافون",
            'location': "صالة الوصول - مقابل بوابة الخروج",
            'package': "كارت السياحة 20GB (~250 جنيه)",
            'documents': "جواز السفر الأصلي",
            'logoColor': Colors.red,
            'badgeText': "الأعلى تغطية",
          },
          {
            'companyName': "Orange / أورنج",
            'location': "صالة الوصول - بجانب مكتب الاستعلامات",
            'package': "باقة الزائر 15GB (~200 جنيه)",
            'documents': "جواز السفر الأصلي",
            'logoColor': Colors.orange.shade800,
            'badgeText': "اقتصادي",
          },
          {
            'companyName': "Etisalat / إتصالات",
            'location': "صالة الوصول - صالة السفر",
            'package': "باقة السائح 18GB (~220 جنيه)",
            'documents': "جواز السفر الأصلي",
            'logoColor': Colors.green,
            'badgeText': "سرعة عالية",
          },
        ];

      // 🇸🇦 السعودية
      case 'RUH':
      case 'JED':
      case 'DMM':
      case 'MED':
      case 'TIF':
        return [
          {
            'companyName': "STC / إس تي سي",
            'location': " صالة القادمين - صالة الاتصالات",
            'package': "باقة سوا زيارة 10GB (~150 ريال)",
            'documents': "جواز السفر والبصمة",
            'logoColor': Colors.purple,
            'badgeText': "الأفضل للأعمال",
          },
          {
            'companyName': "Mobily / موبايلي",
            'location': "صالة القادمين الدوليين",
            'package': "باقة زائر 15GB (~140 ريال)",
            'documents': "جواز السفر",
            'logoColor': Colors.blue,
            'badgeText': "عرض مميز",
          },
          {
            'companyName': "Zain / زين",
            'location': "صالة الوصول",
            'package': "خط الزوار 20GB (~160 ريال)",
            'documents': "جواز السفر",
            'logoColor': Colors.amber.shade800,
            'badgeText': "انترنت غير محدود (تطبيقات)",
          },
        ];

      // 🇦🇪 الإمارات
      case 'DXB':
      case 'AUH':
      case 'SHJ':
      case 'RKT':
        return [
          {
            'companyName': "du / دو",
            'location': "صالة الوصول (توزيع شريحة مجانية 1GB)",
            'package': "باقة السياح 20GB (~125 درهم)",
            'documents': "جواز السفر وتأشيرة الدخول",
            'logoColor': Colors.blueAccent,
            'badgeText': "شريحة مجانية عند الوصول",
          },
          {
            'companyName': "e& / اتصالات الإمارات",
            'location': "منطقة استلام الأمتعة وصالة الوصول",
            'package': "باقة زوار اتصالات 10GB (~130 درهم)",
            'documents': "جواز السفر",
            'logoColor': Colors.redAccent,
            'badgeText': "شبكة قوية جداً",
          },
        ];

      // 🇩🇿 الجزائر
      case 'ALG':
      case 'ORN':
        return [
          {
            'companyName': "Mobilis / موبيليس",
            'location': "صالة القادمين الدوليين",
            'package': "شريحةالسياح 10GB (~1000 دينار)",
            'documents': "جواز السفر",
            'logoColor': Colors.blue,
            'badgeText': "الأوسع انتشاراً",
          },
          {
            'companyName': "Djezzy / جيزي",
            'location': "صالة الوصول",
            'package': "باقة الانترنت اليومية/الشهرية",
            'documents': "جواز السفر",
            'logoColor': Colors.red,
            'badgeText': "اقتصادي",
          },
        ];

      // 🇹🇳 تونس
      case 'TUN':
        return [
          {
            'companyName': "Ooredoo Tunisia / أوريدو",
            'location': "صالة الوصول بمطار تونس قرطاج",
            'package': "Tourist Pack 25GB (~30 دينار)",
            'documents': "جواز السفر",
            'logoColor': Colors.red,
            'badgeText': "الأفضل اتصالاً",
          },
          {
            'companyName': "Tunisie Telecom",
            'location': "صالة الوصول",
            'package': "خط الاتصال السريع",
            'documents': "جواز السفر",
            'logoColor': Colors.blue,
            'badgeText': "تغطية شاملة",
          },
        ];

      // 🇸🇩 السودان
      case 'KRT':
      case 'PZU':
        return [
          {
            'companyName': "MTN Sudan / إم تي إن",
            'location': "صالة الوصول بالمطار",
            'package': "باقة الإنترنت السريعة",
            'documents': "جواز السفر / الرقم الوطني",
            'logoColor': Colors.yellow.shade800,
            'badgeText': "الأسرع إنترنت",
          },
          {
            'companyName': "Zain Sudan / زين",
            'location': "صالة الوصول",
            'package': "باقات المكالمات والنت",
            'documents': "جواز السفر",
            'logoColor': Colors.red,
            'badgeText': "الأكثر انتشاراً",
          },
          {
            'companyName': " Sudani / سوداني",
            'location': "صالة الوصول بالمطار",
            'package': "باقة الإنترنت السريعة",
            'documents': "جواز السفر / الرقم الوطني",
            'logoColor': const Color.fromARGB(255, 19, 105, 130),
            'badgeText': " الارخص سعرا",
          },
        ];

        // --- ليبيا (LY) ---
      case 'TIP': // مطار طرابلس الدولي
      case 'BEN': // مطار بنينا الدولي
        return [
          {
            'companyName': "Libyana / ليبيانا",
            'location': "صالة الوصول بالمطار / نقاط البيع",
            'package': "باقة نت (4G/5G) ومكالمات",
            'documents': "جواز السفر / إثبات الهوية",
            'logoColor': Colors.green.shade700,
            'badgeText': "الأكثر تغطية",
          },
          {
            'companyName': "Al-Madar Al-Jadeed / المدار الجديد",
            'location': "صالة الوصول بالمطار",
            'package': "باقات الإنترنت المميزة",
            'documents': "جواز السفر",
            'logoColor': Colors.blue.shade900,
            'badgeText': "خدمات مميزة",
          },
        ];

      default:
        // في حال لم يتم العثور على المطار، يتم إرجاع قائمة افتراضية عامة
        return [
          {
            'companyName': "مزود خدمة محلي / International SIM",
            'location': "صالة الوصول الرئيسية بالمطار",
            'package': "باقة السياح الأساسية",
            'documents': "جواز السفر الأصلي",
            'logoColor': Colors.teal,
            'badgeText': "موصى به",
          },
        ];
    }
  }

  static Widget _buildTelecomCard(
    BuildContext context, {
    required String companyName,
    required String location,
    required String package,
    required String documents,
    required Color logoColor,
    required String badgeText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: logoColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.sim_card, color: logoColor, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    companyName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: logoColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: logoColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            iconColor: Colors.red.shade400,
            label: "الموقع",
            value: location,
          ),
          const SizedBox(height: 6),
          _buildInfoRow(
            icon: Icons.wifi,
            iconColor: Colors.teal,
            label: "أفضل باقة",
            value: package,
            isBold: true,
          ),
          const SizedBox(height: 6),
          _buildInfoRow(
            icon: Icons.badge_outlined,
            iconColor: Colors.blue,
            label: "المستندات",
            value: documents,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("موقع كاونتر $companyName: $location")),
                  );
                },
                icon: const Icon(Icons.map_outlined, size: 15),
                label: const Text("الموقع بالصالة", style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: logoColor,
                  side: BorderSide(color: logoColor.withOpacity(0.4)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    bool isBold = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 6),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}