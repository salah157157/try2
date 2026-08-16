import 'package:flutter/material.dart';

class TransportDialogHelper {
  /// --- نافذة المواصلات الديناميكية حسب المطار ---
  static void show(BuildContext context, String airportCode) {
    final transportData = _getTransportData(airportCode);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF15201F), // متوافق مع نمط الثيم الداكن للتطبيق
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
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
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.local_taxi_outlined, color: Color(0xFFFFB300)),
                          const SizedBox(width: 8),
                          Text(
                            "خيارات المواصلات (${transportData['cityName']})",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
                  const Divider(height: 24, color: Colors.white12),
                  
                  // قائمة الخيارات للمطار المحدد
                  ...((transportData['options'] as List).map((opt) {
                    return _buildTransportCard(
                      context,
                      title: opt['title'],
                      cost: opt['cost'],
                      note: opt['note'],
                      icon: opt['icon'],
                      color: opt['color'],
                      buttonText: opt['buttonText'],
                      buttonIcon: opt['buttonIcon'],
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(opt['actionMsg'])),
                        );
                      },
                    );
                  })),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// قاعدة بيانات المواصلات بناءً على كود المطار
  static Map<String, dynamic> _getTransportData(String code) {
    switch (code) {
      // --- مصر ---
      case 'CAI': case 'HBE': case 'SSH': case 'HRG': case 'LXR': case 'ASW':
        return {
          'cityName': 'مصر',
          'options': [
            {
              'title': 'تطبيقات النقل الذكي (Uber / InDrive)',
              'cost': '150 - 300 جنيه مصري',
              'note': 'اطلب السيارة واتجه لنقطة Pick-Up المخصصة خارج صالة الوصول.',
              'icon': Icons.directions_car,
              'color': const Color(0xFFFFB300),
              'buttonText': 'طلب رحلة',
              'buttonIcon': Icons.open_in_new,
              'actionMsg': 'جاري تحويلك لتطبيق النقل...',
            },
            {
              'title': 'أتوبيسات النقل العام / Shuttle Bus',
              'cost': '10 - 35 جنيه مصري',
              'note': 'متاح خارج صالات الوصول لربط المطار بالمخارج الرئيسية للمدينة.',
              'icon': Icons.directions_bus,
              'color': Colors.blue,
              'buttonText': 'الموقع بالخريطة',
              'buttonIcon': Icons.map_outlined,
              'actionMsg': 'جاري عرض موقع الحافلات أوفلاين...',
            },
            {
              'title': 'تاكسي المطار الرسمي',
              'cost': 'حسب العداد أو الاتفاق المسبق',
              'note': 'متواجد أمام بوابة الخروج مباشرة، تأكد من تشغيل العداد.',
              'icon': Icons.local_taxi,
              'color': Colors.teal,
              'buttonText': 'إرشادات',
              'buttonIcon': Icons.info_outline,
              'actionMsg': 'تأكد دائماً من تشغيل العداد أو الاتفاق مسبقاً.',
            },
          ],
        };

      // --- السعودية ---
      case 'RUH': case 'JED': case 'DMM': case 'MED': case 'TIF':
        return {
          'cityName': 'المملكة العربية السعودية',
          'options': [
            {
              'title': 'تطبيقات النقل (Uber / Careem / Bolt)',
              'cost': '40 - 90 ريال سعودي',
              'note': 'المناطق المخصصة للركاب محددة بلوحات إرشادية واضحة خارج الصالة.',
              'icon': Icons.directions_car,
              'color': const Color(0xFFFFB300),
              'buttonText': 'طلب رحلة',
              'buttonIcon': Icons.open_in_new,
              'actionMsg': 'جاري فتح تطبيق النقل...',
            },
            {
              'title': 'قطار المطار (سار - قطار الحرمين إن وجد)',
              'cost': '15 - 35 ريال سعودي',
              'note': 'متوفر في مطارات محددة للربط السريع بوسط المدينة.',
              'icon': Icons.train,
              'color': Colors.indigo,
              'buttonText': 'المواعيد',
              'buttonIcon': Icons.schedule,
              'actionMsg': 'عرض جدول مواعيد القطارات أوفلاين.',
            },
            {
              'title': 'أجرة المطار الرسمية (تكاسي أمانة المدينة)',
              'cost': 'حسب عداد التاكسي أو التطبيق المعتمد',
              'note': 'موقف التاكسي الرسمي متواجد عند بوابة خروج المسافرين.',
              'icon': Icons.local_taxi,
              'color': Colors.teal,
              'buttonText': 'تعليمات',
              'buttonIcon': Icons.info_outline,
              'actionMsg': 'الالتزام بالتاكسي المرخص لسلامتك.',
            },
          ],
        };

      // --- الإمارات ---
      case 'DXB': case 'AUH': case 'SHJ': case 'RKT':
        return {
          'cityName': 'الإمارات العربية المتحدة',
          'options': [
            {
              'title': 'مترو دبي / حافلات النقل العام (RTA)',
              'cost': '5 - 10 درهم إماراتي',
              'note': 'محطة المترو متواجدة مباشرة في المبنى (مطار دبي DXB).',
              'icon': Icons.train,
              'color': Colors.red,
              'buttonText': 'خطة الرحلة',
              'buttonIcon': Icons.map,
              'actionMsg': 'عرض خريطة ومحطات مترو المطار...',
            },
            {
              'title': 'تطبيقات النقل الذكي (Uber / Careem / Hala)',
              'cost': '50 - 120 درهم إماراتي',
              'note': 'خدمة سريعة ومتاحة على مدار الساعة عند بوابات الخروج.',
              'icon': Icons.directions_car,
              'color': const Color(0xFFFFB300),
              'buttonText': 'طلب رحلة',
              'buttonIcon': Icons.open_in_new,
              'actionMsg': 'جاري الاتصال بالتطبيقات...',
            },
            {
              'title': 'تاكسي المطار (مركبات حكومية مرخصة)',
              'cost': 'يبدأ عداد الأجرة من 25 درهم',
              'note': 'موقف سيارات الأجرة مخصص ومنظم بدقة أمام صالات الوصول.',
              'icon': Icons.local_taxi,
              'color': Colors.teal,
              'buttonText': 'معلومات',
              'buttonIcon': Icons.info_outline,
              'actionMsg': 'تاكسي المطار مؤمن ومهيء بالكامل.',
            },
          ],
        };

      // --- الجزائر ---
      case 'ALG': case 'ORN':
        return {
          'cityName': 'الجزائر',
          'options': [
            {
              'title': 'سيارات الأجرة الرسمية للمطار',
              'cost': '1500 - 3000 دينار جزائري',
              'note': 'متواجدة حصرياً في المحطة المخصصة للسيارات خارج صالة الوصول.',
              'icon': Icons.local_taxi,
              'color': const Color(0xFFFFB300),
              'buttonText': 'إرشادات',
              'buttonIcon': Icons.info_outline,
              'actionMsg': 'تأكد من الاتفاق على السعر قبل التحرك.',
            },
            {
              'title': 'حافلات النقل العمومي (ETUSA)',
              'cost': '100 - 200 دينار جزائري',
              'note': 'تربط المطار بوسط العاصمة والمدن المجاورة بانتظام.',
              'icon': Icons.directions_bus,
              'color': Colors.blue,
              'buttonText': 'المحطات',
              'buttonIcon': Icons.map_outlined,
              'actionMsg': 'عرض خطوط الحافلات أوفلاين.',
            },
          ],
        };

      // --- تونس ---
      case 'TUN':
        return {
          'cityName': 'تونس',
          'options': [
            {
              'title': 'سيارات الأجرة الصفراء (التاكسي الفردي)',
              'cost': '20 - 40 دينار تونسي',
              'note': 'الموقف الرسمي متواجد مباشرة خارج قاعة الوصول.',
              'icon': Icons.local_taxi,
              'color': const Color(0xFFFFB300),
              'buttonText': 'تعليمات',
              'buttonIcon': Icons.info_outline,
              'actionMsg': 'تأكد من عمل العداد الخاص بالتاكسي.',
            },
            {
              'title': 'الحافلات الجهوية والمحلية',
              'cost': '2 - 5 دينار تونسي',
              'note': 'خيار اقتصادي للوصول إلى محطات النقل بوسط المدينة.',
              'icon': Icons.directions_bus,
              'color': Colors.blue,
              'buttonText': 'الموقع',
              'buttonIcon': Icons.map_outlined,
              'actionMsg': 'عرض خطوط النقل أوفلاين.',
            },
          ],
        };

      // --- ليبيا ---
      case 'TIP':
        return {
          'cityName': 'ليبيا',
          'options': [
            {
              'title': 'سيارات الأجرة الخاصة (التاكسي)',
              'cost': 'حسب الاتفاق المسبق مع السائق',
              'note': 'تتوفر خيارات النقل أمام بوابات الخروج الرئيسية للمطار.',
              'icon': Icons.local_taxi,
              'color': const Color(0xFFFFB300),
              'buttonText': 'توجيهات',
              'buttonIcon': Icons.info_outline,
              'actionMsg': 'يوصى بالاتفاق على السعر قبل الركوب.',
            },
          ],
        };

      // --- العراق ---
      case 'BGW':
        return {
          'cityName': 'العراق',
          'options': [
            {
              'title': 'تاكسي المطار الرسمي (المرخص)',
              'cost': '25,000 - 40,000 دينار عراقي',
              'note': 'موقف آمن ومرخص داخل ساحة المطار لنقل المسافرين.',
              'icon': Icons.local_taxi,
              'color': const Color(0xFFFFB300),
              'buttonText': 'معلومات',
              'buttonIcon': Icons.info_outline,
              'actionMsg': 'استخدم التاكسي المرخص المعتمد داخل المطار.',
            },
            {
              'title': 'تطبيقات النقل الذكي (مثل بيشر / كريم)',
              'cost': '20,000 - 35,000 دينار عراقي',
              'note': 'تواصل مع السائق لتحديد نقطة اللقاء خارج البوابات الأمنية.',
              'icon': Icons.directions_car,
              'color': Colors.teal,
              'buttonText': 'طلب',
              'buttonIcon': Icons.open_in_new,
              'actionMsg': 'جاري فتح تطبيق النقل...',
            },
          ],
        };

      // --- السودان ---
      case 'KRT': case 'PZU':
        return {
          'cityName': 'السودان',
          'options': [
            {
              'title': 'سيارات الأجرة المحلية',
              'cost': 'حسب الاتفاق المباشر مع السائق',
              'note': 'متواجدة أمام بوابات المطار الرئيسية.',
              'icon': Icons.local_taxi,
              'color': const Color(0xFFFFB300),
              'buttonText': 'إرشادات',
              'buttonIcon': Icons.info_outline,
              'actionMsg': 'يرجى الاتفاق على قيمة الأجرة مسبقاً.',
            },
          ],
        };

      // --- عمان ---
      case 'MCT':
        return {
          'cityName': 'سلطنة عمان',
          'options': [
            {
              'title': 'تاكسي المطار الرسمي (Marhaba Taxi)',
              'cost': '8 - 15 ريال عماني',
              'note': 'متاح على مدار الساعة ومزود بنظام عداد أو أسعار محددة.',
              'icon': Icons.local_taxi,
              'color': const Color(0xFFFFB300),
              'buttonText': 'حجز',
              'buttonIcon': Icons.open_in_new,
              'actionMsg': 'طلب تاكسي مطار مسقط...',
            },
            {
              'title': 'تطبيقات النقل (Otaxi)',
              'cost': '5 - 12 ريال عماني',
              'note': 'الخيار الأفضل والأكثر توفيراً عبر التطبيق الذكي.',
              'icon': Icons.directions_car,
              'color': Colors.green,
              'buttonText': 'فتح التطبيق',
              'buttonIcon': Icons.phone_android,
              'actionMsg': 'جاري فتح Otaxi...',
            },
          ],
        };

      // --- الأردن ---
      case 'AMM':
        return {
          'cityName': 'الأردن',
          'options': [
            {
              'title': 'تاكسي مطار الملكة علياء الدولي',
              'cost': '20 - 25 دينار أردني (سعر ثابت لوسط العاصمة)',
              'note': 'مكتب التاكسي الرسمي متواجد في صالة القادمين (مضمون وثابت).',
              'icon': Icons.local_taxi,
              'color': const Color(0xFFFFB300),
              'buttonText': 'تفاصيل',
              'buttonIcon': Icons.info_outline,
              'actionMsg': 'احصل على تسجيلة التاكسي من المكتب الرسمي.',
            },
            {
              'title': 'تطبيقات النقل الذكي (Uber / Careem)',
              'cost': '15 - 22 دينار أردني',
              'note': 'نقطة الركوب المخصصة للتطبيقات تقع خارج منطقة المغادرة/الوصول.',
              'icon': Icons.directions_car,
              'color': Colors.teal,
              'buttonText': 'طلب رحلة',
              'buttonIcon': Icons.open_in_new,
              'actionMsg': 'جاري تحويلك لتطبيق النقل...',
            },
            {
              'title': 'حافلة المطار (السريعة - صقر)',
              'cost': '3.35 دينار أردني للفرد',
              'note': 'تنطلق كل نصف ساعة باتجاه مجمع محطة الشمال.',
              'icon': Icons.directions_bus,
              'color': Colors.blue,
              'buttonText': 'المواعيد',
              'buttonIcon': Icons.schedule,
              'actionMsg': 'عرض مواعيد الحافلات أوفلاين.',
            },
          ],
        };

      // --- افتراضي (Default) ---
      default:
        return {
          'cityName': 'وجهة السفر',
          'options': [
            {
              'title': 'تاكسي المطار الرسمي',
              'cost': 'حسب تسعيرة المطار أو العداد',
              'note': 'توجه إلى الموقف الرسمي المعتمد خارج صالة الوصول لسلامتك.',
              'icon': Icons.local_taxi,
              'color': const Color(0xFFFFB300),
              'buttonText': 'إرشادات',
              'buttonIcon': Icons.info_outline,
              'actionMsg': 'احرص على استخدام وسائل النقل الرسمية.',
            },
          ],
        };
    }
  }

  static Widget _buildTransportCard(
    BuildContext context, {
    required String title,
    required String cost,
    required String note,
    required IconData icon,
    required Color color,
    required String buttonText,
    required IconData buttonIcon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2625), // لون متناسق مع كروت التطبيق الداكنة
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB300).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFFFB300).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.payments_outlined, size: 14, color: Color(0xFFFFB300)),
                const SizedBox(width: 4),
                Text(
                  "التكلفة المتوقعة: $cost",
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFFB300)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            note,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(buttonIcon, size: 16),
              label: Text(buttonText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}