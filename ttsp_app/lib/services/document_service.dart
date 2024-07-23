import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ttsp_app/models/document.dart';

class DocumentService {
  Future<List<Document>> getDocuments() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'access_token');

    try {
      var response = await Dio().get(
        'http://127.0.0.1:8000/v0/documents',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200) {
        final List<Document> documents = [];
        for (final doc in response.data) {
          documents.add(Document(
            id: doc['id'],
            title: doc['name'],
            content: "test",
          ));
        }
        return documents;
      }
    } catch (e) {
      print(e);
    }
    throw Exception('Failed to get documents');
  }

  Future<String> getDocumentContent(String id) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'access_token');

    try {
      var response = await Dio().get(
        'http://127.0.0.1:8000/v0/document/$id/content',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print(e);
    }
    throw Exception('Failed to get document content');
  }

  Future<Document> addDocument(String title, String content) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'access_token');

    try {
      var response = await Dio().post(
        'http://127.0.0.1:8000/v0/document/manual',
        data: {
          'name': title,
          'content': content,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200) {
        return Document(
          id: response.data['id'],
          title: response.data['name'],
          content: response.data['content'],
        );
      } else {
        // Handle non-200 responses
        print('Server responded with status code: ${response.statusCode}');
        print('Response data: ${response.data}');
        throw Exception('Failed to add document');
      }
    } catch (e) {
      // Catch and print any errors for debugging
      print('Error adding document: $e');
      rethrow; // Rethrow the error to be handled by the caller
    }
  }
}
