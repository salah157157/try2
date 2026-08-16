import 'package:flutter/material.dart';

import '../widgets/modern_background.dart';
import 'deaf_cards_screen.dart';
import 'gate_timer_and_assistance_screen.dart';
import 'mobility_facilities_screen.dart';
import 'sos_screen.dart';
import 'visual_journey_screen.dart';

class AccessibilityHubScreen extends StatefulWidget {
  final bool isDarkMode;
  const AccessibilityHubScreen({super.key, this.isDarkMode = true});

  @override
  State<AccessibilityHubScreen> createState() => _AccessibilityHubScreenState();
}

class _AccessibilityHubScreenState extends State<AccessibilityHubScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDarkMode;
    final Color bgColor = isDark ? const Color(0xFF0B1212) : const Color(0xFFF5F7F8);
    final Color cardColor = isDark ? const Color(0xFF15201F) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subTextColor = isDark ? Colors.grey.shade300 : Colors.grey.shade600;
    
    // اللون المطلوب للوضع النهاري #8c844c، ومثل CountryMap في الوضع الليلي
    final Color appBarColor = isDark ? const Color(0xFF0F171A) : const Color(0xFF8C844C);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "مركز تسهيلات ودعم ذوي الإعاقة",
          style: TextStyle(color: Colors.white), // الجملة باللون الأبيض في الوضع النهاري والليلي
        ),
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.sos, color: Colors.redAccent, size: 30),
            tooltip: "طوارئ SOS",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SosScreen()),
              );
            },
          )
        ],
      ),
      body: ModernBackground(
        isDarkMode: isDark,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // بطاقة التوضيح المتناسقة
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB300).withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.accessible, color: Color(0xFFFFB300), size: 30),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "خدمات السفر الميسّر 100% أوفلاين",
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "جميع الخدمات تعمل بدون الحاجة لإنترنت وتساعدك في جميع مراحل المطار.",
                                style: TextStyle(color: subTextColor, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // القائمة
                  _buildHubTile(context, "خدمات الصم والبكم", "بطاقات التنبيه البصري وكروت التواصل مع الموظفين", Icons.hearing_disabled, Colors.blue.shade700, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DeafCardsScreen())), isDark, cardColor, textColor, subTextColor),
                  _buildHubTile(context, "مؤقت اهتزاز البوابة وطلب الكرسي", "تنبيهات الاهتزاز الصارم للبوابات وتوليد طلبات المرافق", Icons.vibration, Colors.deepOrange.shade700, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GateTimerAndAssistanceScreen())), isDark, cardColor, textColor, subTextColor),
                  _buildHubTile(context, "الدعم الذهني والاضطرابات (Neurodiverse)", "الرحلة البصرية خطوة بخطوة وضع الهدوء وتقليل التوتر", Icons.psychology, Colors.purple.shade700, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VisualJourneyScreen())), isDark, cardColor, textColor, subTextColor),
                  _buildHubTile(context, "حقوق وتسهيلات الإعاقة الحركية", "الكراسي المجانية، المصاعد والمسارات السريعة", Icons.accessible_forward, Colors.orange.shade800, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MobilityFacilitiesScreen())), isDark, cardColor, textColor, subTextColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHubTile(BuildContext context, String title, String subtitle, IconData icon, Color iconColor, VoidCallback onTap, bool isDark, Color cardColor, Color textColor, Color subTextColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB300).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: const Color(0xFFFFB300), size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(color: subTextColor, fontSize: 12)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_back_ios_new, size: 16, color: isDark ? Colors.white70 : Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}