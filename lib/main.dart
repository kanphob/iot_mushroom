import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iot_mushroom/Screen/home_page.dart';
import 'package:iot_mushroom/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iot_mushroom/provider/home_page_provider.dart';
import 'package:iot_mushroom/provider/home_page_statistic_provider.dart';
import 'package:provider/provider.dart';

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
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
        ),
        scrollbarTheme: ScrollbarThemeData(
          thickness: MaterialStateProperty.all(8.00),
          trackVisibility: MaterialStateProperty.all(true),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue.shade900,
          ),
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
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoginScreen();
          } else {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => HomePageProvider(context: context),
                ),
                ChangeNotifierProvider(
                  create: (_) => HomePageStatisticProvider(context: context),
                ),
              ],
              builder: (context, child) {
                return const HomePage();
              },
            );
          }
        },
      ),
    );
  }
}
