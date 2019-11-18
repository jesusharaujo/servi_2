import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class AddNuevoServicioPage extends StatefulWidget {
  final String username;

  AddNuevoServicioPage({Key key, this.username}) : super(key: key);

  @override
  _AddNuevoServicioPageState createState() => _AddNuevoServicioPageState();
}

class _AddNuevoServicioPageState extends State<AddNuevoServicioPage> {
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
    );
  }
}