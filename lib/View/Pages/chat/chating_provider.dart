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
  print("Fetching chats for receiver: $userId");
  return _fireStore
      .collection('chat_rooms')
      .where('participants', arrayContains: userId)
      .snapshots()
      .handleError((error) {
        print('Error fetching chats: $error'); 
      });
}

Stream<List<Map<String, dynamic>>> getAllChatRooms(String currentUserId) {
  return FirebaseFirestore.instance
      .collection('chat_rooms')
      .snapshots()
      .asyncMap((snapshot) async {
        // Filter chat rooms where currentUserId is either the sender or receiver
        final filteredChatRooms = snapshot.docs.where((doc) {
          final ids = doc.id.split('_');
          final receiverId = ids[0];
          final senderId = ids[1];

          return receiverId == currentUserId || senderId == currentUserId;
        }).toList();

        // Fetch messages for each filtered chat room
        List<Map<String, dynamic>> chatRoomsWithMessages = [];

        for (var chatRoom in filteredChatRooms) {
          final chatRoomId = chatRoom.id;

          // Get the latest messages from the `messages` subcollection
          final messagesSnapshot = await FirebaseFirestore.instance
              .collection('chat_rooms')
              .doc(chatRoomId)
              .collection('messages')
              .orderBy('timestamp', descending: true)
              .get();

          // Convert message documents to a list of maps
          List<Map<String, dynamic>> messages = messagesSnapshot.docs
              .map((msgDoc) => msgDoc.data())
              .toList();

          // Append chat room data with messages
          chatRoomsWithMessages.add({
            'chatRoomId': chatRoomId,
            'messages': messages,
            ...chatRoom.data(),
          });
        }

        return chatRoomsWithMessages;
      });
}





void fetchAllChats() {
  notifyListeners(); // Trigger the rebuild of the chat list screen
}


  Stream<QuerySnapshot<Object?>> getMessagesForChatRoom(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .handleError((error) {
          print('Error fetching messages: $error');
        });
  }
}
