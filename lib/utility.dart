import 'package:http/http.dart';

Future<Response> utilPostJsonRequest(String url, String jsonData) async {
  return await post(Uri.parse(url),
      body: jsonData, headers: {"content-type": "application/json"});
}

/*
Future<Response> postJsonRequest(
    String url, Map<String, dynamic> jsonMap) async {
  return await post(Uri.parse(url),
      body: jsonMap, headers: {"content-type": "application/json"});
}

Response waitForResponse(Future<Response> future) {
  Response x;
  future.then((t) => x = t);
  return x;
}
*/