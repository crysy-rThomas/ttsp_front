import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ttsp_app/models/conversation.dart';

import '../models/message.dart';

class ChatService {
  Future<Message> sendMessage(String message, int conversationId) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? accessToken = await storage.read(key: 'access_token');

    try {
      final response = await Dio().post(
        'http://127.0.0.1:8000/v0/$conversationId/messages',
        data: {
          'content': message,
          'role': 'user',
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
          },
        ),
      );

      if (response.statusCode == 200) {
        return Message(
            id: response.data['id'],
            index: response.data['index'],
            content: response.data['content'],
            conversationId: response.data['conversation_id'],
            role: response.data['role']);
      }
    } catch (e) {
      print(e);
    }
    throw Exception(
        'Failed to create message'); // Add a throw statement to handle the case when no conversation is created.
  }

  Future<Conversation> createConversation(String name) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? accessToken = await storage.read(key: 'access_token');

    try {
      final response = await Dio().post(
        'http://127.0.0.1:8000/v0/conversation',
        data: {
          'id': 0,
          'name': name,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
          },
        ),
      );
      if (response.statusCode == 200) {
        return Conversation(
            id: response.data['id'], name: response.data['name']);
      }
    } catch (e) {
      print(e);
    }

    throw Exception(
        'Failed to create conversation'); // Add a throw statement to handle the case when no conversation is created.
  }

  Future<List<Conversation>> getConversations() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? accessToken = await storage.read(key: 'access_token');

    try {
      final response = await Dio().get(
        'http://127.0.0.1:8000/v0/conversation',
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
          },
        ),
      );
      if (response.statusCode == 200) {
        List<Conversation> conversations = [];
        for (var conv in response.data) {
          conversations.add(Conversation(id: conv['id'], name: conv['name']));
        }
        return conversations;
      }
    } catch (e) {
      print(e);
    }
    throw Exception(
        'Failed to get conversations'); // Add a throw statement to handle the case when no conversation is created.
  }

  Future<Message> getLastMessage(int conversationId) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? accessToken = await storage.read(key: 'access_token');

    try {
      final response = await Dio().get(
        'http://127.0.0.1:8000/v0/conversation/$conversationId/lastMessage',
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
          },
        ),
      );
      if (response.statusCode == 200) {
        return Message(
            id: response.data['id'],
            index: response.data['index'],
            content: response.data['content'],
            conversationId: response.data['conversation_id'],
            role: response.data['role']);
      }
    } catch (e) {
      print(e);
    }

    throw Exception(
        'Failed to get last message'); // Add a throw statement to handle the case when no conversation is created.
  }

  Future<List<Message>> getMessages(int conversationId) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? accessToken = await storage.read(key: 'access_token');

    try {
      final response = await Dio().get(
        'http://127.0.0.1:8000/v0/$conversationId/messages',
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
          },
        ),
      );
      if (response.statusCode == 200) {
        List<Message> messages = [];
        for (var msg in response.data) {
          messages.add(Message(
            id: msg['id'],
            index: msg['index'],
            content: msg['content'],
            conversationId: msg['conversation_id'],
            role: msg['role'],
          ));
        }
        return messages;
      }
    } catch (e) {
      print(e);
    }
    throw Exception(
        'Failed to get messages'); // Add a throw statement to handle the case when no conversation is created.
  }
}
