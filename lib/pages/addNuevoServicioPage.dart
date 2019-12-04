import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servi_2/pages/addNuevoServicioPage2.dart';

class AddNuevoServicioPage extends StatefulWidget {
  final String name, email, uid, foto, username;
  List listaServicios;

  AddNuevoServicioPage({Key key, this.listaServicios, this.uid, this.username, this.foto, this.email, this.name}) : super(key: key);

  @override
  _AddNuevoServicioPageState createState() => _AddNuevoServicioPageState();
}

class _AddNuevoServicioPageState extends State<AddNuevoServicioPage> {

  // List listaServicios; //VARIABLE QUE CONTENDRÁ LOS SERVICIOS ACTUALES DEL USUARIO, PARA PODER AGREGARLE UNO NUEVO.

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
          'Añadir nuevo servicio',
          style: TextStyle(
            color:Colors.black,
          )
        ),
      ),
      body: ListView(
        children: <Widget>[
          _getServiciosPerfil(),
          _getListaServicios(),
        ],
      )
    );
  } 

Widget _getServiciosPerfil() {
    return Container(
      padding: EdgeInsets.only(top:20.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('usuarios').where('uid', isEqualTo: widget.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return new Center(child: CircularProgressIndicator());
            default:
              return new Column(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  // listaServicios = document['servicios']; // AGREGA LOS SERVICIOS ACTUALES A LA VARIABLE LISTASERVICIOS
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
                return new Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40.0,
                        backgroundImage: NetworkImage(document['img_perfil']),
                      ),
                      SizedBox(height: 20.0),
                      Text(document['nombre'].toString(), style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                      Text(_servicios,textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300)),
                      SizedBox(height: 20.0,),
                      Divider(),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.chevron_right, color: Colors.green, size: 30.0),
                            Text('Selecciona un servicio', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300)),
                            Icon(Icons.chevron_left, color: Colors.green, size: 30.0),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }

Widget _getListaServicios(){
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('servicios').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError)
        return new Text('Error: ${snapshot.error}');
      switch (snapshot.connectionState) {
        case ConnectionState.waiting: return new CircularProgressIndicator();
        default:
          return new Column(
            children : snapshot.data.documents.map((DocumentSnapshot document) {
              
              String docId = document.documentID;
              int cantidadServicio = document['cantidad'];
              String nombreServicio = document['nombre'];
              //ESTE IF ES PARA VER SI EL SERVICIO YA LO TIENE ACTIVO EL USUARIO Y QUE APAREZCA CON EL STATUS "EN SERVICIO"
              if(widget.listaServicios.contains(document['nombre'])){
                return Card(
                  elevation: 5.0,
                  child: Container(
                    margin: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Image(image: NetworkImage(document['foto_servicio']),fit: BoxFit.cover),
                          title: Text(document['nombre'], style: TextStyle(fontSize: 20.0)),
                          subtitle: Text(document['descripcion']),
                          trailing: Column(
                            children: <Widget>[
                              Icon(FontAwesomeIcons.checkCircle, color: Colors.blue, size: 30.0),
                              Text('En servicio', style: TextStyle(fontSize: 20.0, color: Colors.blue))
                            ],
                          )
                        ),
                      ],
                    ),
                  ),
                ); 
              }
              else{
                return Card(
                  elevation: 5.0,
                  child: Container(
                    margin: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          onTap: (){
                            final route = MaterialPageRoute(
                              builder: (BuildContext context){
                                return AddNuevoServicioPage2(cantidadServicio: cantidadServicio, listaServicios: widget.listaServicios,docId: docId, nombreServicio: nombreServicio, name: widget.name, email: widget.email, foto: widget.foto, uid: widget.uid, username: widget.username);
                              } ,
                            );
                            Navigator.push(context, route);
                          },
                          leading: Image(image: NetworkImage(document['foto_servicio']),fit: BoxFit.cover),
                          title: Text(document['nombre'], style: TextStyle(fontSize: 20.0)),
                          subtitle: Text(document['descripcion']),
                          trailing: Column(
                            children: <Widget>[
                              Icon(Icons.add, color: Colors.green, size: 30.0),
                              Text('Agregar', style: TextStyle(fontSize: 20.0, color: Colors.green))
                            ],
                          )
                        ),
                      ],
                    ),
                  ),
                ); 
              }
            }).toList(),
          );
      }
    },
  );
}


}