import 'package:code_mid/common/const/data.dart';

class DataUtils {
  static pathToUrl(String value) {
    return 'http://$ip$value';
  }

  static listPathToUrls(List path) {
    return path.map((e) => pathToUrl(e)).toList();
  }
}
