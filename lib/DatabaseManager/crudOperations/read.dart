// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ely_ai_messenger/DatabaseManager/databaseQuery.dart';

class ReadPage extends StatefulWidget {
  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  final DatabaseQuery _databaseQuery = DatabaseQuery();

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: StreamBuilder(
        stream: _databaseQuery.usersModel.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot userData = snapshot.data!.docs[index];
                final documentId = userData.id;

                final TextEditingController avatarController =
                    TextEditingController(text: userData['avatar']);
                final TextEditingController lastNameController =
                    TextEditingController(text: userData['last_name']);
                final TextEditingController nameController =
                    TextEditingController(text: userData['name']);

                Future<void> updateUser(Function setState) async {
                  setState(() {
                    _isLoading = true;
                  });
                  final updatedData = {
                    'avatar': avatarController.text,
                    'last_name': lastNameController.text,
                    'name': nameController.text,
                  };
                  try {
                    await _databaseQuery.updateRecord(
                        'users', documentId, updatedData);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Successfully Updated!'),
                      ),
                    );
                    Navigator.pop(context);
                  } catch (error) {
                    print(error);
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }

                Future<void> deleteUser(Function setState) async {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    await _databaseQuery.deleteRecord('users', documentId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User Deleted Successfully!'),
                      ),
                    );
                    Navigator.of(context).pop();
                  } catch (e) {
                    print(e);
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }

// PUT LOADING ON DELETE NEXT MEETING
                return ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(userData['avatar']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  title: Text(userData['name']),
                  subtitle: Text(userData['email']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25))),
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      top: 20,
                                      right: 20,
                                      left: 20,
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: nameController,
                                          decoration: const InputDecoration(
                                            labelText: 'Name',
                                          ),
                                          keyboardType: TextInputType.text,
                                        ),
                                        TextField(
                                          controller: lastNameController,
                                          decoration: const InputDecoration(
                                            labelText: 'Lastname',
                                          ),
                                          keyboardType: TextInputType.text,
                                        ),
                                        TextField(
                                          controller: avatarController,
                                          decoration: const InputDecoration(
                                            labelText: 'Avatar',
                                          ),
                                          keyboardType: TextInputType.text,
                                        ),
                                        ElevatedButton(
                                          onPressed: _isLoading
                                              ? null
                                              : () => updateUser(setState),
                                          child: _isLoading
                                              ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : const Text('Save Changes'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Delete User',
                                    style: TextStyle(
                                        backgroundColor: Colors.red,
                                        color: Colors.white),
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(
                                          'Are you sure you want to delete ${userData['email']}?'),
                                      const SizedBox(height: 8),
                                      CachedNetworkImage(
                                        imageUrl: userData['avatar'],
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () => deleteUser(setState),
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(),
                                          )
                                        : const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
