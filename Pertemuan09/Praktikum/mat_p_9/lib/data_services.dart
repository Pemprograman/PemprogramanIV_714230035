import 'user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DataService {
  Future<Map<String, dynamic>?> getUsers() async {
    try {
      final response = await dio.get('/users');
      return response.data;
    } catch (e) {
      debugPrint('Error GET users: $e');
      return null;
    }
  }

  Future<UserCreate?> postUser(UserCreate user) async {
    try {
      final response = await dio.post(
        '/users',
        data: user.toMap(),
      );

      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('DATA: ${response.data}');

      if (response.statusCode == 201) {
        return UserCreate.fromJson(response.data);
      }

      return null;
    } on DioException catch (e) {
      debugPrint('DIO ERRROR STATUS: ${e.response?.statusCode}');
      debugPrint('DIO ERROR DATA: ${e.response?.data}');
      return null;
    } catch (e) {
      debugPrint('ERROR: $e');
      return null;
    }
  }

  Future putUser(String idUser, String name, String job) async {
    try {
      final response = await dio.put(
        '/users/$idUser',
        data: {'name' : name, 'job' : job},
      );

      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('DATA: ${response.data}');

      if (response.statusCode == 200) {
        return response.data;
      }

      return null;
    } on DioException catch (e) {
      debugPrint('DIO ERRROR STATUS: ${e.response?.statusCode}');
      debugPrint('DIO ERROR DATA: ${e.response?.data}');
      return null;
    } catch (e) {
      debugPrint('ERROR: $e');
      return null;
    }
  }

  Future deleteUser(String idUser) async {
    try {
      final response = await dio.delete('/users/$idUser');

      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('DATA: ${response.data}');

      if (response.statusCode == 204) {
        return 'User deleted successfully';
      }

      return 'Failed to delete user';
    } on DioException catch (e) {
      debugPrint('DIO ERRROR STATUS: ${e.response?.statusCode}');
      debugPrint('DIO ERROR DATA: ${e.response?.data}');
      return 'Failed to delete user';
    } catch (e) {
      debugPrint('ERROR: $e');
      return 'Failed to delete user';
    }
  }

  Future<Iterable<User>?> getUserModel() async {
    String baseUrl = 'https://reqres.in/api';
    try {
      final response = await dio.get('$baseUrl/users');

      if (response.statusCode == 200) {
        final users = (response.data['data'] as List)
            .map((user) => User.fromJson(user))
            .toList();
      return users;
      }
      return null;
    } on DioException catch (e) {
      debugPrint('DIO ERRROR STATUS: ${e.response?.statusCode}');
      debugPrint('DIO ERROR DATA: ${e.response?.data}');
      return null;
    } catch (e) {
      debugPrint('ERROR: $e');
      return null;
    }
  }

  final Dio dio = Dio(
  BaseOptions(
    baseUrl: 'https://reqres.in/api',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'x-api-key': 'reqres_bbca121c38f748198e21e44314b34e2b',
    },
  ),
);
} 

