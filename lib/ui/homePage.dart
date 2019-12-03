import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:servi_2/pages/logingPage.dart';


class HomePage extends StatefulWidget {
  final String name, email, idfb, foto;
  final FacebookLogin login;
  HomePage({Key key, this.name, this.email, this.idfb, this.foto, this.login}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginPage();
                    }
                  )
                );
                // Navigator.of(context).pop(true);
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
          'Servicios Recientes',
          style: TextStyle(
            color:Colors.black,
          )
        ),
      ),
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: _getPosts(),
      ),
    );
  }

// FUNCIÓN QUE REGRESA TODOS LOS POSTS
Widget _getPosts(){
  return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('posts').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return new Center(child: CircularProgressIndicator());
              default:
                return new ListView(
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