class PendingFriendRequest {
  final String? senderId;
  final String receiverId;
  final DateTime requestedAt;

  PendingFriendRequest({
    required this.senderId,
    required this.receiverId,
    required this.requestedAt,
  });

  factory PendingFriendRequest.fromMap(Map<String, dynamic> data) {
    return PendingFriendRequest(
      senderId: data['sender_id'],
      receiverId: data['receiver_id'],
      requestedAt: DateTime.parse(data['requested_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'requested_at': requestedAt.toIso8601String(),
    };
  }
}
