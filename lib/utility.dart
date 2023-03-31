import 'package:http/http.dart';
import 'dart:convert';

Future<Response> postJsonRequest(
    String url, Map<String, dynamic> jsonMap) async {
  return await post(Uri.parse(url),
      body: jsonEncode(jsonMap), headers: {"content-type": "application/json"});
}
