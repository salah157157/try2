import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/airport_package.dart';
import '../services/hive_service.dart';
import '../widgets/modern_background.dart';
import 'accessibility_hub_screen.dart';
import 'currency_converter_screen.dart';
import 'country_map_screen.dart';
import 'dialogs/emergency_dialog.dart';
import 'dialogs/transport_dialog.dart';
import 'dialogs/telecom_dialog.dart';
import 'dialogs/arrival_card_dialog.dart';
import 'dialogs/arrival_instructions_dialog.dart';
import 'customs_restrictions_screen.dart';


class AirportHomeScreen extends StatefulWidget {
  final String airportCode;

  const AirportHomeScreen({super.key, this.airportCode = 'CAI'});

  @override
  State<AirportHomeScreen> createState() => _AirportHomeScreenState();
}

class _AirportHomeScreenState extends State<AirportHomeScreen> {
  final HiveService _hiveService = HiveService();
  AirportPackage? _airportData;

  late String _currentAirportCode;
  bool _isArrivalCardCompleted = false;
  bool _isDarkMode = true;

  final List<Map<String, String>> _availableAirports = [
    // 🇪🇬 مصر
    {'code': 'CAI', 'name': 'مطار القاهرة الدولي', 'city': 'القاهرة، مصر', 'countryKey': 'egypt'},
    {'code': 'HBE', 'name': 'مطار برج العرب الدولي', 'city': 'الإسكندرية، مصر', 'countryKey': 'egypt'},
    {'code': 'SSH', 'name': 'مطار شرم الشيخ الدولي', 'city': 'شرم الشيخ، مصر', 'countryKey': 'egypt'},
    {'code': 'HRG', 'name': 'مطار الغردقة الدولي', 'city': 'الغردقة، مصر', 'countryKey': 'egypt'},
    {'code': 'LXR', 'name': 'مطار الأقصر الدولي', 'city': 'الأقصر، مصر', 'countryKey': 'egypt'},
    {'code': 'ASW', 'name': 'مطار أسوان الدولي', 'city': 'أسوان، مصر', 'countryKey': 'egypt'},

    // 🇸🇦 السعودية
    {'code': 'RUH', 'name': 'مطار الملك خالد الدولي', 'city': 'الرياض، السعودية', 'countryKey': 'saudi'},
    {'code': 'JED', 'name': 'مطار الملك عبد العزيز الدولي', 'city': 'جدة، السعودية', 'countryKey': 'saudi'},
    {'code': 'DMM', 'name': 'مطار الملك فهد الدولي', 'city': 'الدمام، السعودية', 'countryKey': 'saudi'},
    {'code': 'MED', 'name': 'مطار الأمير محمد بن عبدالعزيز', 'city': 'المدينة المنورة، السعودية', 'countryKey': 'saudi'},
    {'code': 'TIF', 'name': 'مطار الطائف الدولي', 'city': 'الطائف، السعودية', 'countryKey': 'saudi'},

    // 🇦🇪 الإمارات
    {'code': 'DXB', 'name': 'مطار دبي الدولي', 'city': 'دبي، الإمارات', 'countryKey': 'uae'},
    {'code': 'AUH', 'name': 'مطار زايد الدولي', 'city': 'أبوظبي، الإمارات', 'countryKey': 'uae'},
    {'code': 'SHJ', 'name': 'مطار الشارقة الدولي', 'city': 'الشارقة، الإمارات', 'countryKey': 'uae'},
    {'code': 'RKT', 'name': 'مطار رأس الخيمة الدولي', 'city': 'رأس الخيمة، الإمارات', 'countryKey': 'uae'},

    // 🇩🇿 الجزائر
    {'code': 'ALG', 'name': 'مطار هواري بومدين الدولي', 'city': 'الجزائر، الجزائر', 'countryKey': 'algeria'},
    {'code': 'ORN', 'name': 'مطار أحمد بن بلة الدولي', 'city': 'وهران، الجزائر', 'countryKey': 'algeria'},

    // 🇹🇳 تونس
    {'code': 'TUN', 'name': 'مطار تونس قرطاج الدولي', 'city': 'تونس، تونس', 'countryKey': 'tunisia'},

    // 🇱🇾 ليبيا
    {'code': 'TIP', 'name': 'مطار معيتيقة الدولي', 'city': 'طرابلس، ليبيا', 'countryKey': 'libya'},

    // 🇮🇶 العراق
    {'code': 'BGW', 'name': 'مطار بغداد الدولي', 'city': 'بغداد، العراق', 'countryKey': 'iraq'},

    // 🇸🇩 السودان
    {'code': 'KRT', 'name': 'مطار الخرطوم الدولي', 'city': 'الخرطوم، السودان', 'countryKey': 'sudan'},
    {'code': 'PZU', 'name': 'مطار بورتسودان الدولي', 'city': 'بورتسودان، السودان', 'countryKey': 'sudan'},

    // 🇴🇲 عمان
    {'code': 'MCT', 'name': 'مطار مسقط الدولي', 'city': 'مسقط، عمان', 'countryKey': 'oman'},

    // 🇯🇴 الأردن
    {'code': 'AMM', 'name': 'مطار الملكة علياء الدولي', 'city': 'عمان، الأردن', 'countryKey': 'jordan'},
  ];

