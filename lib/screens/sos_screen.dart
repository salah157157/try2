import 'package:flutter/material.dart';
import '../services/haptic_service.dart';
import '../widgets/modern_background.dart'; // تأكد من استيراد الخلفية الموحدة

class SosScreen extends StatefulWidget {
  final bool isDarkMode;
  const SosScreen({super.key, this.isDarkMode = true});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  @override
  void initState() {
    super.initState();
    HapticService.heavyAlert();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDarkMode;
    final Color bgColor = isDark ? const Color(0xFF0B1212) : const Color(0xFFF5F7F8);
    final Color cardColor = isDark ? const Color(0xFF15201F) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    // تحديد لون AppBar ليتناسب مع الشاشات الأخرى (رقمي في النهاري، أسود في الليلي)
    final Color appBarColor = isDark ? const Color(0xFF0F171A) : const Color(0xFF8C844C);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("طلب مساعدة طارئة SOS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ModernBackground(
        isDarkMode: isDark,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.1),
                    border: Border.all(color: Colors.red, width: 4),
                  ),
                  child: const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.red),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.red.withOpacity(0.5)),
                  ),
                  child: Text(
                    "أنا بحاجة لمساعدة طارئة فورية!\nI NEED IMMEDIATE ASSISTANCE!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "يرجى توجيهي لأقرب نقطة إسعاف أو أمن المطار",
                  style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade700, fontSize: 16),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticService.triggerAlarmPattern();
                    },
                    icon: const Icon(Icons.vibration, color: Colors.white),
                    label: const Text("إطلاق اهتزاز التنبيه", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}