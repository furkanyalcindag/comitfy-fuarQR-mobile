import 'dart:io';
import 'package:http_interceptor/http_interceptor.dart';
import 'cache_manager.dart';

class ApiInterceptor implements InterceptorContract {
  final String defaultLocale = Platform.localeName;

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    String? token = await CacheManager().getToken();

    if (token == null) {
      token = "";
    } else {
      token = await CacheManager().getToken();
    }

    print(token);

    try {
      data.headers['accept-header'] = 'application/json';
      data.headers['content-type'] = 'application/json';
      data.headers['authorization'] = 'Bearer $token';
      // New locales can be added with if else statement.
      data.headers['accept-language'] = "TR";
      data.headers[HttpHeaders.contentTypeHeader] = "application/json";
    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async =>
      data;
}
