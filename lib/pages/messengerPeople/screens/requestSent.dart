import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ely_ai_messenger/DatabaseManager/databaseQuery.dart';
import 'package:ely_ai_messenger/components/buttons/customButton.dart';
import 'package:ely_ai_messenger/components/shimmers/userShimmer.dart';
import 'package:flutter/material.dart';

class RequestsSentScreen extends StatefulWidget {
  @override
  _RequestsSentScreenState createState() => _RequestsSentScreenState();
}

class _RequestsSentScreenState extends State<RequestsSentScreen> {
  final DatabaseQuery _databaseQuery = DatabaseQuery();
  final String? currentUserUID = DatabaseQuery().currentUser?.uid;
  String? currentEmail = DatabaseQuery().currentEmail;
  String? _currentUserUid;
  bool _isLoading = false;

  Set<String> _pendingRequests = {};
  List<String> _requestId = [];

  final LoadingShimmer _loadingShimmer = LoadingShimmer();
  final CustomButton _customButton = CustomButton();

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _checkFriendRequest();
    super.initState();
  }

  Future<void> _checkFriendRequest() async {
    final requestIds = await _databaseQuery
        .getPendingFriendRequestsOfCurrentUser(_currentUserUid);

    if (mounted) {
      setState(() {
        _pendingRequests = Set.from(requestIds);
      });
    }
  }

  Future<void> _checkRequests() async {
    final requestQuery = await _databaseQuery.pendingFriendRequestsModel
        .where('sender_id', isEqualTo: _currentUserUid)
        .get();

    if (_requestId.isEmpty) {
      requestQuery.docs.forEach((doc) {
        String docId = doc.id;
        _requestId.add(docId);
      });
    }
  }

  Widget requestSentList(String avatar, name, lastName, requestId) {
    void handleCancel(dynamic requestId) async {
      await _databaseQuery.deleteRecord(
        'pending_friend_requests',
        requestId,
      );
      setState(() {
        _checkFriendRequest();
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(avatar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text("$name $lastName"),
            trailing: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _customButton.buttonFullRadius(
                    'Cancel Request',
                    () => handleCancel(requestId),
                    width: 120,
                    color: Colors.blue.shade200,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _databaseQuery.usersModel.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          // USERS ID's CONTAINED ID FROM _pendingRequests
          final pendingList = snapshot.data!.docs
              .where((doc) => _pendingRequests.contains(doc.id))
              .toList();

          // CHECK IF email == currentEmail
          Future<QuerySnapshot<Object?>> querySnapshot = _databaseQuery
              .usersModel
              .where('email', isEqualTo: currentEmail)
              .get();

          // RUN ONLY ONCE. AFTER UPDATED _currentUserUid the _currentUserUid is no longer null
          if (_currentUserUid == null) {
            querySnapshot.then((snapshot) {
              if (snapshot.docs.isNotEmpty) {
                String currentUserUid = snapshot.docs.first.get('user_uid');
                _currentUserUid = currentUserUid;
                _checkFriendRequest().then((_) {
                  setState(() {
                    _isLoading = false;
                  });
                });
                _checkRequests();
              }
            });
          }

          return ListView.builder(
            itemCount: pendingList.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot userData = pendingList[index];
              final String name = userData.get('name');
              final String lastName = userData.get('last_name');
              final String avatar = userData.get('avatar');

              return _isLoading
                  ? _loadingShimmer.userShimmer()
                  : requestSentList(
                      avatar,
                      name,
                      lastName,
                      _requestId[index],
                    );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        );
      },
    );
  }
}
