import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servi_2/main.dart';
import 'package:servi_2/pages/getPerfilPage.dart';
import 'package:servi_2/pages/miperfilPage2.dart';
import 'package:servi_2/ui/buscadorPage.dart';

class ListaContratistasPage extends StatefulWidget {
  //RECIBIR EL VALOR DE _NOMBRESERVICIO DE BUSCADORPAGE.
  final String nombreServicio, name, email, uid, foto, username;
  ListaContratistasPage({Key key, this.nombreServicio, this.uid, this.username, this.foto, this.email, this.name}) : super(key: key);

  @override
  _ListaContratistasPageState createState() => _ListaContratistasPageState();
}

class _ListaContratistasPageState extends State<ListaContratistasPage> {
  Future<bool> _onBackPressed(){
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MyHomePage(name: widget.name, email: widget.email, foto: widget.foto, uid: widget.uid, username: widget.username);
        }
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    print(widget.uid);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          widget.nombreServicio,
          style: TextStyle(
            color:Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: 
            _listaContratistas(),
      )
      
    );
  }


Widget _listaContratistas() {
    return Container(
       child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('usuarios').where('servicios', arrayContains: widget.nombreServicio).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return new CircularProgressIndicator();
              default:
                return new ListView(
                  children : snapshot.data.documents.map((DocumentSnapshot document) {
                    String username = document['username'];
                    return new ListTile(
                      onTap: (){
                        final route = MaterialPageRoute(
                          builder: (BuildContext context){
                            return MiPerfilPage2(nombreServicio: widget.nombreServicio, name: widget.name, email: widget.email, foto: widget.foto, uid: widget.uid, username: username);
                          } ,
                        );
                        Navigator.push(context, route);
                      },
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(document['img_perfil']),
                      ),
                      title: new Text(document['nombre'] + ' ( Estrellas: ' + document['stars'].toString() + ' )', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                      subtitle: new Text(document['ciudad'] + ' | ' + document['total_servicios'].toString() +' Servicios'),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue,),
                    );
                  }).toList(),
                );
            }
          },
        )
    );
  }

}

  