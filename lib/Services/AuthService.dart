import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qoutesapp/Models/QuoteModel.dart';
import 'package:qoutesapp/Models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:qoutesapp/Models/http_exception.dart';
import 'package:qoutesapp/Services/LocalStorageService.dart';

class AuthService with ChangeNotifier {

  DateTime? _expiryDate;
  String? _userId = "" ;
  String? _token = "";
  Timer? _authTimer;
  List<QuoteModel> _Quotess = [];

  bool get isAuth {
    return token != null;
  }


  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _userId != null) {
      return _userId;
    }
    return null;
  }

  List<QuoteModel> get myFavQuotes{
    return _Quotess;
  }


  Future<bool> setUser(String userId, String tokenId, DateTime expiryDate) async {
    final storage = await SharedPreferences.getInstance();

    storage.setString("userId", userId);
    storage.setString("tokenId", tokenId);
    storage.setString("expiryDate", expiryDate.toIso8601String());
    return true;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("userId");
    var token = prefs.getString("tokenId");
    var expiryDate = prefs.getString("expiryDate");
    if(!prefs.containsKey('userId')){
      return false;
    }

    final extractedId = id;
    final extractedToken = token;
    final extractedExpiryDate = DateTime.parse(expiryDate.toString());
    if(extractedExpiryDate.isBefore(DateTime.now())){
      return false;
    }

    _token = extractedToken;
    _userId = extractedId;
    _expiryDate = extractedExpiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment, String firstName, String lastName) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDQ2RJWKOZJ8F8YQBly4cfjcxzc6XBVUMw";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
        _token = responseData['idToken'];
        _userId = responseData['localId'];
        _expiryDate = DateTime.now().add(
          Duration(
            days: 7,
            ),
          );

        if(urlSegment == "signUp"){
          addAdditionalDataWhenSignUp(_userId, firstName, lastName);
        }

        _autoLogout();
      notifyListeners();
      setUser(_userId!, _token!, _expiryDate!);
    } catch (error) {
      throw error;
    }
  }

  Future<void> addAdditionalDataWhenSignUp(userId, firstName, lastName) async {

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users.doc(userId!).set({
      'firstname': firstName,
      'lastname': lastName,
    })
        .then((value) => print("Data Added Successfully")).catchError((error) => print("Failed to add data: $error"));
  }

  Future<void> signUp(String email, String password, String firstName, String lastName) async {
    return _authenticate(email, password, 'signUp', firstName, lastName);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword', "","");
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if(_authTimer != null){
      _authTimer!.cancel();
      _authTimer == null;
    }
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
    notifyListeners();
  }

  //Method to implement auto logout, by setting a timer then calling logout function
  // after the time expires
  void _autoLogout(){
    if(_authTimer != null){
      _authTimer!.cancel();
    }
    final timeToExpiry =  _expiryDate!.difference(DateTime.now()).inSeconds;
    //First part is setting the duration, next part is we need to tell dart what should happen when time expires
    //Call function that dosent receive any arguments and dosent return anything
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }


  Future<void> addFavoriteQuote(String author, String quote, String category, String date, String time) async{
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("userId");
      CollectionReference users = FirebaseFirestore.instance.collection('users');
        return users.doc(id!).collection('favQuote').add({
          'author': author,
          'quote': quote,
          'category': category,
          'date': date,
          'time': time,
        })
          .then((value) => print("Fav Quote Added Successfully" + value.id)).catchError((error) => print("Failed to add to Fav: $error"));

  }

  Future<void> deleteFavoriteQuote(String quote) async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("userId");
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users.doc(id!).collection('favQuote').where("quote", isEqualTo: quote).get().then((snapshot){
      snapshot.docs.first.reference.delete();
    });
  }

  Future<List<QuoteModel>> getUserFavQuotes() async {

    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("userId");

    FirebaseFirestore _instance = FirebaseFirestore.instance;
    DocumentReference userDocument = _instance.collection('users').doc(id);
    var userFavQuotes =  await userDocument.collection('favQuote').get();

    userFavQuotes.docs.forEach((quotesd) {
        QuoteModel cat = QuoteModel.fromJson(quotesd.data());
        _Quotess.add(cat);
      });
     return _Quotess;
  }

  Future<UserModel> getUserData() async {
    UserModel user = new UserModel(firstName: "", lastName: "");

    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("userId");

   FirebaseFirestore _instance = FirebaseFirestore.instance;
    CollectionReference quotes = _instance!.collection("users");

    DocumentSnapshot snapshot = await quotes.doc(id).get();
    if(snapshot.exists){
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
     // var quotesData =  data['DailyQuotes'] as Map<String, dynamic>;
      //print(quotesData);
      user = UserModel.fromJson(data);
      //print(QuoteOfToday.quote);
    }

    return user;
  }

}
