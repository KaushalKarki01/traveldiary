import 'package:flutter/material.dart';
import 'package:traveldiary/screens/splash%20screen/splash_screen.dart';

void main() {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFffff00)),
        useMaterial3: true,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500),
          titleMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400),
          titleSmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
          bodyMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w200),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
