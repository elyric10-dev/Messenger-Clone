// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ely_ai_messenger/DatabaseManager/databaseQuery.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _avatarController = TextEditingController();
  bool _online = true;
  // bool _stories = false;

  void _createUser() async {
    Map<String, dynamic> data = {
      'name': _nameController.text,
      'last_name': _lastNameController.text,
      'email': _emailController.text,
      'avatar': _avatarController.text,
      'online': _online,
      // 'stories': _stories,
    };
    await DatabaseQuery().addRecord('testing', data);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success!'),
          content: const Text('User added to the database.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _avatarController,
              decoration: const InputDecoration(
                labelText: 'Avatar URL',
              ),
            ),
            Row(
              children: [
                const Text('Online:'),
                Switch(
                  value: _online,
                  onChanged: (value) {
                    setState(() {
                      _online = value;
                    });
                  },
                ),
              ],
            ),
            // Row(
            //   children: [
            //     const Text('Has Stories:'),
            //     Switch(
            //       value: _stories,
            //       onChanged: (value) {
            //         setState(() {
            //           _stories = value;
            //         });
            //       },
            //     ),
            //   ],
            // ),
            ElevatedButton(
              onPressed: _createUser,
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
