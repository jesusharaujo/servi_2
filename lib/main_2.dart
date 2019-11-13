import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servi_2/src/services/busquedaServicio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Servicios'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool servicioFlag = false;
  var servicios;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BusquedaServicio().getServicio('agua')
                          .then((QuerySnapshot docs) {
                            if(docs.documents.isNotEmpty) {
                              servicioFlag=true;
                              servicios = docs.documents[0].data;
                            }
                          });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Servicios"),
      ),
      body: ListView(
        children: <Widget>[
          servicioFlag ? 
          Card(
            child: ListTile(
              leading: FlutterLogo(size: 72.0),
              title: Text(servicios['nombre']),
              subtitle: Text(servicios['diccionario']),
              trailing: Icon(Icons.more_vert),
              isThreeLine: true,
            ),
          ) : Center(child: CircularProgressIndicator())
        ],
      )
    );
  }



}