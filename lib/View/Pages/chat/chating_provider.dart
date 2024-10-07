import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_o_deals/View/Pages/chat/chat_model.dart';


class ChattingProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Map<String, bool> _hasUnreadMessageMap = {};
  Map<String, Message?> _lastMessages = {};
  Map<String, bool> _isChatOpened = {};

  Map<String, bool> get hasUnreadMessageMap => _hasUnreadMessageMap;
  Map<String, Message?> get lastMessages => _lastMessages;
  Map<String, bool> get isChatOpened => _isChatOpened;

  // Get Last Message
  //************************************************************************** */

  Stream<Message?> getLastMessage(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _fireStore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        Message message = Message.fromMap(querySnapshot.docs.first.data());
        _lastMessages[otherUserId] = message;
        _hasUnreadMessageMap[otherUserId] = true;
        notifyListeners(); // Notify listeners of state change
        return message;
      } else {
        return null;
      }
    });
  }

  // Mark as Read
  //************************************************************************** */

  void markAsRead(String doctorId) {
    if (_hasUnreadMessageMap.containsKey(doctorId)) {
      _hasUnreadMessageMap[doctorId] = false;
      notifyListeners(); // Notify listeners of state change
    }
  }

  // Mark Chat as Opened/Closed
  //************************************************************************** */

  void markChatOpened(String doctorId) {
    _isChatOpened[doctorId] = true;
    notifyListeners(); // Notify listeners of state change
  }

  void markChatClosed(String doctorId) {
    _isChatOpened[doctorId] = false;
    notifyListeners(); // Notify listeners of state change
  }

  // Send Message
  //************************************************************************** */

  Future<void> sendMessage(String receiverId, String message) async {
    final currentUserId = _auth.currentUser!.uid;
    final currentuserEmail = _auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatroomId = ids.join("_");
    final idtime = Timestamp.now().microsecondsSinceEpoch;

    Message newMessage = Message(
      messageId: "$chatroomId""_$idtime",
      newMessage: true,
      senderId: currentUserId,
      senderEmail: currentuserEmail,
      receverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    await _fireStore
        .collection("chat_rooms")
        .doc(chatroomId)
        .collection("messages")
        .doc("$chatroomId""_$idtime")
        .set(newMessage.toMap());

    notifyListeners(); // Notify listeners after sending a message
  }

  // Get Messages Stream
  //************************************************************************** */

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _fireStore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }


     Stream<QuerySnapshot> getUserChats(String userId) {
    return _fireStore
        .collection('chat_rooms')
        .where('participants', arrayContains: userId)
        .snapshots();
  }

  void fetchAllChats() {
    notifyListeners(); // Trigger the rebuild of the chat list screen
  }

    Stream<QuerySnapshot> getAllChats() {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('chat_rooms')
        .where('participants', arrayContains: currentUserId)
        .snapshots();
  }


}
