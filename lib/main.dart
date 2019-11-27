import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:servi_2/src/pages/logingPage.dart';
import 'package:servi_2/src/ui/homePage.dart';
import 'package:servi_2/src/ui/miperfilPage.dart';
import 'package:servi_2/src/ui/buscadorPage.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String name, email, idfb, foto;
  final FacebookLogin login;
  MyHomePage({Key key, this.name, this.email, this.idfb, this.foto, this.login}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> pages = [
    HomePage(),
    BuscadorPage(),
    MiPerfilPage()
  ];

  @override
  Widget build(BuildContext context) {
    print(widget.login);
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        body: TabBarView(
          children: pages,
        ),
        bottomNavigationBar: TabBar(
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.home)
            ),
            Tab(
              icon: Icon(Icons.search)
            ),
            Tab(
              icon: Icon(Icons.person)
            ),
          ],
          unselectedLabelColor: Colors.black,
          labelColor: Colors.blue,
          indicatorColor: Colors.transparent,
        ),
      ),
    );
  }
}

