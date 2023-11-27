import 'dart:convert';

import 'package:code_mid/common/const/data.dart';

class DataUtils {
  static pathToUrl(String value) {
    return 'http://$ip$value';
  }

  static listPathToUrls(List path) {
    return path.map((e) => pathToUrl(e)).toList();
  }

  static String plainToBase64(String plain) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(plain);

    return encoded;
  }
}
