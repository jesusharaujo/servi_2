import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servi_2/pages/welcomePage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChangeUserNamePage extends StatefulWidget {
  final String uid, name, foto, username, email;
  ChangeUserNamePage({Key key,this.uid, this.name ,this.foto, this.username, this.email}) : super(key: key);

  @override
  _ChangeUserNamePageState createState() => _ChangeUserNamePageState();
}

class _ChangeUserNamePageState extends State<ChangeUserNamePage> {
  
  String newUserName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top:30.0),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0),
          children: <Widget>[
            Text(
              'Cambiar Nombre de Usuario',
              textAlign: TextAlign.center, 
              style: TextStyle(
              fontSize: 30.0, 
              fontWeight: FontWeight.bold)
            ),
            Divider(color: Colors.blue,height: 40.0),
            _crearInputUserName(),
            
            SizedBox(height: 30.0),
            RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              elevation: 5.0,
              splashColor: Colors.deepPurple,
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              // padding: EdgeInsets.only(left: 100.0, right: 100.0,top: 15.0,bottom: 15.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Siguiente', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                ],
              ),
              onPressed: () {
                updateUserName();

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                        title: Text('username actualizado con éxito.'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.check_circle, color: Colors.green, size: 60.0,)
                          ],
                        ),
                        actions: <Widget>[
                          FlatButton(
                              child: Text('Continuar'),
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return WelcomePage(email: widget.email, uid: widget.uid, foto: widget.foto, name: widget.name, newUserName: newUserName);
                                    }
                                  )
                                );
                              }
                            )
                        ],
                    );
                  }
                );
              },
            ),
          ]
        ),
      )
    );
  }

  void updateUserName() {
    DocumentReference ref = Firestore.instance.collection('usuarios').document(widget.uid);
      ref.setData({
        "username": newUserName
      }, merge: true
    );

  }

  Widget _crearInputUserName() {
    return TextField(
     keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        hintText: 'Username',
        labelText: 'Ingresa un nombre de usuario',
        suffixIcon: Icon(FontAwesomeIcons.userCheck),
      ),
      onChanged: (valor){
        newUserName = valor;
      },
    );
  }

}