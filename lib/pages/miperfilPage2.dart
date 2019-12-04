import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:servi_2/pages/listaContratistasPage.dart';

class MiPerfilPage2 extends StatefulWidget {
  final String nombreServicio, name, email, uid, foto, username;
  MiPerfilPage2({Key key,this.nombreServicio, this.uid, this.username, this.foto, this.email, this.name}) : super(key: key);
  @override
  _MiPerfilPage2State createState() => _MiPerfilPage2State();
}

class _MiPerfilPage2State extends State<MiPerfilPage2> {
  final login = FacebookLogin();
  List listaServicios;
  Future<bool> _onBackPressed(){
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ListaContratistasPage(nombreServicio: widget.nombreServicio, name: widget.name, email: widget.email, foto: widget.foto, uid: widget.uid, username: widget.username);
        }
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          widget.username,
          style: TextStyle(
            color:Colors.black,
          )
        ),
      ),
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: ListView(
          children: <Widget>[
            _getStats(),
            _getDatosPerfil(),
            _getPostsPerfil(),
          ],
        ),
      )
    );
  }

  //FUNCION QUE CARGA LOS DATOS DEL USUARIO
  Widget _getStats() {

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('usuarios').where('username',isEqualTo: widget.username).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Center(child: CircularProgressIndicator());
          default:
            return new Column(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return Row(
                    children: <Widget>[

                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 30.0, top: 20.0),
                            child: CircleAvatar(
                              radius: 40.0,
                              backgroundImage: NetworkImage(document['img_perfil']),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left:30.0,top:10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                // Text(document['nombre'], style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
                              //   Container(
                              //     padding: EdgeInsets.only(top:10.0) ,
                              //     child: Text(document['bio'], style: TextStyle(fontSize: 10.0))
                              //  ),
                            ],
                            ),
                          )
                        ],
                      ),

                      Container(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Column(
                          children: <Widget>[
                            Text(document['total_servicios'].toString(), style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
                            Text("Trabajos", style: TextStyle(fontSize: 15.0),),
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Column(
                          children: <Widget>[
                            Text(document['seguidores'].toString(), style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
                            Text("Seguidores", style: TextStyle(fontSize: 15.0),),
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Column(
                          children: <Widget>[
                            Text(document['seguidos'].toString(), style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
                            Text("Seguidos", style: TextStyle(fontSize: 15.0),),
                          ],
                        ),
                      ),

                    ],
                  );
              }).toList(),
            );
        }
      },
    );
  }

  //FUNCIÓN QUE CARGA LOS DATOS PERSONALES DEL USUARIO
  Widget _getDatosPerfil() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('usuarios').where('username',isEqualTo: widget.username).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return new Center(child: CircularProgressIndicator());
            default:
              return new Row(
                children: snapshot.data.documents.map((DocumentSnapshot document) {

                  // final _fecharegistro = document['fecha_registro'].toDate();

                  final _email = document['email'];
                  final _telefono = document['telefono'];

                    // CICLO PARA IMPRIMIR LOS SERVICIOS QUE TIENE DISPONIBLES EL USUARIO
                  String _servicios = ""; // VARIABLE QUE CONTIENE EL STRING CON LOS SERVICIOS QUE SE SACARÁN DEL ARRAY
      
                  if (document['servicios'].length == 0){
                    _servicios = "Aún no presta ningún servicio...";
                  }else if(document['servicios'].length == 1){
                    _servicios = document['servicios'][0] + '.'; 
                  }
                  else{
                    for (var i = 0; i < document['servicios'].length; i++) {
                      if((i+1) == document['servicios'].length){
                        _servicios = _servicios + " y " + document['servicios'][i] + ".";
                      }else if((i+2) == document['servicios'].length){
                        _servicios = _servicios + document['servicios'][i] ;
                      }else{
                        _servicios = _servicios + document['servicios'][i] + ", ";
                      }
                    }
                  }
                  return Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 25.0,bottom: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(document['nombre'].toString(), style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                            Text(document['ciudad'].toString()),
                            Container(constraints: BoxConstraints(maxWidth: 350.0),child:Text('Servicios: $_servicios', )),
                            Text("Email: $_email"),
                            Text("Teléfono: $_telefono"),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              );
          }
        },
      );
  }

  // FUNCIÓN QUE CARGA LOS POSTS DEL MURO DEL USUARIO
  Widget _getPostsPerfil(){
      return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('posts').where('username_tag',isEqualTo: widget.username).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Center(child: CircularProgressIndicator());
          default:
            return new Column(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                final _fecha = document['fecha'].toDate();
                    return Container(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Card(
                        elevation: 8.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(7.0),
                                  child: CircleAvatar(
                                    radius: 15.0,
                                    backgroundImage: NetworkImage(document['img_user']),
                                    )
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text(document['username_post'], style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(1.0),
                                      child: Text(document['ciudad_user'],style: TextStyle(fontSize: 10.0),),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            FadeInImage(
                              image: NetworkImage(document['img_post']),
                              placeholder: AssetImage('lib/src/assets/loader.gif'),
                              fadeInDuration: Duration(seconds: 1),
                              width: 400.0,
                              height: 350.0,
                              fit: BoxFit.cover,
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 10.0,bottom: 10.0,top: 10.0),
                                      child: Text(document['stars'].toString(),style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 15.0),),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10.0,bottom: 10.0,top: 10.0),
                                      child: Text("Estrellas",style: TextStyle(fontSize: 15.0),),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 100.0,bottom: 10.0,top: 10.0),
                                      child: Text("Fecha: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0))
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 3.0,bottom: 10.0,top: 10.0),
                                      child: Text("$_fecha")
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
              }).toList(),
            );
        }
      },
    );
  }
}
