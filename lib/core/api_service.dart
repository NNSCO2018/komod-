import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio dio;

  ApiService._internal() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://ideal-engine-rrp76xq5g6v2w59g-8000.app.github.dev/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, dynamic>> requestOtp(String phone) async {
    final response = await dio.post('/auth/request-otp', data: {'phone': phone});
    return response.data;
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final response = await dio.post('/auth/verify-otp', data: {'phone': phone, 'otp': otp});
    final data = response.data;
    if (data['token'] != null) {
      await saveToken(data['token']);
    }
    return data;
  }
}
