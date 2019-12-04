import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';

class WelcomePage2 extends StatefulWidget {
  final String name, email, uid, foto, username;
  WelcomePage2({Key key, this.name, this.email, this.uid, this.foto, this.username}) : super(key: key);

  @override
  _WelcomePage2State createState() => _WelcomePage2State();
}

class _WelcomePage2State extends State<WelcomePage2> {
  
  String calle, colonia, ciudad, estado, telefono, numCasa, bio, fechaRegistro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top:30.0),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0),
          children: <Widget>[
            Text(
              'Sólo ingresa los siguientes datos',
              textAlign: TextAlign.center, 
              style: TextStyle(
              fontSize: 30.0, 
              fontWeight: FontWeight.bold)
            ),
            Divider(color: Colors.blue,height: 40.0),
            _crearInputCalle(),
            Divider(color: Colors.blue,height: 40.0),
            _crearInputNumCasa(),
            Divider(color: Colors.blue,height: 40.0),
            _crearInputColonia(),
            Divider(color: Colors.blue,height: 40.0),
            _crearInputCiudad(),
            Divider(color: Colors.blue,height: 40.0),
            _crearInputEstado(),
            Divider(color: Colors.blue,height: 40.0),
            _crearInputTelefono(),
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
                crearNuevoUsuario();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                        title: Text('Guardado correctamente.'),
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
                                      return MyHomePage(name: widget.name, email: widget.email, foto: widget.foto, uid: widget.uid, username: widget.username);
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

  // Widget datosGuardados(){
  //   return AlertDialog(
  //             elevation: 5.0,
  //             title: Text('Datos registrados con éxito...'),
  //             content: Text('Usted saldrá de la aplicación'),
  //             actions: <Widget>[
  //               FlatButton(
  //                 child: Text('Continuar'),
  //                 onPressed: (){
                    
  //                 }
  //               )
  //             ],
  //           );
  // }

  void crearNuevoUsuario() {
    List servicios = [];
    DocumentReference ref = Firestore.instance.collection('usuarios').document(widget.uid);
      ref.setData({
        "uid": widget.uid,
        "nombre": widget.name,
        "email": widget.email,
        "fecha_registro": DateTime.now(),
        "img_perfil": widget.foto,
        "num_publicaciones": 0,
        "seguidores": 0,
        "seguidos": 0,
        "stars": 0,
        "telefono": telefono,
        "total_servicios": 0,
        "username": widget.username,
        "servicios": servicios,
        "calle": calle,
        "num_casa": numCasa,
        "colonia": colonia,
        "ciudad": ciudad,
        "estado": estado,
      }, merge: true
    );

  }

  Widget _crearInputCalle() {
    return TextField(
     keyboardType: TextInputType.text,
     //textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        hintText: 'Nombre de calle',
        labelText: '1. Calle',
        suffixIcon: Icon(Icons.streetview),
      ),
      onChanged: (valor){
        calle = valor;
      },
    );
  }
  Widget _crearInputNumCasa() {
    return TextField(
     keyboardType: TextInputType.number,
     //textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        hintText: 'Número de casa',
        labelText: '2. Número de casa',
        suffixIcon: Icon(Icons.format_list_numbered),
      ),
      onChanged: (valor){
        numCasa = valor;
      },
    );
  }
  Widget _crearInputColonia() {
    return TextField(
     keyboardType: TextInputType.text,
     //textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        hintText: 'Colonia',
        labelText: '3. Colonia',
        suffixIcon: Icon(Icons.playlist_add_check),
      ),
      onChanged: (valor){
        colonia = valor;
      },
    );
  }
  Widget _crearInputTelefono() {
    return TextField(
     keyboardType: TextInputType.phone,
     //textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        hintText: 'Teléfono',
        labelText: '6. Teléfono',
        suffixIcon: Icon(Icons.playlist_add_check),
      ),
      onChanged: (valor){
        telefono = valor;
      },
    );
  }
  Widget _crearInputCiudad() {
    return TextField(
     keyboardType: TextInputType.text,
     //textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        hintText: 'Ciudad',
        labelText: '4. Ciudad',
        suffixIcon: Icon(Icons.playlist_add_check),
      ),
      onChanged: (valor){
        ciudad = valor;
      },
    );
  }
  Widget _crearInputEstado() {
    return TextField(
     keyboardType: TextInputType.text,
     //textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        hintText: 'Estado',
        labelText: '5. Estado',
        suffixIcon: Icon(Icons.playlist_add_check),
      ),
      onChanged: (valor){
        estado = valor;
      },
    );
  }
}