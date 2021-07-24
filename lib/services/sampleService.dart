import 'package:flutter_starter/utils/httpInterceptor.dart';
import 'package:flutter_starter/utils/httpResponse.dart';

HttpInterceptor interceptor = HttpInterceptor();

class SampleService {
  Future<HttpResponse?> get() async {
    return await interceptor
        .restCall(
          '/notes',
          request: Request.GET,
          header: ContentHeaders.JSON,
        )
        .then((HttpResponse? res) => res)
        .catchError((error, stack) async {
      print('exception from Service ${error.toString()}');
      // Utils.showToast(msg: 'Some Error Occurred, Please try again');
      return null;
    });
  }
}
