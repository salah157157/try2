import 'package:flutter/material.dart';

class ModernBackground extends StatelessWidget {
  final Widget child;
  final bool? isDarkMode; // 👈 إضافة هذا المتغير الاختياري

  const ModernBackground({
    super.key, 
    required this.child, 
    this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    // 👈 إذا تم تمرير isDarkMode نستخدمه، وإلا نتحقق من ثيم التطبيق العام
    final bool dark = isDarkMode ?? (Theme.of(context).brightness == Brightness.dark);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? [
                  const Color(0xFF121212), // أسود داكن
                  const Color(0xFF1E292B), // رمادي مائل للتركواز الداكن
                ]
              : [
                  const Color(0xFFF4F7F6), // أبيض عاجي هادئ
                  const Color(0xFFE0ECE9), // تركواز فاتح جداً
                ],
        ),
      ),
      child: Stack(
        children: [
          // شكل مودرن 1: دائرة ضبابية في الأعلى
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dark 
                    ? Colors.tealAccent.withOpacity(0.04) 
                    : Colors.teal.withOpacity(0.08),
              ),
            ),
          ),
          // شكل مودرن 2: منحنى هندسي ناعم في الأسفل
          Positioned(
            bottom: -100,
            left: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dark 
                    ? const Color(0xFFFFB300).withOpacity(0.03) 
                    : const Color(0xFFFFB300).withOpacity(0.06),
              ),
            ),
          ),
          // محتوى الصفحة الرئيسي
          child,
        ],
      ),
    );
  }
}