import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servi_2/main.dart';

class AddNuevoServicioPage2 extends StatefulWidget {
  final String docId, nombreServicio, name, email, uid, foto, username;
  List listaServicios;
  int cantidadServicio;

  AddNuevoServicioPage2({Key key,this.cantidadServicio, this.listaServicios, this.docId, this.nombreServicio, this.uid, this.username, this.foto, this.email, this.name}) : super(key: key);
  
  @override
  _AddNuevoServicioPage2State createState() => _AddNuevoServicioPage2State();
}

class _AddNuevoServicioPage2State extends State<AddNuevoServicioPage2> {
  
  @override
  Widget build(BuildContext context) {
    widget.cantidadServicio = widget.cantidadServicio + 1;
    widget.listaServicios = widget.listaServicios + [widget.nombreServicio]; // ESTA VARIABLE CONTIENE LOS ACTUALES SERVICIOS Y EL QUE SE VA A AGREGAR.
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
          _getServicioSeleccionado(),
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
                            Text('Confirma tu selección', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300)),
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

  Widget _getServicioSeleccionado(){
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('servicios').where('nombre', isEqualTo: widget.nombreServicio).snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError)
        return new Text('Error: ${snapshot.error}');
      switch (snapshot.connectionState) {
        case ConnectionState.waiting: return new CircularProgressIndicator();
        default:
          return new Column(
            children : snapshot.data.documents.map((DocumentSnapshot document) {
              
              return Column(
                children: <Widget>[
                  Card(
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
                                Icon(Icons.playlist_add_check, color: Colors.green, size: 30.0),
                                Text('Selecionado', style: TextStyle(fontSize: 20.0, color: Colors.green))
                              ],
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        textColor: Colors.red,
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancelar",style: TextStyle(fontSize: 20))
                      ),
                      SizedBox(width: 20.0),
                      RaisedButton(
                        textColor: Colors.white,
                        color: Colors.green,
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: const Text('Confirmar',style: TextStyle(fontSize: 20)),
                        ),
                        onPressed: () {
                          addNuevoServicio(widget.listaServicios, widget.docId, widget.cantidadServicio);
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                  title: Text('Servicio agregado correctamente.'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(Icons.check_circle, color: Colors.green, size: 60.0,)
                                    ],
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Aceptar'),
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
                    ],
                  ),
                ],
              );
            }).toList(),
          );
      }
    },
  );
}

  void addNuevoServicio(List listaServicios, String docId, int cantidadServicio) {

    Firestore.instance.collection('usuarios').document(widget.uid).
      updateData({
        "servicios": listaServicios
      });

    Firestore.instance.collection('servicios').document(docId).
      updateData({
        "cantidad": cantidadServicio
      });
  }

}