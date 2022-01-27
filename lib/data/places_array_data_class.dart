//here are all places available in array form
import 'package:flutter/material.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:http/http.dart' as http;

class PlacesArrayAvailableData {
  List<Places> arrayPlaces = [];

  PlacesArrayAvailableData() {
    arrayPlaces.add(Places(
        icon: Icons.fastfood,
        name: 'recorrido',
        isActive: false,
        timeStart: null,
        timeEnd: null,
        numeroDeIncidencias: 0));

    showValuesArray();
  }

  void inicializar(codigo) async {
    var url =
        Uri.parse("https://pruebasmatch.000webhostapp.com/traer_lugares.php");
    var resultado = await http.post(url, body: {"codigo": codigo});
  }

  List<Places> showValuesArray() {
    return arrayPlaces;
  }
}
