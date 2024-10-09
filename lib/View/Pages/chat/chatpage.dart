import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/chating_provider.dart';
import 'package:quick_o_deals/View/Pages/chat/chatscreen.dart';
import 'package:shimmer/shimmer.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
      ),
      body: Consumer<ChattingProvider>(
        builder: (context, chattingProvider, _) {
          final currentUserId = FirebaseAuth.instance.currentUser!.uid;

          return StreamBuilder<List<Map<String, dynamic>>>(
            stream: chattingProvider.getAllChatRooms(currentUserId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)));
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              final chatRooms = snapshot.data ?? [];

              if (chatRooms.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "No chats available",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Start a new conversation to see it here!",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: chatRooms.length,
                itemBuilder: (context, index) {
                  final chatRoom = chatRooms[index];
                  return _buildChatRoomTile(context, chatRoom);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildChatRoomTile(BuildContext context, Map<String, dynamic> chatRoom) {
    final chatRoomId = chatRoom['chatRoomId'];
    final messages = chatRoom['messages'] as List<dynamic>?;

    if (messages == null || messages.isEmpty) {
      return ListTile(
        title: Text('No messages yet in chat room $chatRoomId'),
      );
    }

    final lastMessage = messages.first as Map<String, dynamic>;
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final otherUserId = chatRoomId.split('_').firstWhere((id) => id != currentUserId, orElse: () => 'Unknown');

    return FutureBuilder<Map<String, dynamic>?>(
      future: _getUserDetails(otherUserId),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            title: Text("Loading user..."),
          );
        }

        if (userSnapshot.hasError) {
          return ListTile(
            title: Text("Error loading user: ${userSnapshot.error}"),
          );
        }

        final userData = userSnapshot.data ?? {};
        final lastMessageText = lastMessage['message'] as String? ?? 'No message';

        return ListTile(
          title: Text(userData['username'] ?? 'Unknown User'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lastMessageText, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
          leading: CircleAvatar(
  backgroundImage: CachedNetworkImageProvider(userData['profilePicture'] ?? 'https://via.placeholder.com/150'),
  child: CachedNetworkImage(
    imageUrl: userData['profilePicture'] ?? 'https://via.placeholder.com/150',
    imageBuilder: (context, imageProvider) => CircleAvatar(
      backgroundImage: imageProvider,
    ),
    placeholder: (context, url) => Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: CircleAvatar(
        backgroundColor: Colors.grey[300],
      ),
    ),
    errorWidget: (context, url, error) => const CircleAvatar(
      backgroundImage: NetworkImage('https://via.placeholder.com/150'),
    ),
  ),
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
