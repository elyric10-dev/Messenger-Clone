// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ely_ai_messenger/models/friendRequest/pendingFriendRequest.dart';

class DatabaseQuery {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  String? get currentEmail => _firebaseAuth.currentUser?.email;

  //Model Collections
  final CollectionReference usersModel =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference friendsModel =
      FirebaseFirestore.instance.collection("friends");
  final CollectionReference pendingFriendRequestsModel =
      FirebaseFirestore.instance.collection("pending_friend_requests");

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logoutUser() async {
    await _firebaseAuth.signOut();
  }

  Future<void> registerUser({
    required String email,
    required String password,
  }) async {
    _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<bool> checkIfEmailExists(String email) async {
    try {
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return false;
    }
  }

  // CREATE
  Future<void> addRecord(String collection, Map<String, dynamic> data) async {
    await _firestore.collection(collection).add(data);
  }

  // READ
  Future<List<Map<String, dynamic>>> getRecords(String collection) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection(collection).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

// READ (stream)
  Stream<List<Map<String, dynamic>>> getRecordsStream(String collection) {
    return _firestore.collection(collection).snapshots().map(
          (querySnapshot) =>
              querySnapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

  // UPDATE
  Future<void> updateRecord(
      String collection, String documentId, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(documentId).update(data);
  }

  // DELETE
  Future<void> deleteRecord(String collection, String documentId) async {
    await _firestore.collection(collection).doc(documentId).delete();
  }

  // ADD FRIEND
  Future<void> addFriend(String? sender, String receiver) async {
    final friendData = {
      'sender_id': sender,
      'receiver_id': receiver,
      'requested_at': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    await pendingFriendRequestsModel.add(friendData);
  }

  // ACCEPT FRIEND REQUEST
  Future<Map<String, String>> acceptFriendRequest(String requestId) async {
    // GET sender_id AND receiver_id FIRST BY DOCUMENT ID
    final DocumentSnapshot snapshot =
        await pendingFriendRequestsModel.doc(requestId).get();
    final String senderId = snapshot.get('sender_id');
    final String receiverId = snapshot.get('receiver_id');

    return {
      'senderId': senderId,
      'receiverId': receiverId,
    };
  }

// GET ALL THE ADDED USERS OF CURRENT USER (ADDED BY THE CURRENT USER)
  Future<List<String>> getPendingFriendRequestsOfCurrentUser(
      String? currentUserId) async {
    final snapshot = await pendingFriendRequestsModel
        .where('sender_id', isEqualTo: currentUserId)
        .get();

    return snapshot.docs.map((doc) => doc['receiver_id'] as String).toList();
  }

  Future<void> sendFriendRequest(PendingFriendRequest request) {
    return pendingFriendRequestsModel.add(request.toMap());
  }

  // GET ALL THE REQUESTS FROM FRIENDS (FRIENDS ADDED YOU)
  Future<List<String>> getFriendPendingRequestsOfCurrentUser(
      String? currentUserId) async {
    print(currentEmail);
    final snapshot = await pendingFriendRequestsModel
        .where('receiver_id', isEqualTo: currentUserId)
        .get();
    return snapshot.docs.map((doc) => doc['sender_id'] as String).toList();
  }
}
