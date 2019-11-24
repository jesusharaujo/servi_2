import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

final login = FacebookLogin();
bool _isLoggedIn = false;
Map userProfile;

void initiateFacebookLogin() async {
  final result = await login.logInWithReadPermissions(['email']);

  switch (result.status) {
    case FacebookLoginStatus.error:
      print('Surgió un error');
      break;
    
    case FacebookLoginStatus.cancelledByUser:
      print('Cancelado por el usuario');
      break;
    
    case FacebookLoginStatus.loggedIn:
      onLoginStatusChange();
      getUserInfo(result);
      break;
    }
  
}

void onLoginStatusChange(){
  setState(() {
    _isLoggedIn = true;
  });
}

void cerrarSesion(){
  login.logOut();
  setState(() {
    _isLoggedIn = false;
  });
}

void getUserInfo(FacebookLoginResult result) async{
  final token = result.accessToken.token;
  final graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=$token');
  final profile = JSON.jsonDecode(graphResponse.body);
  userProfile = profile;
  print(profile);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: _isLoggedIn 
      ? Column(children: <Widget>[Text(userProfile['email']), FlatButton(child: Text('cerrar sesión'), onPressed: ()=>cerrarSesion(),)])
      : Container(
        child: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text('Ingresar con Facebook'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  elevation: 7.0,
                  onPressed: () {
                    initiateFacebookLogin();
                  },
                )
              ],
            ),
        ),
      )
    );
  }

}