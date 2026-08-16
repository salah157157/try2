import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/airport_package.dart';
import 'screens/splash_screen.dart'; // 👈 استيراد شاشة الترحيب بدلاً من الشاشة الرئيسية مباشرة
import 'services/hive_service.dart';
import 'services/timezone_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  TimezoneService.initialize();

  await Hive.initFlutter();

  Hive.registerAdapter(AirportPackageAdapter());
  Hive.registerAdapter(TelecomOptionAdapter());
  Hive.registerAdapter(TransportOptionAdapter());

  await Hive.openBox<AirportPackage>(HiveService.boxName);
  await Hive.openBox(HiveService.entryCardBoxName);

  runApp(const RahhalApp());
}

class RahhalApp extends StatelessWidget {
  const RahhalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'رحّال - Rahhal',
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: Colors.teal,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7F6),
        cardColor: Colors.white,
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: Colors.tealAccent,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
      ),
      
      themeMode: ThemeMode.system, 

      // 👈 جعل شاشة الترحيب هي البداية عند تشغيل التطبيق
      home: const SplashScreen(),
    );
  }
}