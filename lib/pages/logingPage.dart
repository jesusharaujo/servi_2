import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servi_2/pages/welcomePage.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
bool newUser = true;
//VARIABLES QUE CONTENDRÁN LA INFORMACIÓN OBTENIDA DEL USUARIO
String username, auxusername, name, email, idfb, foto;  
final login = FacebookLogin();
Map userProfile;

void initiateFacebookLogin() async {
  final result = await login.logInWithReadPermissions(['email']);
  newUser = true;

  switch (result.status) {
    case FacebookLoginStatus.error:
      print('Surgió un error');
      break;
    
    case FacebookLoginStatus.cancelledByUser:
      print('Cancelado por el usuario');
      break;
    
    case FacebookLoginStatus.loggedIn:
      FacebookAccessToken myToken = result.accessToken;

      /// we use FacebookAuthProvider class to get a credential from accessToken
      /// this will return an AuthCredential object that we will use to auth in firebase
      AuthCredential credential= FacebookAuthProvider.getCredential(accessToken: myToken.token);

      // this line do auth in firebase with your facebook credential.
      FirebaseUser firebaseUser = (
        await FirebaseAuth.instance.signInWithCredential(credential)
      ).user;

      getUserInfo(result); //FUNCIÓN QUE OBTIENE LOS DATOS PUBLICOS DEL USUARIO DE FCBK (EMAIL, FOTO DE PERFIL, NOMBRE)
      // Future.delayed(const Duration(seconds: 5), () {
      //   ifNewUser(idfb);
      // });
      ifNewUser(idfb); // FUNCIÓN QUE CHECA EN LA BASE DE DATOS SI EL USUARIO YA ESTÁ REGISTRADO O ES NUEVO.
      break;
      
    }
}

void getUserInfo(FacebookLoginResult result) async{
  final token = result.accessToken.token;
  final graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=picture,name,first_name,last_name,email&access_token=$token');
  final profile = JSON.jsonDecode(graphResponse.body);
  userProfile = profile;

  name =  userProfile['name'];
  email = userProfile['email'];
  idfb = userProfile['id'];
  foto = userProfile['picture']['data']['url'];
}

ifNewUser(String idfb) async {
  
  print(idfb);
  print("Al iniciar = $newUser");
  // if(foto == null){
  //   initiateFacebookLogin();
  // }
  print("idfb Entrando a la función ifNewUser = $idfb");
  print("newUser Entrando a la función ifNewUser = $newUser");


  //QUERY PARA SABER SI EXISTE EL USUARIO QUE ESTÁ INGRESANDO, EN CASO CONTRARIO PROCEDER A SU REGISTRO COMO NUEVO USUARIO.
  await Firestore.instance.collection('usuarios').getDocuments().then((QuerySnapshot snapshot){
    snapshot.documents.forEach((f){
      print("Entré al For Each");
      print(idfb);
      print(f.data['idfb']);
      if(f.data['idfb'] ==  idfb){
        print("Encontré que el usuario ya existe");
        newUser = false;
      }
    });
  });

  print("Antes de entrar al if de ifnewUser = $newUser"); 

  if(newUser == true){ //SI ES VERDADERO, INICIA PÁGINA DE BIENVENIDA Y POSTERIORMENTE A INGRESAR SUS DATOS.
    final route = MaterialPageRoute(
              builder: (BuildContext context){
                return WelcomePage(name: name, email: email, idfb: idfb, foto: foto, login: login);
              }); 
              print('Ya entré a WelcomePage');
    Navigator.push(context, route);
  }else{ //CASO CONTRARIO, QUE INGRESE A LA PÁGINA PRINCIPAL
    final route = MaterialPageRoute(
                  builder: (BuildContext context){
                    return MyHomePage(name: name, email: email, idfb: idfb, foto: foto, login: login);
                  }); 
                  print('Ya entré a HomePage');
    Navigator.push(context, route);
  }
  
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login Page'),
      // ),
      body: Column(
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