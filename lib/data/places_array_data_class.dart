//here are all places available in array form
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:http/http.dart' as http;

class PlacesArrayAvailableData {
  List<Places> arrayPlaces = [Places(name: 'recorrido', icon: Icons.directions_walk_rounded, isActive: false)];
  String? datos;
  ConectionData connect = ConectionData();

  
  /*PlacesArrayAvailableData() {
    inicializar('5555').then((data) => arrayPlaces.add(Places(
        //icon: Icons.fastfood,
        name: 'recorrido',
        isActive: false,
        timeStart: null,
        timeEnd: null,
        numeroDeIncidencias: 0)));
    //showValuesArray();
  } */

  Future<String> inicializar(codigo) async {
    var url =
        Uri.parse("${connect.serverName()}traer_lugares.php");
    var resultado = await http.post(url, body: {"codigo": codigo});

    // print(resultado.body);

    List<dynamic> datos = jsonDecode(resultado.body);

    print(datos);

    for (var dato in datos) {
      arrayPlaces.add(Places(
          icon: Icons.fastfood,
          name: dato[1],
          isActive: false,
          timeStart: null,
          timeEnd: null,
          numeroDeIncidencias: 0));
    }

    return resultado.body;
  }

  List<Places> showValuesArray() {
    return arrayPlaces;
  }
}
