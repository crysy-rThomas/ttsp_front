import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ttsp_app/models/conversation.dart';
import 'package:ttsp_app/models/message.dart';
import '../../main.dart';
import '../../services/chat_service.dart';

int? currentConversationId;
GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey(); 
class History extends StatefulWidget {
  final Function(int) setPageCallback;
  const History({super.key, required this.setPageCallback});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final ChatService _chatService = ChatService();
  List<Conversation> _conversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchConversations();
  }

  Future<void> _fetchConversations() async {
    try {
      List<Conversation> conversations = await _chatService.getConversations();
      setState(() {
        _conversations = conversations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching conversations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.greenAccent,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _conversations.isEmpty
                ? const Center(child: Text('No conversations found'))
                : ListView.builder(
                    itemCount: _conversations.length,
                    itemBuilder: (context, index) {
                      Conversation conversation = _conversations[index];
                      return FutureBuilder<Message>(
                        future: _chatService.getLastMessage(conversation.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            Message msg = snapshot.data!;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentConversationId = conversation.id;
                                  pos = 0;
                                });
                                widget.setPageCallback(0);
                                final CurvedNavigationBarState? navBarState =
                                    _bottomNavigationKey.currentState;
                                navBarState?.setPage(0);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Title : ${conversation.name.length > 20 ? conversation.name.substring(0, 10) : conversation.name}....',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          _chatService.deleteConversation(conversation.id);
                                          _conversations.removeWhere((conversationItem) => conversationItem.id == conversation.id);
                                          _fetchConversations();
                                        },
                                      ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Text('${msg.content.length > 100 ? msg.content.substring(0, 100) : msg.content}.....'),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
      ),
    );
  }
}
