import 'dart:convert' show json;

import 'package:basic_utils/basic_utils.dart' show RSAPrivateKey, RSAPublicKey;

String encodePrivateKey(RSAPrivateKey key) {
  return json.encode({
    "type": "private",
    "p": key.p.toString(),
    "q": key.q.toString(),
    "modulus": key.modulus.toString(),
    "exponent": key.privateExponent.toString(),
  });
}

String encodePublicKey(RSAPublicKey key) {
  return json.encode({
    "type": "public",
    "modulus": key.modulus.toString(),
    "exponent": key.exponent.toString(),
  });
}

RSAPrivateKey decodePrivateKey(String keyRepr) {
  dynamic map = json.decode(keyRepr);
  if (map is! Map<String, String> ||
      map["type"] != "public" ||
      map["modulus"] == null ||
      map["exponent"] == null ||
      map["p"] == null ||
      map["q"] == null) {
    throw UnsupportedError("Cannot parse JSON as private key");
  }
  return RSAPrivateKey(
      BigInt.parse(map["modulus"]!),
      BigInt.parse(map["exponent"]!),
      BigInt.parse(map["p"]!),
      BigInt.parse(map["q"]!));
}

RSAPublicKey decodePublicKey(String keyRepr) {
  dynamic map = json.decode(keyRepr);
  if (map is! Map<String, String> ||
      map["type"] != "public" ||
      map["modulus"] == null ||
      map["exponent"] == null) {
    throw UnsupportedError("Cannot parse JSON as public key");
  }
  return RSAPublicKey(
      BigInt.parse(map["modulus"]!), BigInt.parse(map["exponent"]!));
}
