import 'dart:async';
import 'package:flutter/material.dart';
import '../services/haptic_service.dart';
import '../widgets/modern_background.dart'; // تأكد من استيراد المجلد الصحيح

class GateTimerAndAssistanceScreen extends StatefulWidget {
  final bool isDarkMode; // إضافة هذا المتغير لدعم الثيم
  const GateTimerAndAssistanceScreen({super.key, this.isDarkMode = true});

  @override
  State<GateTimerAndAssistanceScreen> createState() => _GateTimerAndAssistanceScreenState();
}

class _GateTimerAndAssistanceScreenState extends State<GateTimerAndAssistanceScreen> {
  // --- متغيرة المؤقت ---
  int _selectedMinutes = 15;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isTimerRunning = false;

  // --- متغيرة نموذج الكرسي المتحرك ---
  final _nameController = TextEditingController();
  final _flightController = TextEditingController();
  String _selectedAssistance = "كرسي متحرك (Wheelchair)";

  void _startTimer() {
    HapticService.lightImpact();
    setState(() {
      _remainingSeconds = _selectedMinutes * 60;
      _isTimerRunning = true;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isTimerRunning = false;
        });
        HapticService.triggerAlarmPattern(); // هذا السطر بقي كما هو
        _showAlarmDialog();
      }
    });
  }

  void _cancelTimer() {
    HapticService.lightImpact();
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _remainingSeconds = 0;
    });
  }

  void _showAlarmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.yellow, width: 3),
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.vibration, color: Colors.yellow, size: 30),
            SizedBox(width: 10),
            Text("حان موعد البوابة!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          "انتهى الوقت المحدد للانتظار. يرجى التوجه إلى بوابة الصعود الآن.",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
            onPressed: () {
              HapticService.lightImpact();
              Navigator.pop(context);
            },
            child: const Text("حسناً، فهمت", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showGeneratedCard() {
    if (_nameController.text.isEmpty || _flightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى إدخال الاسم ورقم الرحلة أولاً")),
      );
      return;
    }

    HapticService.lightImpact();
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
              const Icon(Icons.accessible, color: Colors.yellow, size: 80),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.yellow, width: 3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      "طلب مساعدة خاصة / SPECIAL ASSISTANCE",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(color: Colors.yellow, height: 30),
                    Text(
                      "الاسم / Name: ${_nameController.text}",
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "الرحلة / Flight: ${_flightController.text}",
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "نوع الخدمة / Service: $_selectedAssistance",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Text(
                "اعرض هذه الشاشة لموظف الاستعلامات أو الكاونتر مباشرة",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _nameController.dispose();
    _flightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDarkMode;
    final String minutesStr = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final String secondsStr = (_remainingSeconds % 60).toString().padLeft(2, '0');
    
    // الألوان المتوافقة مع الثيم
    final Color appBarColor = isDark ? const Color(0xFF0F171A) : const Color(0xFF8C844C);
    final Color bgColor = isDark ? const Color(0xFF0B1212) : const Color(0xFFF5F7F8);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("المؤقت والخدمات المباشرة", style: TextStyle(color: Colors.white)),
        backgroundColor: appBarColor,
      ),
      body: ModernBackground(
        isDarkMode: isDark,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // ⏳ القسم الأول: مؤقت اهتزاز البوابة
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.vibration, color: Colors.teal, size: 28),
                          SizedBox(width: 10),
                          Text(
                            "مؤقت اهتزاز صعود البوابة (للصم)",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "اختر الوقت المتبقي لصعود الطائرة وسيقوم الهاتف بالاهتزاز المتكرر والقوي عند انتهائه.",
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 16),
                      if (_isTimerRunning) ...[
                        Center(
                          child: Column(
                            children: [
                              Text(
                                "$minutesStr:$secondsStr",
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                onPressed: _cancelTimer,
                                icon: const Icon(Icons.stop),
                                label: const Text("إلغاء المؤقت"),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                              ),
                            ],
                          ),
                        )
                      ] else ...[
                        Row(
                          children: [
                            const Text("التنبيه بعد: ", style: TextStyle(fontWeight: FontWeight.bold)),
                            DropdownButton<int>(
                              value: _selectedMinutes,
                              items: [5, 10, 15, 20, 30, 45, 60].map((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text("$value دقيقة"),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedMinutes = val);
                              },
                            ),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: _startTimer,
                              icon: const Icon(Icons.play_arrow),
                              label: const Text("تفعيل المؤقت"),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                            )
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🦮 القسم الثاني: طلب المرافق والكرسي
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.accessible, color: Colors.deepPurple, size: 28),
                          SizedBox(width: 10),
                          Text(
                            "طلب مرافق / كرسي متحرك",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "اسم المسافر بالكامل",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _flightController,
                        decoration: const InputDecoration(
                          labelText: "رقم الرحلة (مثال: MS 788)",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.flight),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedAssistance,
                        decoration: const InputDecoration(
                          labelText: "نوع المساعدة المطلوبة",
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          "كرسي متحرك (Wheelchair)",
                          "مرافق كبار سن (Elderly Escort)",
                          "مرافق مكفوفين (Visual Escort)",
                          "مرافق توحد/ذهني (Neurodiverse Escort)",
                        ].map((String val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val, style: const TextStyle(fontSize: 13)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedAssistance = val);
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _showGeneratedCard,
                          icon: const Icon(Icons.qr_code_2),
                          label: const Text("توليد بطاقة الطلب المباشرة"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}