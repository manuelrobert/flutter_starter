import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_starter/utils/httpResponse.dart';
import 'package:http/http.dart' as http;

enum Request { GET, POST, PATCH, PUT, DELETE, DELETEWithBody, PUTFile }
enum ContentHeaders { JSON, URLEncoded, FormData }

class HttpInterceptor {
  HttpInterceptor() {
    print('${this.runtimeType} Constructed');
  }
  String _baseUri = 'http://192.168.21.51:8000';
  http.Client client = http.Client();

  String get baseUrl => _baseUri;

  Future<HttpResponse?> restCall(
    String endPoint, {
    Request? request,
    Map? body,
    bool useBaseUri = true,
    Map<String, String>? queryParams,
    ContentHeaders? header,
    bool auth = true,
  }) async {
    http.Response response;
    Uri url = Uri.parse(useBaseUri ? '$_baseUri$endPoint' : endPoint);
    Map<String, String> headers = {};

    switch (header) {
      case ContentHeaders.JSON:
        headers.addAll({HttpHeaders.contentTypeHeader: 'application/json'});
        break;
      case ContentHeaders.URLEncoded:
        headers.addAll({HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'});
        break;
      case ContentHeaders.FormData:
        headers.addAll({HttpHeaders.contentTypeHeader: 'multipart/form-data'});
        break;
      default:
        print('no headers');
        break;
    }

    try {
      print('$request  http:/$url request_body=> $body queryParams=> $queryParams');
      switch (request) {
        case Request.GET:
          if (queryParams != null) url.queryParameters.addAll(queryParams);
          response = await client.get(url, headers: headers);
          break;
        case Request.POST:
          response = await client.post(url, body: header == ContentHeaders.JSON ? json.encode(body) : body, headers: headers);
          break;
        case Request.PATCH:
          response = await client.patch(url, body: header == ContentHeaders.JSON ? json.encode(body) : body, headers: headers);
          break;
        case Request.PUT:
          response = await client.put(url, body: header == ContentHeaders.JSON ? json.encode(body) : body, headers: headers);
          break;
        case Request.DELETE:
          response = await client.delete(url, body: body, headers: headers);
          break;
        default:
          throw Exception('Request Type is null');
      }

      print('http:/$endPoint response=> ${response.statusCode} ${response.body}');
      HttpResponse httpResponse = HttpResponse(status: response.statusCode, body: response.body.isNotEmpty ? json.decode(response.body) : null, headers: response.headers);

      switch (response.statusCode) {
        case 200:
        case 201:
        case 204:
          print('Response Status : ${response.statusCode}');
          return httpResponse;
        case 400:
          print('Error ${response.statusCode}');
          // Utils.showToast(msg: 'Error ${response.statusCode}');
          return null;
        case 401:
          print('Unauthorised ${response.statusCode}');
          // Utils.showToast(msg: 'Unauthorised ${response.statusCode}');
          return null;
        case 404:
          print('Not Found ${response.statusCode}');
          // Utils.showToast(msg: 'Not Found');
          return httpResponse;
        case 500:
          print('Internal Server Error, please retry later ${response.statusCode}');
          // Utils.showToast(msg: 'Internal Server Error, please retry later');
          return null;
        default:
          print('Something Went Wrong, please retry later ${response.statusCode}');
          // Utils.showToast(msg: 'Something Went Wrong, please retry later');
          return null;
      }
    } on SocketException {
      debugPrint("No Internet Connectivity");
      // Utils.showToast(msg: 'No Internet Connectivity');
      return null;
    } catch (err, stk) {
      debugPrint('exception from interceptor ${err.toString()} $stk');
      // Utils.showToast(msg: "Something Went Wrong, Retry Later");
      return null;
    }
  }
}
