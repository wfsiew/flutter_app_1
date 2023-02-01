import 'package:dio/dio.dart';

class ApiHelper {

  static final Dio dio = Dio(BaseOptions(connectTimeout: 5000, receiveTimeout: 15000));
}