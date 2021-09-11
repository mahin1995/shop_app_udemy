import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app_udemy/models/http_exception.dart';
// import 'package:flutter_complete_guide/auth/auth_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
   String? _token;
  var _expiryDate;
   String? _userId;
   Timer? _authTimer;

 bool get isAuthenticated {
    return token != null;
  }

  String? get token {
    // if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null) {
    if (_expiryDate != null && _token != null) {
      return _token;
    } else {
      return null;
    }
  }

 

  String? get userId {
    return _userId;
  }

  // String? get token {
  //   if (_expiryDate != null) {
  //     print('Getting token $_token');
  //     return _token;
  //   }
  //   return null;
  // }

  Future<void> _authneticate(String email, String password, String urlSeagment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSeagment?key=AIzaSyCSd6ffxtMI7uqU8yrIzwN80H5GQlVjZUA');
    try {
      final response =
          await http.post(url, body: json.encode({'email': email, 'password': password, 'returnSecureToken': true}));
      // print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      // _expiryDate = responseData['expiresIn'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn'])
        )
      );
      _autoLogout();
      print(_expiryDate);
      print(_userId);
      print(_token);
      notifyListeners();
      final prefs =await SharedPreferences.getInstance();
      final userData=json.encode({'token':_token,'userId':_userId,'expiryDate':_expiryDate.toiso8601string()});
      prefs.setString("userData", userData);

      // _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authneticate(email, password, 'signUp');
  }

  Future<void> lgoin(String email, String password) async {
    return _authneticate(email, password, 'signInWithPassword');
  }
Future<bool?>tryAutoLogin()async{
      final prefs =await SharedPreferences.getInstance();
      if(!prefs.containsKey("userData")){
return false;
      }
      final extractedUserData=json.decode(prefs.getString("userData").toString()) as Map<String,Object>;
      print(extractedUserData);
      final expiryDate=DateTime.parse(extractedUserData['expiryDate'].toString());
      if(expiryDate.isBefore(DateTime.now())){
        return false;
      }
      _token=extractedUserData['token'].toString();
      _userId=extractedUserData['userId'].toString();
      _expiryDate=expiryDate;
      notifyListeners();
      _autoLogout();
      return true;

}

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }

}
}