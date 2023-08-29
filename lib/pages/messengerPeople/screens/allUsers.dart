import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ely_ai_messenger/components/buttons/customButton.dart';
import 'package:ely_ai_messenger/components/shimmers/userShimmer.dart';
import 'package:ely_ai_messenger/models/friendRequest/pendingFriendRequest.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ely_ai_messenger/DatabaseManager/databaseQuery.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen>
    with SingleTickerProviderStateMixin {
  final DatabaseQuery _databaseQuery = DatabaseQuery();
  final String? currentUserUID = DatabaseQuery().currentUser?.uid;
  final String? currentEmail = DatabaseQuery().currentUser?.email;
  String? _currentUserUid;
  bool _dataIsLoading = false;

  List<bool> _isLoading = [];
  List<bool> _isRequestedAlready = [];
  Set<String> _requestedUsers = {};

  late TabController _tabController;
  LoadingShimmer _loadingShimmer = LoadingShimmer();
  CustomButton _customButton = CustomButton();

  @override
  void initState() {
    setState(() {
      _dataIsLoading = true;
    });
    _checkFriendRequest();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  Future<void> _checkFriendRequest() async {
    final friendRequestIds = await _databaseQuery
        .getPendingFriendRequestsOfCurrentUser(_currentUserUid);

    setState(() {
      _requestedUsers = Set<String>.from(friendRequestIds);
      _isRequestedAlready = List.filled(
          friendRequestIds.length, false); // initialize with false values
      // _dataIsLoading = false;
    });
  }

  Future<void> _recheckFriendRequest() async {
    final friendRequestIds = await _databaseQuery
        .getPendingFriendRequestsOfCurrentUser(_currentUserUid);

    if (mounted) {
      setState(() {
        _requestedUsers = Set<String>.from(friendRequestIds);
        _isRequestedAlready = List.filled(
            friendRequestIds.length, false); // initialize with false values
        _dataIsLoading = false;
      });
    }
  }

  Widget leadingContent(String avatar) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: CachedNetworkImageProvider(avatar),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<dynamic> handleCancel() async {
    print('Cancel Request');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _databaseQuery.usersModel.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final userList = snapshot.data!.docs;

          //FOR EACH USER _isRequestedAlready = false by DEFAULT
          _isRequestedAlready = List.generate(userList.length, (_) => false);

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot userData = snapshot.data!.docs[index];
              final String name = userData.get('name');
              final String lastName = userData.get('last_name');
              final String avatar = userData.get('avatar');
              final String email = userData.get('email');
              final userUID = userData.id;

              if (email == currentEmail) {
                _currentUserUid = userData.get('user_uid');

                _recheckFriendRequest();
              }

              if (_requestedUsers.contains(userUID)) {
                _isRequestedAlready[index] = true;
              }

              Future<void> addFriendThisUser() async {
                setState(() {
                  _isLoading[index] = true;
                });
                _checkFriendRequest();

                try {
                  final request = PendingFriendRequest(
                    senderId: _currentUserUid,
                    receiverId: userUID,
                    requestedAt: DateTime.now(),
                  );

                  await _databaseQuery.sendFriendRequest(request);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Sent friend request to $name"),
                    ),
                  );

                  setState(
                    () {
                      _isLoading[index] = false;
                      _isRequestedAlready[index] = true;
                    },
                  );
                } catch (e) {
                  print(e);
                  setState(() {
                    _isLoading[index] = false;
                  });
                } finally {
                  setState(() {
                    _isLoading[index] = false;
                  });
                }
              }

              if (_isLoading.length <= index) {
                _isLoading.add(false);
              }

              if (email == currentEmail) {
                return Container();
              }
              return _dataIsLoading
                  ? _loadingShimmer.userShimmer()
                  : Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: ListTile(
                          leading: leadingContent(avatar),
                          title: Text("$name $lastName"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 50,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: _isRequestedAlready[index]
                                        ? Colors.blue.shade200
                                        : Colors.blue,
                                  ),
                                  child: _isRequestedAlready[index]
                                      ? _customButton.buttonFullRadius(
                                          'Cancel Request',
                                          handleCancel,
                                          color: Colors.blue.shade200,
                                        )
                                      : _customButton.buttonFullRadius(
                                          'Add Friend',
                                          addFriendThisUser,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        }
      },
    );
  }
}
