class HttpResponse {
  int? status;
  Map<String, String>? headers;
  var body;

  HttpResponse({this.status, this.headers, this.body});
}
