import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ely_ai_messenger/DatabaseManager/databaseQuery.dart';

class CrudExample extends StatefulWidget {
  const CrudExample({Key? key}) : super(key: key);

  @override
  _CrudExampleState createState() => _CrudExampleState();
}

class _CrudExampleState extends State<CrudExample> {
  final DatabaseQuery _databaseQuery = DatabaseQuery();
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _databaseQuery.currentUser;
  }

  Future<void> _addRecord() async {
    await _databaseQuery.addRecord('users', {
      'avatar': 'testing URL',
      'email': 'for@testing.com',
      'last_name': 'Testing Lastname',
      'name': 'Testing Name',
      'online': true,
      'stories': false
    });
  }

  Future<void> _updateRecord(String documentId) async {
    await _databaseQuery.updateRecord('users', documentId, {
      'avatar': 'testing URL UPDATED',
      'email': 'for@testing.com UPDATED',
      'last_name': 'Testing Lastname UPDATED',
      'name': 'Testing Name UPDATED',
      'online': false,
      'stories': true
    });
  }

  Future<void> _deleteRecord(String documentId) async {
    await _databaseQuery.deleteRecord('users', documentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing CRUD'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Current user: ${_currentUser?.email ?? 'Not logged in'}'),
            ElevatedButton(
              onPressed: _addRecord,
              child: const Text('Add Record'),
            ),
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: _databaseQuery.getRecordsStream('users'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final records = snapshot.data ?? [];
                return Expanded(
                  child: ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      String documentId = records[index]['id'];
                      String fieldValue = records[index]['email'];
                      return ListTile(
                        title: Text(fieldValue),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              onPressed: () => _updateRecord(documentId),
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () => _deleteRecord(documentId),
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
