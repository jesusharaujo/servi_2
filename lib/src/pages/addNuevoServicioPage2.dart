import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servi_2/src/pages/addNuevoServicioPage.dart';

class AddNuevoServicioPage2 extends StatefulWidget {
  final String servicioName;
  final String userName;

  AddNuevoServicioPage2({Key key,this.servicioName ,this.userName}) : super(key: key);

  @override
  _AddNuevoServicioPage2State createState() => _AddNuevoServicioPage2State();
}

class _AddNuevoServicioPage2State extends State<AddNuevoServicioPage2> {
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
          _getServicioSeleccionado(),
        ],
      )
    );
  } 

  Widget _getServiciosPerfil() {
    return Container(
      padding: EdgeInsets.only(top:20.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('usuarios').where('username', isEqualTo: widget.userName).snapshots(),
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
                  _servicios = "Aún no prestas ningún servicio...";
                }else{
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
    stream: Firestore.instance.collection('servicios').where('nombre', isEqualTo: widget.servicioName).snapshots(),
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
                        onPressed: () {
                          Firestore.instance.collection('usuarios').where('username', isEqualTo: widget.userName).getDocuments();
                          Firestore.instance.collection('usuarios').document()
                          .setData({ 'servicios': widget.servicioName});
                        },
                        textColor: Colors.white,
                        color: Colors.green,
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: const Text('Confirmar',style: TextStyle(fontSize: 20)),
                        ),
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

}