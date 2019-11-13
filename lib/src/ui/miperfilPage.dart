import 'package:flutter/material.dart';

class MiPerfilPage extends StatefulWidget {
  MiPerfilPage({Key key}) : super(key: key);

  @override
  _MiPerfilPageState createState() => _MiPerfilPageState();
}

class _MiPerfilPageState extends State<MiPerfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Mi perfil',
          style: TextStyle(
            color:Colors.black,
          )
        ),
      ),
    );
  }
}