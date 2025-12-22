import 'package:dio/dio.dart';

class ApiInterceptors extends Interceptor {
  final bool isFormData;
  ApiInterceptors({this.isFormData = false});
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    //options.headers["Accept-Language"] = "en";
    // options.headers[ApiKey.token] = CacheHelper().getData(key: ApiKey.token)!=null?'FOODAPI ${CacheHelper().getData(key: ApiKey.token)}':null;
    // options.headers["Content-Type"] = isFormData ? 'application/json';
    super.onRequest(options, handler);
  }
}