  String _getAssetImageForCountry(String countryKey, String cardType) {
    if (cardType == 'accessibility') return 'assets/images/accessibility.jpg';
    if (cardType == 'help') return 'assets/images/help.jpg';
    
    switch (countryKey) {
      case 'egypt':
        if (cardType == 'map') return 'assets/images/egypt_pyramids.png';
        if (cardType == 'currency') return 'assets/images/egypt_currency.png';
        if (cardType == 'customs') return 'assets/images/cairo_airport.jpg';
        break; 
      case 'saudi':
        if (cardType == 'map') return 'assets/images/saudi_landscape.png';
        if (cardType == 'currency') return 'assets/images/saudi_currency.png';
        if (cardType == 'customs') return 'assets/images/riyadh_airport.png';
        break;
      case 'uae':
        if (cardType == 'map') return 'assets/images/uae_skyline.png';
        if (cardType == 'currency') return 'assets/images/uae_currency.png';
        if (cardType == 'customs') return 'assets/images/dubai_airport.png';
        break;
      case 'sudan':
        if (cardType == 'map') return 'assets/images/sudan_neel.png';
        if (cardType == 'currency') return 'assets/images/sudan_currency.png';
        if (cardType == 'customs') return 'assets/images/sudan_airport.png';
        break;
      case 'iraq':
        if (cardType == 'map') return 'assets/images/iraq.png';
        if (cardType == 'currency') return 'assets/images/iraq_currency.png';
        if (cardType == 'customs') return 'assets/images/iraq_airport.png';
        break;
      case 'libya':
        if (cardType == 'map') return 'assets/images/libya.png';
        if (cardType == 'currency') return 'assets/images/libya_currency.png';
        if (cardType == 'customs') return 'assets/images/libya_airport.png';
        break;
      default:
        if (cardType == 'map') return 'assets/images/default_nature.png';
        if (cardType == 'currency') return 'assets/images/default_currency.png';
        if (cardType == 'customs') return 'assets/images/default_airport.png';
        break;
    }
    return 'assets/images/default_card_bg.png';
  }

