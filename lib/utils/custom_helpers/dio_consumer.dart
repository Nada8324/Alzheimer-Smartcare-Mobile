// import 'package:dio/dio.dart';
// import 'package:fly_wise/core/api/api_interceptors.dart';
// import 'package:fly_wise/core/api/end_points.dart';
// import 'package:fly_wise/utils/Functions/cache/cache_helper.dart';
//
// import '../exception/exceptions.dart';
// import 'api_consumer.dart';
//
// class DioConsumer extends ApiConsumer {
//   Dio dio = Dio();
//   DioConsumer({required this.dio}) {
//     dio.options.baseUrl = EndPoints.baseUrl;
//     dio.options.headers = {
//       "Authorization": CacheHelper().getData(key: ApiKey.token) != null
//           ? 'Bearer ${CacheHelper().getData(key: ApiKey.token)}'
//           : null,
//       "Accept": "application/json"
//     };
//     dio.options.followRedirects = true; // Enable automatic redirects
//     dio.interceptors.add(ApiInterceptors());
//     dio.interceptors.add(LogInterceptor(
//       request: true,
//       requestHeader: true,
//       requestBody: true,
//       responseHeader: true,
//       responseBody: true,
//       error: true,
//     ));
//   }
//   @override
//   Future<dynamic> getData(
//     String path, {
//     Map<String, dynamic>? queryParameters,
//     dynamic data,
//     bool isFormData = false,
//   }) async {
//     // TODO: implement getData
//     try {
//       final response = await dio.get(path,
//           queryParameters: queryParameters,
//           data: isFormData ? FormData.fromMap(data) : data);
//       return response.data;
//     } on DioException catch (e) {
//       handleDioExceptions(e);
//     }
//   }
//
//   @override
//   Future deleteData(
//     String path, {
//     Map<String, dynamic>? queryParameters,
//     dynamic data,
//     bool isFormData = false,
//   }) async {
//     // TODO: implement getData
//     try {
//       final response = await dio.delete(path,
//           queryParameters: queryParameters,
//           data: isFormData ? FormData.fromMap(data) : data);
//       return response.data;
//     } on DioException catch (e) {
//       handleDioExceptions(e);
//     }
//   }
//
//   @override
//   Future patchData(
//     String path, {
//     Map<String, dynamic>? queryParameters,
//     dynamic data,
//     bool isFormData = false,
//   }) async {
//     // TODO: implement getData
//     try {
//       final response = await dio.patch(path,
//           queryParameters: queryParameters,
//           data: isFormData ? FormData.fromMap(data) : data);
//       return response.data;
//     } on DioException catch (e) {
//       handleDioExceptions(e);
//     }
//   }
//
//   @override
//   Future postData(
//     String path, {
//     Map<String, dynamic>? queryParameters,
//     dynamic data,
//     bool isFormData = false,
//   }) async {
//     // TODO: implement getData
//     try {
//       final response = await dio.post(path,
//           queryParameters: queryParameters,
//           data: isFormData ? FormData.fromMap(data) : data);
//       return response.data;
//     } on DioException catch (e) {
//       handleDioExceptions(e);
//     }
//   }
//
//   @override
//   Future putData(
//     String path, {
//     Map<String, dynamic>? queryParameters,
//     dynamic data,
//     bool isFormData = false,
//   }) async {
//     // TODO: implement getData
//     try {
//       final response = await dio.put(path,
//           queryParameters: queryParameters,
//           data: isFormData ? FormData.fromMap(data) : data);
//       return response.data;
//     } on DioException catch (e) {
//       handleDioExceptions(e);
//     }
//   }
// }

import 'package:dio/dio.dart';
import '../constants/endpoints.dart';
import 'api_consumer.dart';
import 'api_interceptors.dart';
import 'cache_helper.dart';

class DioConsumer extends ApiConsumer {
  Dio dio = Dio();
  String baseUrl ;
  DioConsumer({required this.dio,this.baseUrl = Endpoints.baseUrl}) {
    dio.options.baseUrl = baseUrl;
    dio.options.headers = {
      "Authorization": CacheHelper().getData(key: ApiKey.token) != null
          ? 'Bearer ${CacheHelper().getData(key: ApiKey.token)}'
          : null,
      "Accept": "application/json"
    };
    dio.options.followRedirects = true; // Enable automatic redirects
    dio.interceptors.add(ApiInterceptors());
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<dynamic> _handleRequest(
      Future<Response> Function() request, {
        Function(dynamic)? onSuccess,
        Function(DioException)? onError,
      }) async {
    try {
      final response = await request();
      if (onSuccess != null) {
        onSuccess(response.data);
      }
      return response.data;
    } on DioException catch (e) {
      if (onError != null) {
        onError(e);
      }
     // handleDioExceptions(e);
    }
  }

  @override
  Future<dynamic> getData(
      String path, {
        Map<String, dynamic>? queryParameters,
        dynamic data,
        bool isFormData = false,
        Options? options,
        Function(dynamic)? onSuccess,
        Function(DioException)? onError,
      }) {
    return _handleRequest(
          () => dio.get(
        path,
        queryParameters: queryParameters,
        data: isFormData ? FormData.fromMap(data) : data,
      ),
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  @override
  Future deleteData(
      String path, {
        Map<String, dynamic>? queryParameters,
        dynamic data,
        bool isFormData = false,
        Function(dynamic)? onSuccess,
        Function(DioException)? onError,
      }) {
    return _handleRequest(
          () => dio.delete(
        path,
        queryParameters: queryParameters,
        data: isFormData ? FormData.fromMap(data) : data,
      ),
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  @override
  Future patchData(
      String path, {
        Map<String, dynamic>? queryParameters,
        dynamic data,
        bool isFormData = false,
        Function(dynamic)? onSuccess,
        Function(DioException)? onError,
      }) {
    return _handleRequest(
          () => dio.patch(
        path,
        queryParameters: queryParameters,
        data: isFormData ? FormData.fromMap(data) : data,
      ),
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  @override
  Future postData(
      String path, {
        Map<String, dynamic>? queryParameters,
        dynamic data,
        bool isFormData = false,
        Options? options,
        Function(dynamic)? onSuccess,
        Function(DioException)? onError,
      }) {
    return _handleRequest(
          () => dio.post(
        path,
        queryParameters: queryParameters,
        data: isFormData ? FormData.fromMap(data) : data,
      ),
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  @override
  Future putData(
      String path, {
        Map<String, dynamic>? queryParameters,
        dynamic data,
        bool isFormData = false,
        Function(dynamic)? onSuccess,
        Function(DioException)? onError,
      }) {
    return _handleRequest(
          () => dio.put(
        path,
        queryParameters: queryParameters,
        data: isFormData ? FormData.fromMap(data) : data,
      ),
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
