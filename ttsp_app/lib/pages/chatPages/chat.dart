import 'package:flutter/material.dart';
import 'package:ttsp_app/models/message.dart';
import '../../services/chat_service.dart';
import '../historyPages/history.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> with WidgetsBindingObserver {
  final List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ChatService _chat = ChatService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadConversation() async {
    if (currentConversationId != null) {
      setState(() {
        _isLoading = true;
        _messages.clear();
      });

      List<Message> messages = await _chat.getMessages(currentConversationId!);
      setState(() {
        _messages.addAll(messages.map((message) => message.content));
        _isLoading = false;
      });
    }
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final String messageText = _controller.text;
      try {
        if (_messages.isEmpty && currentConversationId == null) {
          final conversation = await _chat.createConversation(messageText);
          currentConversationId = conversation.id;
        }
        setState(() {
          _messages.add(messageText);
          _controller.clear();
          _isLoading = true;
        });

        Message responseMessage =
            await _chat.sendMessage(messageText, currentConversationId!);

        setState(() {
          _messages.add(responseMessage.content);
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Error sending message: $e');
      }
    }
  }

  void _startNewConversation() async {

    if (currentConversationId != null) {
      setState(() {
        currentConversationId = null;
        _messages.clear();
      });
    }

    String name = _controller.text;
    if (name.isNotEmpty) {
      try {
        await _chat.createConversation(name);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Conversation started')));
        _controller.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to start conversation')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueAccent,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      _messages[index],
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 20.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_outlined, color: Colors.white,),
                    onPressed: _startNewConversation,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Entrer votre message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Icon(Icons.send),
                    color: Colors.white,
                    onPressed: _isLoading ? null : _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