  @override
  void initState() {
    super.initState();
    _currentAirportCode = widget.airportCode;
    _loadAirportData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ArrivalCardDialogHelper.show(
        context,
        airportCode: _currentAirportCode,
        hiveService: _hiveService,
        onCompleted: (completed) {
          setState(() {
            _isArrivalCardCompleted = completed;
          });
        },
        showInstructionsCallback: (ctx) {
          ArrivalInstructionsDialogHelper.show(
            ctx,
            airportCode: _currentAirportCode,
            hiveService: _hiveService,
            isDarkMode: _isDarkMode,
          );
        },
        isDarkMode: _isDarkMode,
      );
    });
  }

  void _loadAirportData() {
    setState(() {
      if (Hive.isBoxOpen(HiveService.boxName)) {
        _airportData = _hiveService.getAirportPackage(_currentAirportCode);
      }

      if (Hive.isBoxOpen(HiveService.entryCardBoxName)) {
        final savedData = _hiveService.getEntryCardDraft(_currentAirportCode);
        _isArrivalCardCompleted = savedData != null && savedData.isNotEmpty;
      }
    });
  }

  void _changeAirport(String newCode) {
    if (newCode != _currentAirportCode) {
      setState(() {
        _currentAirportCode = newCode;
        _loadAirportData();
      });
    }
  }

  void _showAirportSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String searchQuery = "";
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final filteredAirports = _availableAirports.where((airport) {
              final query = searchQuery.toLowerCase();
              return airport['name']!.toLowerCase().contains(query) ||
                  airport['code']!.toLowerCase().contains(query) ||
                  airport['city']!.toLowerCase().contains(query);
            }).toList();

            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                backgroundColor: _isDarkMode ? const Color(0xFF141D1C) : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: Row(
                  children: [
                    const Icon(Icons.flight_outlined, color: Color(0xFFFFB300)),
                    const SizedBox(width: 8),
                    Text(
                      "اختر المطار",
                      style: TextStyle(
                        color: _isDarkMode ? Colors.white : Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                content: SizedBox(
                  width: 400,
                  height: 450,
                  child: Column(
                    children: [
                      TextField(
                        style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black87),
                        decoration: InputDecoration(
                          hintText: "ابحث باسم المطار، المدينة، أو الكود...",
                          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                          prefixIcon: const Icon(Icons.search, color: Color(0xFFFFB300)),
                          filled: true,
                          fillColor: _isDarkMode ? const Color(0xFF1B2625) : Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        ),
                        onChanged: (value) {
                          setDialogState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredAirports.length,
                          itemBuilder: (context, index) {
                            final airport = filteredAirports[index];
                            final isSelected = airport['code'] == _currentAirportCode;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFFFB300).withOpacity(0.15)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                dense: true,
                                leading: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFB300).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    airport['code']!,
                                    style: const TextStyle(
                                      color: Color(0xFFFFB300),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  airport['name']!,
                                  style: TextStyle(
                                    color: _isDarkMode ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: Text(
                                  airport['city']!,
                                  style: TextStyle(
                                    color: _isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle, color: Color(0xFFFFB300), size: 18)
                                    : null,
                                onTap: () {
                                  _changeAirport(airport['code']!);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentAirportInfo = _availableAirports.firstWhere(
      (a) => a['code'] == _currentAirportCode,
      orElse: () => {
        'code': _currentAirportCode,
        'name': _airportData?.airportName ?? "مطار",
        'city': 'دولي',
        'countryKey': 'default'
      },
    );

    final String countryKey = currentAirportInfo['countryKey'] ?? 'default';

    return Theme(
      data: _isDarkMode
          ? ThemeData.dark().copyWith(
              scaffoldBackgroundColor: const Color(0xFF0B1212),
              cardColor: const Color(0xFF15201F),
            )
          : ThemeData.light(),
      child: Scaffold(
        backgroundColor: _isDarkMode ? const Color(0xFF0B1212) : null,
        appBar: AppBar(
          elevation: 0,
          title: Row(
            children: [
              Hero(
                tag: 'rahhal_logo_hero',
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/rahhal_logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _airportData?.airportName ?? currentAirportInfo['name']!,
                  style: const TextStyle(fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _showAirportSearchDialog,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _isDarkMode ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isDarkMode ? Colors.white24 : Colors.white38,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _currentAirportCode,
                        style: const TextStyle(
                          color: Color(0xFFFFB300),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.search_rounded, color: Colors.white70, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: _isDarkMode ? const Color(0xFF0F171A) : const Color(0xFF8c834a),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
              tooltip: "تغيير الوضع",
            ),
          ],
        ),
        body: ModernBackground(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  children: [
                    _buildAirportHeaderCard(
                      airportName: _airportData?.airportName ?? currentAirportInfo['name']!,
                      cityName: currentAirportInfo['city']!,
                      airportCode: _currentAirportCode,
                      countryKey: countryKey,
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.25,
                      children: [
                        _buildImageGridCard(
                          context,
                          imagePath: _getAssetImageForCountry(countryKey, 'map'),
                          icon: Icons.map_outlined,
                          title: "دليل الدولة الأوفلاين",
                          subtitle: currentAirportInfo['city']!,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CountryMapScreen(
                                  airportCode: _currentAirportCode,
                                  airportName: _airportData?.airportName ?? currentAirportInfo['name']!,
                                  cityName: currentAirportInfo['city']!,
                                  isDarkMode: _isDarkMode,
                                ),
                              ),
                            );
                          },
                        ),
                        _buildImageGridCard(
                          context,
                          imagePath: _getAssetImageForCountry(countryKey, 'currency'),
                          icon: Icons.calculate_outlined,
                          title: "حاسبة العملات",
                          subtitle: "تحويل العملات بدون إنترنت",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CurrencyConverterScreen(
                                  airportCode: _currentAirportCode,
                                  isDarkMode: _isDarkMode,
                                ),
                              ),
                            );
                          },
                        ),
                        _buildImageGridCard(
                          context,
                          imagePath: _getAssetImageForCountry(countryKey, 'accessibility'),
                          icon: Icons.accessible_forward,
                          title: "تسهيلات ذوي الإعاقة",
                          subtitle: "كروت الصم ووضع الهدوء",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AccessibilityHubScreen(
                                  isDarkMode: _isDarkMode,
                                ),
                              ),
                            );
                          },
                        ),
                        _buildImageGridCard(
                          context,
                          imagePath: _getAssetImageForCountry(countryKey, 'help'),
                          icon: Icons.security_outlined,
                          title: "المساعد الجمركي",
                          subtitle: "قائمة المسموح والحد النقدي",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomsRestrictionsScreen(
                                  airportCode: _currentAirportCode,
                                  airportName: _airportData?.airportName ?? currentAirportInfo['name']!,
                                  cityName: currentAirportInfo['city']!,
                                  isDarkMode: _isDarkMode,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: _isDarkMode ? const Color(0xFF101716) : const Color(0xFF8c834a),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavItem(
                  icon: Icons.phone_in_talk_outlined,
                  label: "الطوارئ",
                  onTap: () => EmergencyDialogHelper.show(context, airportCode: _currentAirportCode),
                ),
                _buildBottomNavItem(
                  icon: Icons.directions_car_outlined,
                  label: "المواصلات",
                  onTap: () => TransportDialogHelper.show(context, _currentAirportCode),
                ),
                _buildBottomNavItem(
                  icon: Icons.sim_card_outlined,
                  label: "الشرائح",
                  onTap: () => TelecomDialogHelper.show(context, airportCode: _currentAirportCode),
                ),
                _buildBottomNavItem(
                  icon: Icons.assignment_outlined,
                  label: "كرت الدخول",
                  onTap: () {
                    if (!_isArrivalCardCompleted) {
                      ArrivalCardDialogHelper.show(
                        context,
                        airportCode: _currentAirportCode,
                        hiveService: _hiveService,
                        onCompleted: (completed) {
                          setState(() {
                            _isArrivalCardCompleted = completed;
                          });
                        },
                        showInstructionsCallback: (ctx) {
                          ArrivalInstructionsDialogHelper.show(
                            ctx,
                            airportCode: _currentAirportCode,
                            hiveService: _hiveService,
                            isDarkMode: _isDarkMode,
                          );
                        },
                        isDarkMode: _isDarkMode,
                      );
                    } else {
                      ArrivalInstructionsDialogHelper.show(
                        context,
                        airportCode: _currentAirportCode,
                        hiveService: _hiveService,
                        isDarkMode: _isDarkMode,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAirportHeaderCard({
    required String airportName,
    required String cityName,
    required String airportCode,
    required String countryKey,
  }) {
    return Container(
      width: double.infinity,
      height: 170,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              _getAssetImageForCountry(countryKey, 'customs'),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: const Color(0xFF5E5731));
              },
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.75),
                    Colors.black.withOpacity(0.3),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: Text(
                  airportCode,
                  style: const TextStyle(
                    color: Color(0xFFFFB300),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFFFFB300), size: 18),
                      const SizedBox(width: 4),
                      Text(
                        cityName,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    airportName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGridCard(
    BuildContext context, {
    required String imagePath,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: const Color(0xFF2C3534));
                  },
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.85),
                        Colors.black.withOpacity(0.4),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: const Color(0xFFFFB300), size: 24),
                      ),
                      const Spacer(),
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFFFB300), size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}