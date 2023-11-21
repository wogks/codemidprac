// ignore_for_file: avoid_print

import 'package:code_mid/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({required this.storage});
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({'authorization': 'Bearer $token'});
    }
    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({'authorization': 'Bearer $token'});
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (refreshToken == null) {
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';
    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();
      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {'authorization': 'Bearer $refreshToken'},
          ),
        );

        final accessToken = resp.data['accessToken'];
        final options = err.requestOptions;
        options.headers.addAll({'authorization': 'Bearer $accessToken'});
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
        final response = await dio.fetch(options);
        print('해결');
        return handler.resolve(response);
      } catch (e) {
        return handler.reject(err);
      }
    }

    return super.onError(err, handler);
  }
}
