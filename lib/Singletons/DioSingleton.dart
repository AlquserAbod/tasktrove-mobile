import 'package:dio/dio.dart';

class DioSingleton {
  static final DioSingleton _singleton = DioSingleton._internal();
  late Dio _dio;

  factory DioSingleton() {
    return _singleton;
  }

  DioSingleton._internal() {
    _dio = Dio();
  }

  Dio get dioInstance => _dio;

  void setJwtToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
}
