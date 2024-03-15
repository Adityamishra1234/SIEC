import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'apiException.dart';

class ApiService{
  final Dio dio;
  ApiService(this.dio);

  static const host = "https://jsonplaceholder.typicode.com/";
  static const _baseUrl = "${host}";


  dynamic getRequest(String subUrl,
      {Map<String, dynamic> data = const {},
        /* bool requireToken = false,*/ bool cacheRequest = true,
        bool forceRefresh = false}) async {
    try {
      String url = "$_baseUrl$subUrl";

      debugPrint('---GET1 url $url');
      debugPrint('---Params $data');

      Options option = Options(
        contentType: Headers.formUrlEncodedContentType,
        // headers:/* requireToken ? */{
        //   'token': true,
        // }/* : {}*/,
      );
      Response res = await dio.get(
        url,
        queryParameters: data,
        options: option,
        // options: cacheRequest ? buildCacheOptions(
        //   const Duration(minutes: 30),
        //   maxStale: const Duration(days: 2),
        //   forceRefresh: forceRefresh,
        //   options: option,
        // ) : option,
      );
      debugPrint('---RESULT: ${res.data}');
      log("---RESULT1: ${res.data}");
      if (res.statusCode == 200) {
        var rData = res.data;
        debugPrint('---RESULT END');
        return rData;
      } else {
        throw ApiException.fromString("Error Occurred. ${res.statusCode}");
      }
    } on SocketException {
      throw ApiException.fromString("No Internet Connection!");
    } on DioException catch (dioError) {
      throw ApiException.fromDioError(dioError);
    }
  }



}