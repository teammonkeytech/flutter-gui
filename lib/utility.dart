import 'dart:convert' show json;

import 'package:http/http.dart' show post, Response;

Future<Response> postJsonRequest(
    String url, Map<String, dynamic> jsonMap) async {
  return await post(Uri.parse(url),
      body: json.encode(jsonMap),
      headers: {"content-type": "application/json"});
}
