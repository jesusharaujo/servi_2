import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      body: _getPosts()
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
                    return Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10.0),
                                child: CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage: NetworkImage(document['img_usuario']),
                                ),
                              ),
                              Text(document['usuario'], style: TextStyle(fontSize: 20.0)),
                            ],
                          ),
                          Image(
                            image: NetworkImage(document['img_post']),
                          )
                        ],
                      );
                  }).toList(),
                );
            }
          },
        );
}

}