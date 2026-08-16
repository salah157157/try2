import 'package:hive/hive.dart';
import '../models/airport_package.dart';

class HiveService {
  static const String boxName = 'offline_airports';
  static const String entryCardBoxName = 'entry_cards';

  // --- الميثودز المساعدة لضمان فتح الـ Boxes بنجاح ---

  Future<Box<AirportPackage>> _getAirportBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<AirportPackage>(boxName);
    }
    return Hive.box<AirportPackage>(boxName);
  }

  Future<Box> _getEntryCardBox() async {
    if (!Hive.isBoxOpen(entryCardBoxName)) {
      return await Hive.openBox(entryCardBoxName);
    }
    return Hive.box(entryCardBoxName);
  }

  // --- إدارة حزم المطارات ---

  Future<void> saveAirportPackage(AirportPackage package) async {
    final box = await _getAirportBox();
    await box.put(package.airportCode, package);
  }

  AirportPackage? getAirportPackage(String airportCode) {
    if (!Hive.isBoxOpen(boxName)) return null;
    final box = Hive.box<AirportPackage>(boxName);
    return box.get(airportCode);
  }

  bool isPackageDownloaded(String airportCode) {
    if (!Hive.isBoxOpen(boxName)) return false;
    final box = Hive.box<AirportPackage>(boxName);
    return box.containsKey(airportCode);
  }

  List<AirportPackage> getAllDownloadedAirports() {
    if (!Hive.isBoxOpen(boxName)) return [];
    final box = Hive.box<AirportPackage>(boxName);
    return box.values.toList();
  }

  Future<void> deleteAirportPackage(String airportCode) async {
    final box = await _getAirportBox();
    await box.delete(airportCode);
  }

  // --- إدارة مسودة كرت الدخول (Entry Card Draft) ---

  /// حفظ بيانات كرت الدخول لمطار معين
  Future<void> saveEntryCardDraft({
    required String airportCode,
    required String fullName,
    required String passportNumber,
    required String expectedAddress,
    required String visitPurpose,
    String? flightNo,
    String? arrivingFrom,
    String? nationality,
    List<Map<String, dynamic>>? companions,
  }) async {
    final box = await _getEntryCardBox();
    await box.put(airportCode, {
      'fullName': fullName.trim(),
      'passportNumber': passportNumber.trim(),
      'expectedAddress': expectedAddress.trim(),
      'visitPurpose': visitPurpose.trim(),
      'flightNo': flightNo?.trim() ?? '',
      'arrivingFrom': arrivingFrom?.trim() ?? '',
      'nationality': nationality?.trim() ?? '',
      'companions': companions ?? [], // حفظ قائمة المرافقين المستقبلة أو قائمة فارغة بدلاً من القيم الوهمية
    });
  }

  /// جلب مسودة كرت الدخول المحفوظة لمطار معين
  Map<String, dynamic>? getEntryCardDraft(String airportCode) {
    if (!Hive.isBoxOpen(entryCardBoxName)) return null;
    final box = Hive.box(entryCardBoxName);
    final dynamic data = box.get(airportCode);

    if (data != null) {
      try {
        if (data is Map) {
          // تحويل المفاتيح إلى String والتأكد من بقاء الأنواع الأخرى كما هي (مثل القوائم للمرافقين)
          return data.map((key, value) => MapEntry(
                key.toString(),
                value,
              ));
        }
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// حذف مسودة كرت الدخول لمطار معين
  Future<void> deleteEntryCardDraft(String airportCode) async {
    final box = await _getEntryCardBox();
    await box.delete(airportCode);
  }

  /// مسح جميع المسودات المخزنة كروت الدخول
  Future<void> clearAllEntryCardDrafts() async {
    final box = await _getEntryCardBox();
    await box.clear();
  }
}