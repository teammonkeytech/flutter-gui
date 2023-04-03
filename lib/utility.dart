import 'dart:convert' show json;
import 'dart:convert' show base64, utf8;
import 'package:basic_utils/basic_utils.dart'
    show CryptoUtils, RSAPublicKey, RSAPrivateKey;
import 'package:http/http.dart' show post, Response;

Future<Response> postJsonRequest(
    String url, Map<String, dynamic> jsonMap) async {
  return await post(Uri.parse(url),
      body: json.encode(jsonMap),
      headers: {"content-type": "application/json"});
}

String encrypt(String plaintext, RSAPublicKey publicKey) {
  return base64
      .encode(utf8.encode(CryptoUtils.rsaEncrypt(plaintext, publicKey)));
}

String decrypt(String ciphertext, RSAPrivateKey privateKey) {
  return CryptoUtils.rsaDecrypt(
      utf8.decode(base64.decode(ciphertext)), privateKey);
}
