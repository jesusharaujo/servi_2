import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:servi_2/pages/changeUserNamePage.dart';
import 'package:servi_2/pages/welcomePage2.dart';

class WelcomePage extends StatefulWidget {
  final String name, email, uid, foto, newUserName;
  final FacebookLogin login;
  WelcomePage({Key key, this.name, this.email, this.uid, this.foto, this.login, this.newUserName}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
  
  //FUNCIÓN QUE RETORNA EL USERNAME POR DEFECTO EN BASE AL CORREO ELECTRONICO DEL USUARIO INGRESADO.
  String username = "";
  for (var x = 0; x < widget.email.length; x++) {
    if(widget.email[x]=="@"){
      x = widget.email.length + 1 ;
    }else{
      username = username + widget.email[x];
    }
  }

  if(widget.newUserName != null){
    username = widget.newUserName;
  }
  
    return Scaffold(
      body: Center(
       child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('TE DAMOS LA BIENVENIDA A SERVIGRAM,',textAlign: TextAlign.center ,style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(backgroundImage: NetworkImage(widget.foto)),
              SizedBox(width: 10.0,),
              Text(username, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 20.0,),
            ],
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Busca personas que presten el servicio que tú necesites. También puedes prestar tus servicios.', 
                    style: TextStyle(color: Colors.grey, fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                ],
            ),
          ),
          SizedBox(height: 30.0),
          RaisedButton(
            color: Colors.blue,
            textColor: Colors.white,
            elevation: 5.0,
            splashColor: Colors.deepPurple,
            padding: EdgeInsets.only(left: 100.0, right: 100.0,top: 15.0,bottom: 15.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Siguiente', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
              ],
            ),
            onPressed: () {
              final route = MaterialPageRoute(
                  builder: (BuildContext context){
                    return WelcomePage2(name: widget.name, email: widget.email, uid: widget.uid, foto: widget.foto, username: username);
                  }); 
              Navigator.push(context, route);
            },
          ),
          SizedBox(height: 20.0),
          FlatButton(
            textColor: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Cambiar nombre de usuario", style: TextStyle(fontSize: 18.0),)
              ],
            ),
            onPressed: (){
              final route = MaterialPageRoute(
                  builder: (BuildContext context){
                    return ChangeUserNamePage(name: widget.name, email: widget.email, uid: widget.uid, foto: widget.foto, username: username);
                  }); 
              Navigator.push(context, route);
            },
          ),

          // SizedBox(height: 30.0),
          // RaisedButton(
          //   elevation: 5.0,
          //   splashColor: Colors.black,
          //   padding: EdgeInsets.all(10.0),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: <Widget>[
          //       Icon(FontAwesomeIcons.signOutAlt),
          //       SizedBox(width: 10.0),
          //       Text('Cerrar sesión', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
          //     ],
          //   ),
          //   color: Colors.white,
          //   textColor: Colors.red,
          //   onPressed: () {
          //     cerrarSesion();
          //     Navigator.of(context).pop();
          //   },
          // )
          
        ],
      )
      )
    );
  }

void cerrarSesion(){
  widget.login.logOut();
}

}