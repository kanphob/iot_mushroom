import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:siwat_mushroom/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    if (kDebugMode) {
      print('Connect Success');
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IOT MUSHROOM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scrollbarTheme: ScrollbarThemeData(
          thickness: MaterialStateProperty.all(8.00),
          trackVisibility: MaterialStateProperty.all(true),
        ),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade800),
          ),
          errorBorder: const OutlineInputBorder(),
        ),
      ),
      home: const LoginScreen(),
    );
  }

}
