import 'package:flutter/material.dart';
import '../models/customs_rule.dart';
import '../widgets/modern_background.dart';

class CustomsRestrictionsScreen extends StatelessWidget {
  final String airportCode;
  final String airportName;
  final String cityName;
  final bool isDarkMode;

  const CustomsRestrictionsScreen({
    super.key,
    required this.airportCode,
    required this.airportName,
    required this.cityName,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    // جلب البيانات الخاصة بالمطار، وإذا لم توجد يتم جلب البيانات الافتراضية وتحديث اسم البلد بناءً على اختيار المستخدم
    CustomsRule rule = CustomsRule.getDataForAirport(airportCode);
    
    // التحقق إذا كانت البيانات المعادة افتراضية (أو تخص مصر) ولم تطابق المطار المطلوب تماماً، نقوم بتحديث اسم الدولة ليطابق المدخل لضمان عدم الثبات على مصر وحدها
    if (rule.countryName == "مصر" && !airportName.contains("مصر") && !cityName.contains("القاهرة") && airportCode != "CAI") {
      rule = CustomsRule(
        countryName: "$cityName ($airportName)",
        currencyLimit: rule.currencyLimit,
        allowedItems: rule.allowedItems,
        restrictedItems: rule.restrictedItems,
        prohibitedItems: rule.prohibitedItems,
        importantTip: rule.importantTip,
      );
    }

    final Color bgColor = isDarkMode ? const Color(0xFF0B1212) : const Color(0xFFF5F7F8);
    final Color appBarColor = isDarkMode ? const Color(0xFF0F171A) : const Color(0xFF8C844C);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "جمرك ومحظورات ${rule.countryName}",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ModernBackground(
        isDarkMode: isDarkMode,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // رأس التنبيه الجمركي
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode 
                          ? const Color(0xFF2C2200) 
                          : const Color.fromARGB(255, 255, 243, 224),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkMode ? Colors.amber.shade700 : Colors.amber.shade500, 
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.gavel, 
                          color: isDarkMode ? Colors.amber.shade400 : Colors.amber.shade800, 
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "تنبيه هام للمسافرين",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: isDarkMode ? Colors.amber.shade200 : Colors.brown.shade900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "القواعد أدناه خاصة بدخول ${rule.countryName} عبر ($airportName)",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDarkMode ? Colors.amber.shade100.withOpacity(0.9) : Colors.brown.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // بطاقة الحد الأقصى للمبالغ النقدية
                  _buildSectionCard(
                    title: "الحد الأقصى للنقد (بدون إفصاح)",
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: Colors.tealAccent,
                    isDarkMode: isDarkMode,
                    content: Text(
                      rule.currencyLimit,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: isDarkMode ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // بطاقة المسموح به
                  _buildListSectionCard(
                    title: "الممتلكات المسموح بها",
                    icon: Icons.check_circle_outline,
                    iconColor: Colors.greenAccent,
                    items: rule.allowedItems,
                    isDarkMode: isDarkMode,
                  ),

                  // بطاقة المقيدة (تحتاج شروط)
                  _buildListSectionCard(
                    title: "الممتلكات المقيدة (بشروط / تصاريح)",
                    icon: Icons.info_outline,
                    iconColor: Colors.blueAccent,
                    items: rule.restrictedItems,
                    isDarkMode: isDarkMode,
                  ),

                  // بطاقة المحظورة نهائياً
                  _buildListSectionCard(
                    title: "المحظورات والممنوعات تماماً",
                    icon: Icons.block,
                    iconColor: Colors.redAccent,
                    items: rule.prohibitedItems,
                    isDarkMode: isDarkMode,
                  ),

                  // نصيحة ذهبية
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 20),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF2C1E1E) : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            rule.importantTip,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.red.shade200 : Colors.red.shade900,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget content,
    required bool isDarkMode,
  }) {
    final Color cardColor = isDarkMode ? const Color(0xFF15201F) : Colors.white;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDarkMode ? Colors.white12 : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildListSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<String> items,
    required bool isDarkMode,
  }) {
    return _buildSectionCard(
      title: title,
      icon: icon,
      iconColor: iconColor,
      isDarkMode: isDarkMode,
      content: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Icon(Icons.fiber_manual_record, size: 8, color: iconColor),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}