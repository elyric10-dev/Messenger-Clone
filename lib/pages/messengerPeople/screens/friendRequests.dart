import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ely_ai_messenger/DatabaseManager/databaseQuery.dart';
import 'package:ely_ai_messenger/components/shimmers/userShimmer.dart';
import 'package:ely_ai_messenger/components/buttons/customButton.dart';

class FriendRequestsScreen extends StatefulWidget {
  const FriendRequestsScreen({super.key});

  @override
  State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  final DatabaseQuery _databaseQuery = DatabaseQuery();
  final String? currentUserUID = DatabaseQuery().currentUser?.uid;
  String? currentEmail = DatabaseQuery().currentEmail;
  String? _currentUserUid;
  bool _isLoading = false;

  Set<String> _friendPendingRequests = {};
  List<String> _requestId = [];

  LoadingShimmer _loadingShimmer = LoadingShimmer();

  CustomButton _customButton = CustomButton();
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
        .getFriendPendingRequestsOfCurrentUser(_currentUserUid);

    if (mounted) {
      setState(() {
        _friendPendingRequests = Set.from(requestIds);
      });
    }
  }

  Future<void> _checkRequests() async {
    final requestQuery = await _databaseQuery.pendingFriendRequestsModel
        .where('receiver_id', isEqualTo: _currentUserUid)
        .get();

    if (_requestId.isEmpty) {
      requestQuery.docs.forEach((doc) {
        String docId = doc.id;
        _requestId.add(docId);
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

  Widget customButton(String label, Function function) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 100,
        height: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: ElevatedButton(
            onPressed: () => function(),
            child: Text(label),
          ),
        ),
      ),
    );
  }

  Widget friendRequestList(String avatar, name, lastName, requestId) {
    void handleDecline(requestId) async {
      await _databaseQuery.deleteRecord(
        'pending_friend_requests',
        requestId,
      );
      setState(() {
        _checkFriendRequest();
      });
    }

    void handleAccept(requestId) async {
      final result = await _databaseQuery.acceptFriendRequest(requestId);

      print(result);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: leadingContent(avatar),
            title: Text("$name $lastName"),
            trailing: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: _customButton.buttonFullRadius(
                      'Accept',
                      () => handleAccept(requestId),
                      width: 80,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: _customButton.buttonFullRadius(
                      'Decline',
                      () => handleDecline(requestId),
                      color: Colors.blue.shade200,
                      width: 80,
                    ),
                  )
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
          final requestsList = snapshot.data!.docs
              .where((doc) => _friendPendingRequests.contains(doc.id))
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
            itemCount: requestsList.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot userData = requestsList[index];
              final String name = userData.get('name');
              final String lastName = userData.get('last_name');
              final String avatar = userData.get('avatar');

              return _isLoading
                  ? _loadingShimmer.userShimmer()
                  : friendRequestList(
                      avatar,
                      name,
                      lastName,
                      _requestId[index],
                    );
            },
          );
        }
        return const Center(
          child: Text("No request found"),
        );
      },
    );
  }
}
