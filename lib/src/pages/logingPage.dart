import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

final login = FacebookLogin();
final FirebaseAuth _auth = FirebaseAuth.instance;
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
      FacebookAccessToken myToken = result.accessToken;

      ///assuming sucess in FacebookLoginStatus.loggedIn
      /// we use FacebookAuthProvider class to get a credential from accessToken
      /// this will return an AuthCredential object that we will use to auth in firebase
      AuthCredential credential= FacebookAuthProvider.getCredential(accessToken: myToken.token);

      // this line do auth in firebase with your facebook credential.
      FirebaseUser firebaseUser = (
        await FirebaseAuth.instance.signInWithCredential(credential)
      ).user;
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
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login Page'),
      // ),
      body: _isLoggedIn 
      ? Column(children: <Widget>[Text(userProfile['id']), FlatButton(child: Text('cerrar sesión'), onPressed: ()=>cerrarSesion(),)])
      : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('lib/src/assets/logo.png'),
          SizedBox(height: 60.0),
          RaisedButton(
            elevation: 5.0,
            splashColor: Colors.black,
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(FontAwesomeIcons.facebookSquare),
                SizedBox(width: 10.0),
                Text('Ingresar con Facebook', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
              ],
            ),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              initiateFacebookLogin();
            },
          )
        ],
      ),
    );
  }

}