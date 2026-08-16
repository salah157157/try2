import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/modern_background.dart';

class CommunicationCard {
  final String titleAr;
  final String titleEn;
  final String category;

  const CommunicationCard({
    required this.titleAr,
    required this.titleEn,
    required this.category,
  });
}

class DeafCardsScreen extends StatefulWidget {
  final bool isDarkMode;
  const DeafCardsScreen({super.key, this.isDarkMode = true});

  @override
  State<DeafCardsScreen> createState() => _DeafCardsScreenState();
}

class _DeafCardsScreenState extends State<DeafCardsScreen> {
  final List<CommunicationCard> _cards = const [
    CommunicationCard(
      titleAr: "أنا غير قادر على السمع، يرجى كتابة التعليمات هنا.",
      titleEn: "I am deaf/hard of hearing. Please write instructions here.",
      category: "عام",
    ),
    CommunicationCard(
      titleAr: "أين يقع كاونتر استلام الحقائب الخاص برحلتي؟",
      titleEn: "Where is the baggage claim carousel for my flight?",
      category: "الحقائب",
    ),
    CommunicationCard(
      titleAr: "يرجى توجيهي إلى بوابة المغادرة المحددة في التذكرة.",
      titleEn: "Please guide me to my boarding gate.",
      category: "البوابة",
    ),
    CommunicationCard(
      titleAr: "أين يوجد المسار السريع (Priority Lane) للجوازات؟",
      titleEn: "Where is the Priority Passport Control Lane?",
      category: "الجوازات",
    ),
    CommunicationCard(
      titleAr: "أحتاج إلى مساعدة للوصول إلى سيارة التاكسي / المخرج.",
      titleEn: "I need assistance reaching the taxi / exit area.",
      category: "المواصلات",
    ),
  ];

  void _showFullScreenCard(BuildContext context, CommunicationCard card) {
    HapticFeedback.lightImpact();

    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.yellow, size: 36),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.yellow, width: 3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  card.titleAr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  card.titleEn,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.3,
                  ),
                ),
              ),
              const Spacer(),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.vibration, color: Colors.yellow),
                  SizedBox(width: 8),
                  Text(
                    "اعرض هذه الشاشة لموظف المطار مباشرة",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDarkMode;
    final Color bgColor = isDark ? const Color(0xFF0B1212) : const Color(0xFFF5F7F8);
    final Color cardColor = isDark ? const Color(0xFF15201F) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subTextColor = isDark ? Colors.grey.shade300 : Colors.grey.shade600;
    final Color appBarColor = isDark ? const Color(0xFF0F171A) : const Color(0xFF8C844C);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "بطاقات التواصل السريع",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ModernBackground(
        isDarkMode: isDark,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  final card = _cards[index];
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
                        onTap: () => _showFullScreenCard(context, card),
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
                                child: const Icon(Icons.record_voice_over, color: Color(0xFFFFB300), size: 28),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      card.titleAr,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      card.titleEn,
                                      style: TextStyle(color: subTextColor, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.fullscreen, color: isDark ? Colors.white70 : Colors.grey, size: 28),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}