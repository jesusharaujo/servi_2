import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servi_2/src/services/getPerfil.dart';

class ListaContratistasPage extends StatefulWidget {
  //RECIBIR EL VALOR DE _NOMBRESERVICIO DE BUSCADORPAGE.
  final String value;
  ListaContratistasPage({Key key, this.value}) : super(key: key);

  @override
  _ListaContratistasPageState createState() => _ListaContratistasPageState();
}

class _ListaContratistasPageState extends State<ListaContratistasPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          widget.value,
          style: TextStyle(
            color:Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: _listaContratistas(),
    );
  }


Widget _listaContratistas() {
    return Container(
       child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('usuarios').where('servicios', arrayContains: widget.value.toLowerCase()).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return new CircularProgressIndicator();
              default:
                return new ListView(
                  children : snapshot.data.documents.map((DocumentSnapshot document) {
                    String _userName = document['username'];
                    return new ListTile(
                      onTap: (){
                        final route = MaterialPageRoute(
                          builder: (BuildContext context){
                            return GetPerfilPage(value: _userName);
                          } ,
                        );
                        Navigator.push(context, route);
                      },
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                      leading: Image.network(document['img_perfil']),
                      title: new Text(document['nombre'], style: TextStyle(fontSize: 20.0)),
                      subtitle: new Text(document['username']),
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

  