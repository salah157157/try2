import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../services/hive_service.dart';

class ArrivalCardDialogHelper {
  /// --- 📝 نافذة نموذج تعبئة كرت الدخول ---
  static void show(
    BuildContext context, {
    required String airportCode,
    required HiveService hiveService,
    required Function(bool) onCompleted,
    required Function(BuildContext) showInstructionsCallback,
    required bool isDarkMode, // تمرير متغير الوضع الليلي
  }) {
    Map<String, dynamic> savedData = {};
    if (Hive.isBoxOpen(HiveService.entryCardBoxName)) {
      savedData = hiveService.getEntryCardDraft(airportCode) ?? {};
    }

    final TextEditingController nameController =
        TextEditingController(text: savedData['fullName'] ?? '');
    final TextEditingController passportController =
        TextEditingController(text: savedData['passportNumber'] ?? '');
    final TextEditingController addressController =
        TextEditingController(text: savedData['expectedAddress'] ?? '');
    final TextEditingController purposeController =
        TextEditingController(text: savedData['visitPurpose'] ?? '');
    final TextEditingController nationalityController =
        TextEditingController(text: savedData['nationality'] ?? '');
    final TextEditingController flightNoController =
        TextEditingController(text: savedData['flightNo'] ?? '');
    final TextEditingController arrivingFromController =
        TextEditingController(text: savedData['arrivingFrom'] ?? '');

    // قائمة المرافقين المحفوظة أو الفارغة مع التأكد من وجود الجنس
    List<Map<String, dynamic>> companions = [];
    if (savedData['companions'] != null) {
      companions = List<Map<String, dynamic>>.from(
        (savedData['companions'] as List).map((e) {
          var map = Map<String, dynamic>.from(e);
          // التأكد من وجود قيمة افتراضية للجنس إذا لم تكن موجودة مسبقاً
          map['gender'] ??= 'male';
          return map;
        }),
      );
    }

    // تحديد الألوان حسب الوضع
    final Color bgColor = isDarkMode ? const Color(0xFF15201F) : Colors.white;
    final Color subTextColor = isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700;
    final Color titleColor = isDarkMode ? Colors.tealAccent : Colors.teal;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateModal) => Center(
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
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
                  top: 20,
                  left: 20,
                  right: 20,
                ),
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
                            Icon(Icons.assignment_outlined, color: titleColor),
                            const SizedBox(width: 8),
                            Text(
                              "تعبئة نموذج كرت الدخول",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: titleColor,
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
                    Divider(height: 24, color: isDarkMode ? Colors.white12 : null),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        "يرجى إدخال بياناتك كما هي في جواز السفر لتسهيل عملية التعبئة:",
                        style: TextStyle(color: subTextColor, fontSize: 13),
                      ),
                    ),
                    _buildInputField(
                      stepNumber: "1",
                      label: "الاسم الكامل (بالإنجليزية)",
                      hint: "اكتب الاسم تماماً كما في الجواز",
                      icon: Icons.person_outline,
                      controller: nameController,
                      isDarkMode: isDarkMode,
                    ),
                    _buildInputField(
                      stepNumber: "2",
                      label: "رقم الجواز",
                      hint: "الأحرف والأرقام بوضوح",
                      icon: Icons.badge_outlined,
                      controller: passportController,
                      keyboardType: TextInputType.visiblePassword,
                      isDarkMode: isDarkMode,
                    ),
                    _buildInputField(
                      stepNumber: "3",
                      label: "عنوان الإقامة المتوقع",
                      hint: "اسم الفندق أو المنطقة",
                      icon: Icons.hotel_outlined,
                      controller: addressController,
                      isDarkMode: isDarkMode,
                    ),
                    _buildInputField(
                      stepNumber: "4",
                      label: "الغرض من الزيارة",
                      hint: "(مثال: سياحة / Tourism)",
                      icon: Icons.card_travel,
                      controller: purposeController,
                      isDarkMode: isDarkMode,
                    ),
                    _buildInputField(
                      stepNumber: "5",
                      label: "الجنسية",
                      hint: "مثلا ليبي او سوداني",
                      icon: Icons.person_outline,
                      controller: nationalityController,
                      isDarkMode: isDarkMode,
                    ),
                    _buildInputField(
                      stepNumber: "6",
                      label: "رقم الرحلة",
                      hint: "مثلا ms 788",
                      icon: Icons.flight_outlined,
                      controller: flightNoController,
                      isDarkMode: isDarkMode,
                    ),
                    _buildInputField(
                      stepNumber: "7",
                      label: "قادم من ؟",
                      hint: "مثلا مصر",
                      icon: Icons.flight_takeoff_outlined,
                      controller: arrivingFromController,
                      isDarkMode: isDarkMode,
                    ),
                    
                    const SizedBox(height: 8),
                    Divider(color: isDarkMode ? Colors.white12 : Colors.grey.shade300),
                    const SizedBox(height: 8),

                    // --- قسم المرافقين وأعمارهم والجنس ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.group_add_outlined, color: titleColor, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              "المرافقون (إن وجدوا)",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: titleColor,
                              ),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () {
                            setStateModal(() {
                              // إضافة مرافق جديد مع قيمة افتراضية للجنس 'male'
                              companions.add({'name': '', 'age': '', 'gender': 'male'});
                            });
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text("إضافة مرافق"),
                          style: TextButton.styleFrom(
                            foregroundColor: isDarkMode ? Colors.tealAccent : Colors.teal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    if (companions.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "لا يوجد مرافقون مضافون حالياً.",
                          style: TextStyle(color: subTextColor, fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ...companions.asMap().entries.map((entry) {
                      int index = entry.key;
                      var companion = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDarkMode ? const Color(0xFF1B2A29) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDarkMode ? Colors.white10 : Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // اسم المرافق
                                Expanded(
                                  flex: 3,
                                  child: TextField(
                                    controller: TextEditingController(text: companion['name'])
                                      ..selection = TextSelection.fromPosition(TextPosition(offset: (companion['name'] ?? '').length)),
                                    onChanged: (val) => companion['name'] = val,
                                    style: TextStyle(fontSize: 13, color: isDarkMode ? Colors.white : Colors.black87),
                                    decoration: InputDecoration(
                                      hintText: "اسم المرافق ${index + 1}",
                                      hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                      isDense: true,
                                      filled: true,
                                      fillColor: isDarkMode ? const Color(0xFF0B1212) : Colors.white,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // العمر
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    controller: TextEditingController(text: companion['age'])
                                      ..selection = TextSelection.fromPosition(TextPosition(offset: (companion['age'] ?? '').length)),
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) => companion['age'] = val,
                                    style: TextStyle(fontSize: 13, color: isDarkMode ? Colors.white : Colors.black87),
                                    decoration: InputDecoration(
                                      hintText: "العمر",
                                      hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                      isDense: true,
                                      filled: true,
                                      fillColor: isDarkMode ? const Color(0xFF0B1212) : Colors.white,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                  onPressed: () {
                                    setStateModal(() {
                                      companions.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // اختيار الجنس (ذكر / أنثى)
                            Row(
                              children: [
                                Text("الجنس:", style: TextStyle(fontSize: 12, color: subTextColor)),
                                const SizedBox(width: 12),
                                ChoiceChip(
                                  label: const Text("ذكر", style: TextStyle(fontSize: 11)),
                                  selected: companion['gender'] == 'male',
                                  onSelected: (selected) {
                                    setStateModal(() {
                                      companion['gender'] = 'male';
                                    });
                                  },
                                  selectedColor: Colors.teal.shade700,
                                  labelStyle: TextStyle(color: companion['gender'] == 'male' ? Colors.white : subTextColor),
                                  visualDensity: VisualDensity.compact,
                                ),
                                const SizedBox(width: 8),
                                ChoiceChip(
                                  label: const Text("أنثى", style: TextStyle(fontSize: 11)),
                                  selected: companion['gender'] == 'female',
                                  onSelected: (selected) {
                                    setStateModal(() {
                                      companion['gender'] = 'female';
                                    });
                                  },
                                  selectedColor: Colors.teal.shade700,
                                  labelStyle: TextStyle(color: companion['gender'] == 'female' ? Colors.white : subTextColor),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop();

                          onCompleted(true);

                          try {
                            // حفظ البيانات مع قائمة المرافقين والجنس لتحليل الأعمار والشروط لاحقاً
                            await hiveService.saveEntryCardDraft(
                              airportCode: airportCode,
                              fullName: nameController.text,
                              passportNumber: passportController.text,
                              expectedAddress: addressController.text,
                              visitPurpose: purposeController.text,
                              nationality: nationalityController.text,
                              flightNo: flightNoController.text,
                              arrivingFrom: arrivingFromController.text,
                              companions: companions, // تخزين المرافقين مع الجنس
                            );
                          } catch (e) {
                            debugPrint("Error saving draft: $e");
                          }

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showInstructionsCallback(context);
                          });
                        },
                        icon: const Icon(Icons.save_outlined),
                        label: const Text("حفظ المسودة وعرض الإرشادات"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildInputField({
    required String stepNumber,
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    required bool isDarkMode,
  }) {
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color labelColor = isDarkMode ? Colors.white70 : Colors.black87;
    final Color fillColor = isDarkMode ? const Color(0xFF0B1212) : Colors.grey.shade50;
    final Color borderColor = isDarkMode ? Colors.white12 : Colors.grey.shade300;
    final Color enabledBorderColor = isDarkMode ? Colors.white24 : Colors.grey.shade200;
    final Color stepBgColor = isDarkMode ? Colors.teal.shade900.withOpacity(0.4) : Colors.teal.shade50;
    final Color stepBorderColor = isDarkMode ? Colors.teal.shade700 : Colors.teal.shade200;
    final Color stepTextColor = isDarkMode ? Colors.tealAccent : Colors.teal.shade700;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: stepBgColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: stepBorderColor),
                ),
                child: Center(
                  child: Text(
                    stepNumber,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: stepTextColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: labelColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(fontSize: 14, color: textColor),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 13, color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400),
              prefixIcon: Icon(icon, color: isDarkMode ? Colors.tealAccent : Colors.teal, size: 20),
              filled: true,
              fillColor: fillColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: enabledBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: isDarkMode ? Colors.tealAccent : Colors.teal, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}