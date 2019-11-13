import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servi_2/src/services/busquedaServicio.dart';

class BuscadorPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Buscar'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){
            showSearch(context: context, delegate: DataSearch());
          })
        ],
      ),
      // drawer: Drawer(),
    );
  }
}


class DataSearch extends SearchDelegate<String>{

  final services = [
    "Plomero",
    "Programador",
    "Cerrajero",
    "Electricista",
    "Pintor",
    "Albañil",
    "Mecánico",
    "Cocinero",
    "Arquitecto",
    "Agua",
    "Tubos",
    "Llave",
    "Computadora",
    "Laptop",
    "Casa",
    "Carro",
    "Motor",
    "Construcción",
    "Luz",
    "Negocio",
    "Apagador",
  ];

  final recentServices = [
    "Plomero",
    "Programador",
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    //acciones para la barra de busqueda
    return[
      IconButton(
        icon: Icon(Icons.clear), 
        onPressed: (){
          query = "";
        })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //deja el icono de lado izquierdo de la appbar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: (){
          close(context, null);
        });
  }
  
  @override
  Widget buildResults(BuildContext context) {
    //muestra los resultados basados en la seleccion
    return Center(
      child: Container(
      height: 100.0,
      width: 100.0,
      child: Card(
        color: Colors.red,
        child: Center(
          child: Text(query),
        ),
      ),
      )
    );
    
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //muestra cuando encuentra algo
    final suggestionList = query.isEmpty 
        ? recentServices 
        : services.where((p)=>p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context,index)=> ListTile(
        onTap: (){
          showResults(context);
        },
          leading: Icon(Icons.pie_chart),
          title: RichText(
            text: TextSpan(
              text: suggestionList[index].substring(0,query.length),
              style: 
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: suggestionList[index].substring(query.length),
                  style: TextStyle(color: Colors.grey)
              )]
            )
          ),
      ),
      itemCount: suggestionList.length,
    );
  }

  

}