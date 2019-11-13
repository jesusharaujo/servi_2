import 'package:flutter/material.dart';
import 'package:servi_2/src/ui/homePage.dart';
import 'package:servi_2/src/ui/miperfilPage.dart';
import 'package:servi_2/src/ui/buscadorPage.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatefulWidget {
  @override
    State<StatefulWidget> createState() {
      return MyAppState();
    }
}

class MyAppState extends State<MyApp>{

int _currentIndex = 0;

Widget callPage(int currentIndex){
    switch(currentIndex){
      case 0: return HomePage();
      case 1: return BuscadorPage();
      case 2: return MiPerfilPage();
        break;
      default: return HomePage();
    }
  }

@override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        
        body: callPage(_currentIndex),

        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.blue,
          currentIndex:_currentIndex,
          onTap: (value){
              _currentIndex = value;
              setState(() {
                
              });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Buscador')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Mi Perfil')
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.person),
            //   title: Text('Mi perfil')
            // )
          ],
        ),
      ),
      routes: <String, WidgetBuilder>{
        "/home" : (BuildContext context) => HomePage(),
        "/buscador" : (BuildContext context) => BuscadorPage(),
        "/miperfil" : (BuildContext context) => MiPerfilPage(),
      },
    );
  }

}