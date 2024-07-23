import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuhtenticationService {
  final Dio _dio = Dio();

  Future<String> register(name, password) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    try {
      Response response = await _dio
          .post("http://127.0.0.1:8000/signup", data: {
        "username": name,
        "password": password
      });
      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response data
        String accessToken = response.data['access_token'];
        String refreshToken = response.data['refresh_token'];
        storage.write(key: "access_token", value: accessToken);
        storage.write(key: "refresh_token", value: refreshToken);
        return accessToken;
      } else {
        // Handle error if the request was not successful
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle Dio errors
      print('Error: $e');
      rethrow;
    }
  }

  Future<String> login(String username, String password) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final Dio _dio = Dio();
    try {
      FormData formData = FormData.fromMap({
        "username": username,
        "password": password,
      });
      Response response = await _dio.post(
        "http://127.0.0.1:8000/login",
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      // Check if the request was successful
      if (response.statusCode == 200) {
        // Assuming the response data is a token
        String accessToken = response.data['access_token'];
        String refreshToken = response.data['refresh_token'];
        print(accessToken);
        storage.write(key: "access_token", value: accessToken);
        storage.write(key: "refresh_token", value: refreshToken);
        return accessToken;
      } else {
        // Handle error if the request was not successful
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle Dio errors
      print('Error: $e');
      rethrow;
    }
  }
}
