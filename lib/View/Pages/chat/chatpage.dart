import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/View/Pages/chat/chating_provider.dart';
import 'package:quick_o_deals/View/Pages/chat/chatscreen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChattingProvider>(context, listen: false).fetchAllChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
      ),
      body: Consumer<ChattingProvider>(
        builder: (context, chattingProvider, _) {
          return StreamBuilder<QuerySnapshot>(
            stream: chattingProvider.getAllChats(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No Chats Available"));
              }

              final chatRooms = snapshot.data!.docs;

              return ListView.builder(
                itemCount: chatRooms.length,
                itemBuilder: (context, index) {
                  final chatRoom = chatRooms[index];
                  final otherUserId = _getOtherUserId(chatRoom);

                  return FutureBuilder<Map<String, dynamic>?>(
                    future: _getUserDetails(otherUserId),
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData) {
                        return const ListTile(
                          title: Text("Loading..."),
                        );
                      }

                      final userData = userSnapshot.data!;
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chat_rooms')
                            .doc(chatRoom.id)
                            .collection('messages')
                            .orderBy('timestamp', descending: true)
                            .limit(1)
                            .snapshots(),
                        builder: (context, messageSnapshot) {
                          String lastMessageText = "No messages yet";
                          if (messageSnapshot.hasData && messageSnapshot.data!.docs.isNotEmpty) {
                            lastMessageText = messageSnapshot.data!.docs.first['message'];
                          }

                          return ListTile(
                            title: Text(userData['username']),
                            subtitle: Text(lastMessageText),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(userData['profilePicture']),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(userId: otherUserId),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _getOtherUserId(DocumentSnapshot chatRoom) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final participants = List<String>.from(chatRoom['participants']);
    return participants.firstWhere((id) => id != currentUserId);
  }

  Future<Map<String, dynamic>?> _getUserDetails(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (snapshot.exists) {
        return snapshot.data();
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
    return null;
  }
}