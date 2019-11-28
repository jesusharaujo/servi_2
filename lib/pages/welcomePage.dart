import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class WelcomePage extends StatefulWidget {
  final String name, email, idfb, foto;
  final FacebookLogin login;
  WelcomePage({Key key, this.name, this.email, this.idfb, this.foto, this.login}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
       child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('TE DAMOS LA BIENVENIDA A SERVIGRAM,', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(backgroundImage: NetworkImage(widget.foto)),
              SizedBox(width: 10.0,),
              Text(widget.name, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 20.0,),
            ],
          ),
          SizedBox(height: 30.0),
          RaisedButton(
            elevation: 5.0,
            splashColor: Colors.black,
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(FontAwesomeIcons.signOutAlt),
                SizedBox(width: 10.0),
                Text('Cerrar sesión', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
              ],
            ),
            color: Colors.white,
            textColor: Colors.red,
            onPressed: () {
              cerrarSesion();
              Navigator.of(context).pop();
            },
          )
          
        ],
      )
      )
    );
  }

void cerrarSesion(){
  widget.login.logOut();
}

}