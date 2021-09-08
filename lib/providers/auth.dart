import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app_udemy/models/http_exception.dart';


class Auth with ChangeNotifier{
  late String _token;
  late DateTime _expiryDate;
  late String _userId;



Future <void> _authneticate(String email ,String password,String urlSeagment) async{
  final url =Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:$urlSeagment?key=AIzaSyCSd6ffxtMI7uqU8yrIzwN80H5GQlVjZUA');
  try{
  final response= await http.post(url,body: json.encode({
      'email':email,'password':password,'returnSecureToken':true
    }));
    print(json.decode(response.body));
    final responseData=json.decode(response.body);
    if(responseData['error'] != null){
      throw HttpException(responseData['error']['message']);
    }
  }
  catch(error){
throw error;
  }
  
  }



 Future<void> signup(String email,String password) async{
 return _authneticate(email,password,'signUp');
}
  Future<void> lgoin(String email,String password) async{
return  _authneticate(email,password,'signInWithPassword');
  
}
}

 