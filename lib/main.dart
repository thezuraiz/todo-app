import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/Pages/auth/authscreen.dart';
import 'package:todo_app/Pages/home.dart';
import 'package:todo_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              textStyle: MaterialStateProperty.all(
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 18))),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            return const HomePage();
          } else if (snapShot.connectionState == ConnectionState.waiting) {
            return const Text("Connection Lost");
          } else {
            return const LoginSignUpPage();
          }
        },
      ),
    );
  }
}
