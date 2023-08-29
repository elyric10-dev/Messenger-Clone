import 'package:flutter/material.dart';
import 'package:ely_ai_messenger/DatabaseManager/databaseQuery.dart';

class MessengerStoriesPage extends StatefulWidget {
  const MessengerStoriesPage({super.key});

  @override
  State<MessengerStoriesPage> createState() => _MessengerStoriesPageState();
}

class _MessengerStoriesPageState extends State<MessengerStoriesPage> {
  final DatabaseQuery _databaseQuery = DatabaseQuery();

  String? email = "";

  @override
  void initState() {
    _fetchEmail();
    super.initState();
  }

  Future<void> _fetchEmail() async {
    final userEmail = await _databaseQuery.currentUser!.email;
    setState(() {
      email = userEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        const Text(
          "Messenger Stories",
          style: TextStyle(fontSize: 40),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            email!,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await DatabaseQuery().logoutUser();
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Logout",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
