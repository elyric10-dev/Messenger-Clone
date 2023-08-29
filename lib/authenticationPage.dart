import 'package:ely_ai_messenger/DatabaseManager/databaseQuery.dart';
import 'package:ely_ai_messenger/pages/homepage.dart';
import 'package:ely_ai_messenger/pages/loginAndRegisterPage.dart';
import 'package:flutter/material.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<AuthenticationPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DatabaseQuery().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return const LoginAndRegisterPage();
          }
        });
  }
}
