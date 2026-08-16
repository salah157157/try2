import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 🟢 1. نموذج بيانات كرت الوصول (Data Model)
class ArrivalCardModel {
  final String fullName;
  final String passportNo;
  final String address;
  final String purpose;
  final String flightNo;
  final String arrivingFrom;

  const ArrivalCardModel({
    required this.fullName,
    required this.passportNo,
    required this.address,
    required this.purpose,
    required this.flightNo,
    required this.arrivingFrom,
  });

  // تحويل البيانات لخريطة مبسطة للعرض
  Map<String, String> toMap() {
    return {
      'الاسم الكامل (Full Name)': fullName,
      'رقم الجواز (Passport No)': passportNo,
      'عنوان الإقامة (Address)': address,
      'غرض الزيارة (Purpose)': purpose,
      'رقم الرحلة (Flight No)': flightNo,
      'قادم من (Arriving From)': arrivingFrom,
    };
  }
}

// 🟢 2. مستودع البيانات وحالة التطبيق (State Repository)
class ArrivalCardRepository {
  static final ValueNotifier<ArrivalCardModel> cardDataNotifier = ValueNotifier(
    const ArrivalCardModel(
      fullName: 'JOHN ALBERT SMITH',
      passportNo: 'A12345678',
      address: 'Marriott Hotel, Zamalek, Cairo',
      purpose: 'Tourism / Leisure',
      flightNo: 'MS 788',
      arrivingFrom: 'London, UK',
    ),
  );
}

// 🟢 3. واجهة عرض بيانات النسخ (استجابة فورية للتحديثات)
class ArrivalCardDetailsWidget extends StatelessWidget {
  const ArrivalCardDetailsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ArrivalCardModel>(
      valueListenable: ArrivalCardRepository.cardDataNotifier,
      builder: (context, cardModel, _) {
        final dataMap = cardModel.toMap();

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(12),
          itemCount: dataMap.length,
          itemBuilder: (context, index) {
            final key = dataMap.keys.elementAt(index);
            final value = dataMap.values.elementAt(index);

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: ListTile(
                dense: true,
                title: Text(
                  key,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                subtitle: Text(
                  value.isEmpty ? 'غير محدد' : value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 18, color: Colors.teal),
                  onPressed: value.isEmpty
                      ? null
                      : () {
                          Clipboard.setData(ClipboardData(text: value));
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم نسخ: $value'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// 🟢 4. واجهة تعبئة البيانات (مع Validation والـ Uppercase)
class ArrivalCardFormWidget extends StatefulWidget {
  final VoidCallback? onSaved;

  const ArrivalCardFormWidget({Key? key, this.onSaved}) : super(key: key);

  @override
  State<ArrivalCardFormWidget> createState() => _ArrivalCardFormWidgetState();
}

class _ArrivalCardFormWidgetState extends State<ArrivalCardFormWidget> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _passportController;
  late TextEditingController _addressController;
  late TextEditingController _purposeController;
  late TextEditingController _flightNoController;
  late TextEditingController _arrivingFromController;

  @override
  void initState() {
    super.initState();
    final currentData = ArrivalCardRepository.cardDataNotifier.value;
    _fullNameController = TextEditingController(text: currentData.fullName);
    _passportController = TextEditingController(text: currentData.passportNo);
    _addressController = TextEditingController(text: currentData.address);
    _purposeController = TextEditingController(text: currentData.purpose);
    _flightNoController = TextEditingController(text: currentData.flightNo);
    _arrivingFromController = TextEditingController(text: currentData.arrivingFrom);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _passportController.dispose();
    _addressController.dispose();
    _purposeController.dispose();
    _flightNoController.dispose();
    _arrivingFromController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // تحديث الحالة الإجمالية
      ArrivalCardRepository.cardDataNotifier.value = ArrivalCardModel(
        fullName: _fullNameController.text.trim().toUpperCase(),
        passportNo: _passportController.text.trim().toUpperCase(),
        address: _addressController.text.trim(),
        purpose: _purposeController.text.trim(),
        flightNo: _flightNoController.text.trim().toUpperCase(),
        arrivingFrom: _arrivingFromController.text.trim().toUpperCase(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ البيانات بنجاح!'),
          backgroundColor: Colors.teal,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (widget.onSaved != null) {
        widget.onSaved!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField(
              number: '1',
              label: 'الاسم الكامل (بالإنجليزية)',
              hint: 'JOHN ALBERT SMITH',
              icon: Icons.person_outline,
              controller: _fullNameController,
              isCapitalize: true,
            ),
            const SizedBox(height: 14),

            _buildInputField(
              number: '2',
              label: 'رقم الجواز',
              hint: 'A12345678',
              icon: Icons.badge_outlined,
              controller: _passportController,
              isCapitalize: true,
            ),
            const SizedBox(height: 14),

            _buildInputField(
              number: '3',
              label: 'عنوان الإقامة المتوقع',
              hint: 'اسم الفندق أو المنطقة',
              icon: Icons.hotel_outlined,
              controller: _addressController,
            ),
            const SizedBox(height: 14),

            _buildInputField(
              number: '4',
              label: 'الغرض من الزيارة',
              hint: 'Tourism / Leisure',
              icon: Icons.work_outline,
              controller: _purposeController,
            ),
            const SizedBox(height: 14),

            _buildInputField(
              number: '5',
              label: 'رقم الرحلة (Flight No)',
              hint: 'MS 788',
              icon: Icons.flight_takeoff_outlined,
              controller: _flightNoController,
              isCapitalize: true,
            ),
            const SizedBox(height: 14),

            _buildInputField(
              number: '6',
              label: 'قادم من (Arriving From)',
              hint: 'LONDON, UK',
              icon: Icons.location_on_outlined,
              controller: _arrivingFromController,
              isCapitalize: true,
              isLastAction: true,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _saveForm,
                icon: const Icon(Icons.save_outlined, color: Colors.white),
                label: const Text(
                  'حفظ المسودة وعرض الإرشادات',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
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
    );
  }

  Widget _buildInputField({
    required String number,
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isCapitalize = false,
    bool isLastAction = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: Colors.teal,
              child: Text(
                number,
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          textCapitalization: isCapitalize ? TextCapitalization.characters : TextCapitalization.words,
          textInputAction: isLastAction ? TextInputAction.done : TextInputAction.next,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'هذا الحقل مطلوب';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            suffixIcon: Icon(icon, color: Colors.teal, size: 20),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.teal, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }
}