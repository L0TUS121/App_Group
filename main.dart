import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/auth/auth_gate.dart';
import 'services/notification_service.dart';
import 'services/theme_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!kIsWeb) {
    await NotificationService.instance.initialize();
  }
  await initializeDateFormatting('uk_UA');
  await ThemeService.instance.initialize();
  runApp(const GroupApp());
}

class GroupApp extends StatelessWidget {
  const GroupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.instance.themeMode,

      builder: (context, themeMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Clamorix',
          themeMode: themeMode,

          //СВітла
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Theme.of(context).colorScheme.onSurface,
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: Colors.white,
          ),

          //темна
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF101010),
          ),
          home: const AuthGate(),
        );
      },
    );
  }
}
