import "package:cloud_firestore/cloud_firestore.dart";

class BusquedaServicio {

  getServicio(String diccionario){
    return Firestore.instance
    .collection('servicios')
    .where('diccionario', isEqualTo: diccionario)
    .getDocuments();
  }
}