import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {

  var storage = new FlutterSecureStorage();

  Future<bool> setUser(String userId, String tokenId, DateTime expiryDate) async {
    storage.write(key: "userId", value: userId);
    storage.write(key: "tokenId", value: tokenId);
    storage.write(key: "expiryDate", value: expiryDate.toIso8601String());
    return true;
  }

  Future<bool> tryAutoLogin() async {
    var id = await storage.read(key: "UserId");
    var token = await storage.read(key: "tokenId");
    var expiryDate = await storage.read(key: "expiryDate");

    if(id!.isEmpty){
      return false;
    }

    final extractedId = id;
    final extractedToken = token;
    final extractedExpiryDate = DateTime.parse(expiryDate.toString());
    if(extractedExpiryDate.isBefore(DateTime.now())){
      return false;
    }

    return true;
  }
}