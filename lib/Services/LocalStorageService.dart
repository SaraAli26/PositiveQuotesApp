import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {

  var storage = new FlutterSecureStorage();

  Future<bool> setUserId(String userId) async {
    storage.write(key: "userId", value: userId);
    return true;
  }

  Future<String> get getUserId async {
    var id = await storage.read(key: "UserId");
    if (id == null) {
      return "NoUserLoggedIn";
    }
      return id;
  }

}