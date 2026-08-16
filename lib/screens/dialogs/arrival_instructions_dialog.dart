import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../../services/hive_service.dart';

class ArrivalInstructionsDialogHelper {
  /// نافذة مراجعة البيانات المحفوظة والإرشادات
  static void show(
    BuildContext context, {
    required String airportCode,
    required HiveService hiveService,
    required bool isDarkMode,
    VoidCallback? onEditPressed, // دالة التعديل الحقيقية
  }) {
    Map<String, dynamic> savedData = {};
    if (Hive.isBoxOpen(HiveService.entryCardBoxName)) {
      savedData = hiveService.getEntryCardDraft(airportCode) ?? {};
    }

    // استخراج قائمة المرافقين وتحديد القصر والجنس بدقة لجميع الحالات
    List<dynamic> companions = savedData['companions'] ?? [];
    List<Map<String, dynamic>> minorMinors = [];

    for (var comp in companions) {
      if (comp is Map) {
        int? age = int.tryParse(comp['age']?.toString() ?? '');
        if (age != null && age < 18) {
          var genderValue = comp['gender']?.toString().toLowerCase() ?? 'male';
          minorMinors.add({
            'name': comp['name'],
            'age': comp['age'],
            'gender': genderValue,
          });
        }
      }
    }

    // تحديد الألوان حسب الوضع الليلي أو النهاري
    final Color bgColor = isDarkMode ? const Color(0xFF15201F) : Colors.white;
    final Color subTextColor = isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700;
    final Color titleColor = isDarkMode ? Colors.tealAccent : Colors.teal;
    final Color containerBg = isDarkMode ? const Color(0xFF1B2A29) : Colors.teal.shade50.withOpacity(0.5);
    final Color containerBorder = isDarkMode ? Colors.teal.shade800 : Colors.teal.shade200;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 750),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
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
                        color: isDarkMode ? Colors.white24 : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.integration_instructions_outlined, color: titleColor),
                          const SizedBox(width: 8),
                          Text(
                            "إرشادات وتفاصيل الكرت",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: titleColor),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: isDarkMode ? Colors.white70 : Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Divider(height: 20, color: isDarkMode ? Colors.white12 : null),

                  // عرض البيانات المحفوظة للعميل لمراجعتها
                  if (savedData.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: containerBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: containerBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("بياناتك المحفوظة للكرت:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: titleColor)),
                              TextButton.icon(
                                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                                icon: Icon(Icons.edit, size: 14, color: titleColor),
                                label: Text("تعديل", style: TextStyle(fontSize: 12, color: titleColor)),
                                onPressed: () {
                                  Navigator.pop(context); // إغلاق نافذة الإرشادات
                                  if (onEditPressed != null) {
                                    onEditPressed(); // استدعاء دالة التعديل المُمررة بشكل صحيح
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          _buildDataRow("• الاسم:", savedData['fullName'], subTextColor),
                          _buildDataRow("• رقم الجواز:", savedData['passportNumber'], subTextColor),
                          _buildDataRow("• العنوان:", savedData['expectedAddress'], subTextColor),
                          _buildDataRow("• الغرض:", savedData['visitPurpose'], subTextColor),
                          _buildDataRow("• الجنسية:", savedData['nationality'], subTextColor),
                          _buildDataRow("• رقم الرحلة:", savedData['flightNo'], subTextColor),
                          _buildDataRow("• قادم من:", savedData['arrivingFrom'], subTextColor),
                          
                          if (companions.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text("• المرافقون (${companions.length}):", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: titleColor)),
                            ...companions.map((comp) {
                              String genderText = (comp['gender']?.toString().toLowerCase() == 'female') ? 'أنثى' : 'ذكر';
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0, top: 2),
                                child: Text("- ${comp['name'] ?? 'بدون اسم'} ($genderText - العمر: ${comp['age'] ?? '-'} سنة)", style: TextStyle(fontSize: 11, color: subTextColor)),
                              );
                            }),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // --- تنبيه وإجراءات خاصة بالقصر والفتيات في جميع الحالات ---
                  if (minorMinors.isNotEmpty) ...[
                    ...minorMinors.map((minor) {
                      bool isFemale = minor['gender'] == 'female';
                      String name = minor['name'] ?? 'مرافق';
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.orange.shade900.withOpacity(0.25) : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.shade400),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    isFemale 
                                      ? "تنبيه بخصوص الفتاة القاصر ($name):" 
                                      : "تنبيه بخصوص الولد القاصر ($name):",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDarkMode ? Colors.orangeAccent : Colors.orange.shade800),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              isFemale
                                ? "يلزم للمرافق (فتاة قاصر) المستندات التالية:"
                                : "يلزم للمرافق (ولد قاصر) المستندات التالية:",
                              style: TextStyle(fontSize: 12, color: subTextColor),
                            ),
                            const SizedBox(height: 4),
                            const Text("1. شهادة الميلاد الرسمية للمرافق القاصر.", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                            Text(
                              isFemale
                                ? "2. تصريح سفر رسمي موثق أو موافقة ولي الأمر أو الزوج إن لم يكن الأب أو الزوج مسافراً معها."
                                : "2. تصريح سفر رسمي موثق أو موافقة ولي الأمر إن لم يكن الأب مسافراً برفقتهم.",
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 4),
                  ],

                  // 📸 زر لعرض تفاصيل الكرت والنسخ السريع
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showCardImageDialog(context, airportCode, hiveService, isDarkMode),
                      icon: const Icon(Icons.copy_all_rounded, color: Colors.amber, size: 20),
                      label: const Text(
                        "عرض تفاصيل الكرت والبيانات للنسخ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.amber.shade900.withOpacity(0.2) : Colors.amber.shade50.withOpacity(0.5),
                        side: BorderSide(color: Colors.amber.shade400),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // خطوات الإرشادات
                  _buildInstructionStep(
                    step: "1",
                    title: "تعبئة الكرت الورقي بالإنجليزية",
                    desc: "قم بنقل البيانات أعلاه إلى الكرت الورقي الموزع داخل صالة الوصول بحروف كبيرة (Capital Letters).",
                    isDarkMode: isDarkMode,
                  ),
                  _buildInstructionStep(
                    step: "2",
                    title: "مطابقة رقم الجواز",
                    desc: "تأكد من كتابة رقم الجواز تماماً بدون أخطاء مطبعية لكل مسافر ومرافق.",
                    isDarkMode: isDarkMode,
                  ),
                  _buildInstructionStep(
                    step: "3",
                    title: "التوجه لشباك الجوازات",
                    desc: "قدم الكروت المكتملة للجوازات برفقة طابع التأشيرة، جوازات السفر، وأوراق المرافقين القصر.",
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("تم، فهمت ذلك", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildDataRow(String label, String? value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text("$label ${value?.isNotEmpty == true ? value : '-'}", style: TextStyle(fontSize: 12, color: color)),
    );
  }

  static void _showCardImageDialog(BuildContext context, String airportCode, HiveService hiveService, bool isDarkMode) {
    Map<String, dynamic> userDraft = {};
    if (Hive.isBoxOpen(HiveService.entryCardBoxName)) {
      userDraft = hiveService.getEntryCardDraft(airportCode) ?? {};
    }

    final String fullName = userDraft['fullName']?.isNotEmpty == true ? userDraft['fullName']! : 'لم يتم الإدخال بعد';
    final String passportNumber = userDraft['passportNumber']?.isNotEmpty == true ? userDraft['passportNumber']! : 'لم يتم الإدخال بعد';
    final String addressInEgypt = userDraft['expectedAddress']?.isNotEmpty == true ? userDraft['expectedAddress']! : 'لم يتم الإدخال بعد';
    final String purposeOfVisit = userDraft['visitPurpose']?.isNotEmpty == true ? userDraft['visitPurpose']! : 'لم يتم الإدخال بعد';
    final String flightNo = userDraft['flightNo']?.isNotEmpty == true ? userDraft['flightNo']! : 'لم يتم الإدخال بعد';
    final String arrivingFrom = userDraft['arrivingFrom']?.isNotEmpty == true ? userDraft['arrivingFrom']! : 'لم يتم الإدخال بعد';
    final String nationality = userDraft['nationality']?.isNotEmpty == true ? userDraft['nationality']! : 'لم يتم الإدخال بعد';
    List<dynamic> companions = userDraft['companions'] ?? [];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDarkMode ? const Color(0xFF15201F) : Colors.white,
        child: Container(
          width: 550,
          height: 550,
          padding: const EdgeInsets.all(16),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.style, color: Colors.teal),
                        const SizedBox(width: 8),
                        Text(
                          "بيانات كرت المطار المحفوظة",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDarkMode ? Colors.tealAccent : Colors.teal,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: isDarkMode ? Colors.white70 : Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    children: [
                      _buildCopyTile("الاسم بالكامل (FullName)", fullName, isDarkMode),
                      _buildCopyTile("رقم الجواز (Passport No)", passportNumber, isDarkMode),
                      _buildCopyTile("العنوان المتوقع (Address)", addressInEgypt, isDarkMode),
                      _buildCopyTile("غرض الزيارة (Purpose)", purposeOfVisit, isDarkMode),
                      _buildCopyTile("رقم الرحلة (Flight No)", flightNo, isDarkMode),
                      _buildCopyTile("قادم من (Arriving From)", arrivingFrom, isDarkMode),
                      _buildCopyTile("الجنسية (Nationality)", nationality, isDarkMode),
                      if (companions.isNotEmpty)
                        ...companions.asMap().entries.map((entry) {
                          var comp = entry.value;
                          String gText = (comp['gender']?.toString().toLowerCase() == 'female') ? 'أنثى' : 'ذكر';
                          return _buildCopyTile("مرافق ${entry.key + 1}", "${comp['name']} ($gText - العمر: ${comp['age']})", isDarkMode);
                        }),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("إغلاق النافذة", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildCopyTile(String title, String value, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1B2A29) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDarkMode ? Colors.white10 : Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDarkMode ? Colors.white : Colors.black87),
                ),
              ],
            ),
          ),
          Builder(
            builder: (ctx) => IconButton(
              tooltip: "نسخ النص",
              icon: Icon(Icons.copy_rounded, color: isDarkMode ? Colors.tealAccent : Colors.teal, size: 20),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: value));
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text("تم نسخ $title بنجاح!"),
                        ],
                      ),
                      backgroundColor: Colors.teal.shade700,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildInstructionStep({required String step, required String title, required String desc, required bool isDarkMode}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.amber.shade700,
            child: Text(step, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDarkMode ? Colors.white : Colors.black87)),
                const SizedBox(height: 2),
                Text(desc, style: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}