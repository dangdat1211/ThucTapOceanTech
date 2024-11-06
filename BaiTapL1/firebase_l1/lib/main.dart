import 'package:firebase_l1/bai4_5/screens/home_screen.dart';
import 'package:firebase_l1/bai4_5/screens/login_screen.dart';
import 'package:firebase_l1/bai4_5/screens/register_screen.dart';
import 'package:firebase_l1/bai4_5/screens/test_screen.dart';
import 'package:firebase_l1/bai4_5/screens/work_screen.dart';
import 'package:firebase_l1/bai4_5/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService().initNotification();
  tz.initializeTimeZones();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/work': (context) => WorkScreen(),
        '/test': (context) => MyHomePage(title: 'tt',),
      },
    );
  }
}
