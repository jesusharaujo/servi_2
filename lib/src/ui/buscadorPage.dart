import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:servi_2/src/pages/listaContratistasPage.dart';

class BuscadorPage extends StatefulWidget {
  @override
  _BuscadorPageState createState() => _BuscadorPageState();
}

class _BuscadorPageState extends State<BuscadorPage> {
  final login = FacebookLogin();

  Future<bool> _onBackPressed(){
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('¿Estás seguro?'),
          content: Text('Usted saldrá de la aplicación'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: (){
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('Sí'),
              onPressed: (){
                login.logOut();
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Buscar',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search, color: Colors.black), onPressed: (){
            showSearch(context: context, delegate: DataSearch());
          })
        ],
      ),
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: Container(
          padding: EdgeInsets.only(top:15.0),
          child: _listaServicios(),
        ),
      )
    );
  }
}

Widget _listaServicios() {
  
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('servicios').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError)
        return new Text('Error: ${snapshot.error}');
      switch (snapshot.connectionState) {
        case ConnectionState.waiting: return new CircularProgressIndicator();
        default:
          return new ListView(
            children : snapshot.data.documents.map((DocumentSnapshot document) {
              String _nombreServicio = document['nombre'];
              return new ListTile(
                onTap: (){
                  final route = MaterialPageRoute(
                    builder: (BuildContext context){
                      return ListaContratistasPage(value: _nombreServicio);
                    } ,
                  );
                  Navigator.push(context, route);
                },
                contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                leading: Image.network(document['foto_servicio']),
                title: new Text(document['nombre'], style: TextStyle(fontSize: 20.0)),
                subtitle: new Text(document['descripcion']),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue,),
              );
            }).toList(),
          );
        }
      },
  );
}

class DataSearch extends SearchDelegate<String>{

  @override
  List<Widget> buildActions(BuildContext context) {
    //acciones para la barra de busqueda
    return[
      IconButton(
        icon: Icon(Icons.clear), 
        onPressed: (){
          query = "";
        })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //deja el icono de lado izquierdo de la appbar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: (){
          close(context, null);
        });
  }
  
  @override
  Widget buildResults(BuildContext context) {
    //CREA LOS RESULTADOS QUE VAMOS A MOSTRAR
    return Center(
      child: Container(
      height: 100.0,
      width: 100.0,
      child: Card(
        color: Colors.red,
        child: Center(
          child: Text(query),
        ),
      ),
      )
    );
    
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //muestra cuando encuentra algo
    return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('servicios').where('claves', arrayContains: query.toLowerCase()).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return new Center(child: CircularProgressIndicator());
              default:
                return new ListView(
                  children : snapshot.data.documents.map((DocumentSnapshot document) {
                    String _nombreServicio = document['nombre'];
                    var _total = document['cantidad'];
                    var _nombre = document['nombre'];
                    return new ListTile(
                      onTap: (){
                        final route = MaterialPageRoute(
                          builder: (BuildContext context){
                            return ListaContratistasPage(value: _nombreServicio);
                          } ,
                        );
                        Navigator.push(context, route);
                      },
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                      leading: Image.network(document['foto_servicio']),
                      title: new Text('$_nombre', style: TextStyle(fontSize: 20.0)),
                      subtitle: new Text('$_total $_nombre en total'),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue,),
                    );
                  }).toList(),
                );
            }
          },
        );
  }



}