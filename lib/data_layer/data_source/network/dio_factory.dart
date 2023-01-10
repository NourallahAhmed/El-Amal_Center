import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "langauge";
const int apiTime = 60000;

class DioFactory{


  DioFactory();

  Future<Dio> getDio() async{
     Dio dio = Dio();

    /// headers
    Map<String , String> headers = {
      CONTENT_TYPE : APPLICATION_JSON,
      ACCEPT : APPLICATION_JSON,
    };

    /// options
    dio.options = BaseOptions(

      baseUrl: "",
      headers: headers,
      receiveTimeout: apiTime,
      sendTimeout: apiTime
    );


    ///dio_logger
     if(!kReleaseMode){    // in debug mode only
       dio.interceptors.add(PrettyDioLogger(
         requestHeader : true ,
         requestBody  : true ,
         responseHeader  : true ,
       ));
     }

     return dio;
  }


}