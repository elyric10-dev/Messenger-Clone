import 'package:cached_network_image/cached_network_image.dart';
import 'package:ely_ai_messenger/pages/messengerPeople/screens/allUsers.dart';
import 'package:ely_ai_messenger/pages/messengerPeople/screens/friendRequests.dart';
import 'package:ely_ai_messenger/pages/messengerPeople/screens/requestSent.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ely_ai_messenger/DatabaseManager/databaseQuery.dart';

import 'package:ely_ai_messenger/models/friendRequest/pendingFriendRequest.dart';

class MessengerPeoplePage extends StatefulWidget {
  @override
  State<MessengerPeoplePage> createState() => _MessengerPeoplePageState();
}

class _MessengerPeoplePageState extends State<MessengerPeoplePage>
    with SingleTickerProviderStateMixin {
  final DatabaseQuery _databaseQuery = DatabaseQuery();
  final String? currentUserUID = DatabaseQuery().currentUser?.uid;

  List<bool> _isLoading = [];
  List<bool> _isRequestedAlready = [];
  Set<String> _requestedUsers = {};
  late TabController _tabController;

  @override
  void initState() {
    _checkFriendRequest();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  Future<void> _checkFriendRequest() async {
    final friendRequestIds = await _databaseQuery
        .getPendingFriendRequestsOfCurrentUser(currentUserUID);

    // print(currentEmail);
    setState(() {
      _requestedUsers = Set<String>.from(friendRequestIds);
      _isRequestedAlready = List.filled(
          friendRequestIds.length, false); // initialize with false values
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('People'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Users'),
            Tab(text: 'Friend Requests'),
            Tab(text: 'Request Sent'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllUsersScreen(),
          _buildFriendRequestsScreen(),
          _buildRequestsSentScreen(),
        ],
      ),
    );
  }

  Widget _buildAllUsersScreen() {
    return const AllUsersScreen();
  }

  Widget _buildFriendRequestsScreen() {
    return const FriendRequestsScreen();
  }

  Widget _buildRequestsSentScreen() {
    return RequestsSentScreen();
  }
}
