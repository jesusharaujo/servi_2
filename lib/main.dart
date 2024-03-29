import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:servi_2/pages/logingPage.dart';
import 'package:servi_2/ui/homePage.dart';
import 'package:servi_2/ui/miperfilPage.dart';
import 'package:servi_2/ui/buscadorPage.dart';

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
  final String name, email, uid, foto, username;
  final FacebookLogin login;
  MyHomePage({Key key, this.name, this.email, this.uid, this.foto, this.login, this.username}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    List<Widget> pages = [
    HomePage(name: widget.name, email: widget.email, foto: widget.foto, uid: widget.uid, username: widget.username),
    BuscadorPage(name: widget.name, email: widget.email, foto: widget.foto, uid: widget.uid, username: widget.username),
    MiPerfilPage(name: widget.name, email: widget.email, foto: widget.foto, uid: widget.uid, username: widget.username)
    ];

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
              icon: Icon(Icons.person),
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

