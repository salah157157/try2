import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/modern_background.dart'; // تأكد من مسار استيراد ملف الخلفية
import 'gate_timer_and_assistance_screen.dart';

class MobilityFacilitiesScreen extends StatelessWidget {
  final bool isDarkMode;
  const MobilityFacilitiesScreen({super.key, this.isDarkMode = true});

  @override
  Widget build(BuildContext context) {
    final bool isDark = isDarkMode;
    final Color cardColor = isDark ? const Color(0xFF15201F) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subTextColor = isDark ? Colors.grey.shade300 : Colors.grey.shade600;
    final Color appBarColor = isDark ? const Color(0xFF0F171A) : const Color(0xFF8C844C);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تسهيلات الإعاقة الحركية', style: TextStyle(color: Colors.white)),
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ModernBackground(
        isDarkMode: isDark,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // بنر ترحيبي
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF15201F) : Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? Colors.white12 : Colors.teal.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.accessible_sharp, size: 40, color: isDark ? const Color(0xFFFFB300) : Colors.teal.shade800),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'يوفر المطار كافة التسهيلات لضمان تنقل ميسر وآمن لأصحاب الهمم وذوي الإعاقة الحركية.',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // قائمة التسهيلات
              _buildFacilityCard(context, Icons.wheelchair_pickup, 'الكراسي المتحركة المجانية', 'تتوفر الكراسي عند جميع كاونترات إنهاء إجراءات السفر، ويمكنك طلبها مع مرافق لخدمتك حتى باب الطائرة.', isDark, cardColor, textColor, subTextColor),
              _buildFacilityCard(context, Icons.priority_high_rounded, 'المسارات السريعة (Priority Lanes)', 'مسارات مخصصة لتجاوز الازدحام عند التفتيش الأمني وكاونترات الجوازات بسرعة وسهولة.', isDark, cardColor, textColor, subTextColor),
              _buildFacilityCard(context, Icons.wc, 'دورات مياه مجهزة بالكامل', 'دورات مياه واسعة ومجهزة بمقابض مساعدة وأزرار طوارئ متوفرة بالقرب من جميع الحصص العامة.', isDark, cardColor, textColor, subTextColor),
              _buildFacilityCard(context, Icons.elevator, 'رمبات ومصاعد مخصصة', 'جميع الممرات والمستويات داخل المطار مزودة برمبات انسيابية ومصاعد واسعة مزودة بأزرار منخفضة.', isDark, cardColor, textColor, subTextColor),

              const SizedBox(height: 24),

              // زر العمليات
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const GateTimerAndAssistanceScreen()));
                  },
                  icon: const Icon(Icons.add_task_rounded, color: Colors.white),
                  label: const Text('تقديم طلب كرسي / مرافق الآن', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8C844C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFacilityCard(BuildContext context, IconData icon, String title, String description, bool isDark, Color cardColor, Color textColor, Color subTextColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB300).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFFFB300), size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                const SizedBox(height: 6),
                Text(description, style: TextStyle(color: subTextColor, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}