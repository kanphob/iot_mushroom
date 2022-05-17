import 'package:flutter/material.dart';
import 'package:siwat_mushroom/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:siwat_mushroom/provider/login_screen_provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    print('Connect Success');
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(),
          errorBorder: OutlineInputBorder(),
        ),
      ),
      home: MultiProvider(providers: [
          ChangeNotifierProvider(create: (_) =>  LoginScreenProvider(),
          ),
      ],child: LoginScreen(),),
    );
  }

}
