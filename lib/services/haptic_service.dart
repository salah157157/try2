import 'package:flutter/services.dart';

class HapticService {
  // اهتزاز للتنبيه الخفيف (مثل التنقل)
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  // اهتزاز للتنبيه القوي عند الوصول لمرحلة مهمة
  static void heavyAlert() {
    HapticFeedback.heavyImpact();
  }

  // نمط اهتزاز مخصص للتنبيه الصوتي/البصري
  static Future<void> vibrationPattern() async {
    await HapticFeedback.vibrate();
    await Future.delayed(const Duration(milliseconds: 200));
    await HapticFeedback.vibrate();
  }

  // إضافة هذه الدالة لحل المشكلة مباشرة
  static Future<void> triggerAlarmPattern() async {
    for (int i = 0; i < 4; i++) {
      await HapticFeedback.vibrate();
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }
}