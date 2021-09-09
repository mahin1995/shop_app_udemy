import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app_udemy/models/http_exception.dart';
// import 'package:flutter_complete_guide/auth/auth_utils.dart';

class Auth with ChangeNotifier {
  late String _token;
  var _expiryDate;
  late String _userId;

  String? get token {
    // if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null) {
    if (_expiryDate != null && _token != null) {
      return _token;
    } else {
      return null;
    }
  }

  bool get isAuthenticated {
    return token != null;
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
      _expiryDate = responseData['expiresIn'];
      print(_expiryDate);
      print(_userId);
      print(_token);
      notifyListeners();
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
}
