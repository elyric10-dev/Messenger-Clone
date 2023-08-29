// ignore_for_file: use_key_in_widget_constructors
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ely_ai_messenger/authenticationPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase. initializeApp();
  //     options: FirebaseOptions(
  //   apiKey: 'AIzaSyDJ9Ktmz7HXqxY8Ao73hk0VVhrpH0Jfq6I',
  //   appId: '1:284283583028:web:97e4e88a2eb24abf966861',
  //   messagingSenderId: '284283583028',
  //   projectId: 'emessenger-856f6',
  // ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: AuthenticationPage(),
      ),
    );
  }
}
