import 'dart:convert';

String stringToBase64Encode(String string) {
  return base64Encode(utf8.encode(string));
}

String stringToBase64Decode(String string) {
  return utf8.decode(base64Decode(string));
}
