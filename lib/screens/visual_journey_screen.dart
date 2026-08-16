import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/modern_background.dart';

class VisualJourneyScreen extends StatefulWidget {
  final bool isDarkMode;
  const VisualJourneyScreen({super.key, this.isDarkMode = true});

  @override
  State<VisualJourneyScreen> createState() => _VisualJourneyScreenState();
}

class _VisualJourneyScreenState extends State<VisualJourneyScreen> {
  // القائمة البرمجية للمراحل مع تفاصيل عملية إضافية
  final List<Map<String, dynamic>> _steps = [
    {
      'number': '1',
      'title': 'الوصول وصالة المغادرة',
      'desc': 'يدخل المسافر الصالة الرئيسية. المكان يحتوي على حركة مستمرة وأصوات إعلانات.',
      'badge': '🔊 ضوضاء متوسطة',
      'tips': [
        'جهّز تذكرة الطيران أو الهوية قبل الدخول.',
        'يمكنك ارتداء سماعات العزل إذا كانت الأصوات مزعجة.',
      ],
      'isDone': false,
    },
    {
      'number': '2',
      'title': 'تفتيش الأمتعة والأجهزة',
      'desc': 'وضع الحقائب على السير. سيتوجب عليك المرور عبر جهاز كشف المعادن.',
      'badge': '👥 ازدحام متوقع',
      'tips': [
        'أخرج السوائل والأجهزة الإلكترونية من الحقيبة.',
        'اخلع الأحزمة والسترات الثقيلة والساعة وضعتها في السلة.',
      ],
      'isDone': false,
    },
    {
      'number': '3',
      'title': 'كاونتر الجوازات',
      'desc': 'تقديم الجواز ورقم الرحلة للموظف. الإجراء يستغرق دقائق بسيطة.',
      'badge': '🤫 منطقة هادئة منظمة',
      'tips': [
        'قف خلف الخط الأصفر حتى يناديك الموظف.',
        'تأكد من تجهيز جواز السفر وكرت صعود الطائرة.',
      ],
      'isDone': false,
    },
    {
      'number': '4',
      'title': 'الانتظار عند بوابة الصعود',
      'desc': 'الجلوس في المنطقة المخصصة للبوابة حتى نداء الصعود للرحلة.',
      'badge': '📢 أصوات نداء متقطعة',
      'tips': [
        'تأكد من رقم البوابة المكتوب على تذكرتك.',
        'توجه لدورة المياه أو شراء الماء قبل بدء النداء.',
      ],
      'isDone': false,
    },
  ];

  double get _progress =>
      _steps.where((s) => s['isDone'] == true).length / _steps.length;

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
          'رحلتي خطوة بخطوة',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ModernBackground(
        isDarkMode: isDark,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              // شريط إرشادي وشريط تقدم ذكي
              Container(
                padding: const EdgeInsets.all(16),
                color: isDark ? const Color(0xFF1F2A2A) : Colors.amber.shade50,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'اضغط على أي خطوة لإظهار النصائح العملية، وحددها عند الإكمال.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 10,
                        backgroundColor: isDark ? Colors.grey.shade800 : Colors.amber.shade200,
                        color: const Color(0xFFFFB300),
                      ),
                    ),
                  ],
                ),
              ),

              // قائمة الخطوات العملية
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _steps.length,
                  itemBuilder: (context, index) {
                    final step = _steps[index];
                    final bool isDone = step['isDone'];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: isDone ? (isDark ? const Color(0xFF11221C) : Colors.green.shade50) : cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDone
                              ? Colors.green.shade400
                              : (isDark ? Colors.white12 : Colors.grey.shade200),
                          width: isDone ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ExpansionTile(
                          shape: const Border(),
                          collapsedShape: const Border(),
                          leading: Checkbox(
                            value: isDone,
                            activeColor: Colors.green,
                            onChanged: (bool? val) {
                              HapticFeedback.selectionClick();
                              setState(() {
                                step['isDone'] = val ?? false;
                              });
                            },
                          ),
                          title: Text(
                            step['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: textColor,
                              decoration: isDone ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                step['desc'],
                                style: TextStyle(fontSize: 13, color: subTextColor),
                              ),
                              const SizedBox(height: 8),
                              Chip(
                                label: Text(
                                  step['badge'],
                                  style: const TextStyle(fontSize: 11),
                                ),
                                backgroundColor: isDark ? const Color(0xFF223333) : Colors.teal.shade50,
                                labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.teal.shade800),
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                          trailing: CircleAvatar(
                            backgroundColor: isDone ? Colors.green : const Color(0xFFFFB300),
                            radius: 16,
                            child: Text(
                              step['number'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              color: isDark ? const Color(0xFF0F171A) : Colors.grey.shade50,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '📋 نصائح سريعة لهذه الخطوة:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFFFFB300),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ...List.generate(
                                    (step['tips'] as List).length,
                                    (i) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4.0),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.check_circle_outline,
                                              size: 16, color: Color(0xFFFFB300)),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              step['tips'][i],
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: subTextColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}