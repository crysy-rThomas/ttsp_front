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
}
