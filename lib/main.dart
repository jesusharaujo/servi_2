import 'package:flutter/material.dart';
import 'package:servi_2/src/ui/homePage.dart';
import 'package:servi_2/src/ui/miperfilPage.dart';
import 'package:servi_2/src/ui/buscadorPage.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Servi App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
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
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   textTheme: TextTheme(
        //     title: TextStyle(color: Colors.black, fontSize: 20.0, fontStyle: FontStyle.normal),
        //   ), 
        //   centerTitle: true,
        //   title: Text(
        //     'Servi App',
        //     style: TextStyle(
        //       color: Colors.black
        //     )
        //   ),
        // ),
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
