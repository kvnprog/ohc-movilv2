//here are all places available in array form
import 'package:flutter/material.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:http/http.dart' as http;

class PlacesArrayAvailableData {
  List<Places> arrayPlaces = [];
  String? datos;
  PlacesArrayAvailableData() {
    arrayPlaces.add(
      Places(
          icon: Icons.fastfood,
          name: 'recorrido',
          isActive: false,
          timeStart: null,
          timeEnd: null,
          numeroDeIncidencias: 0),
    );
    arrayPlaces.add(Places(
        icon: Icons.fastfood,
        name: 'Cocina',
        isActive: false,
        timeStart: null,
        timeEnd: null,
        numeroDeIncidencias: 0));
    arrayPlaces.add(Places(
        icon: Icons.monitor_sharp,
        name: 'Oficina',
        isActive: false,
        timeStart: null,
        timeEnd: null,
        numeroDeIncidencias: 0));
    arrayPlaces.add(Places(
        icon: Icons.filter_alt_sharp,
        name: 'Filtro',
        isActive: false,
        timeStart: null,
        timeEnd: null,
        numeroDeIncidencias: 0));
    arrayPlaces.add(Places(
        icon: Icons.medical_services_rounded,
        name: 'Consultorio',
        isActive: false,
        timeStart: null,
        timeEnd: null,
        numeroDeIncidencias: 0));
    arrayPlaces.add(Places(
        icon: Icons.auto_awesome,
        name: 'Calidad',
        isActive: false,
        timeStart: null,
        timeEnd: null,
        numeroDeIncidencias: 0));
    arrayPlaces.add(Places(
        icon: Icons.commute_sharp,
        name: 'Estacionamiento',
        isActive: false,
        timeStart: null,
        timeEnd: null,
        numeroDeIncidencias: 0));

    // inicializar('5555').then((data) => arrayPlaces.add(Places(
    //     icon: Icons.fastfood,
    //     name: 'recorrido',
    //     isActive: false,
    //     timeStart: null,
    //     timeEnd: null,
    //     numeroDeIncidencias: 0)));
    showValuesArray();
  }

  Future<String> inicializar(codigo) async {
    var url =
        Uri.parse("https://pruebasmatch.000webhostapp.com/traer_lugares.php");
    var resultado = await http.post(url, body: {"codigo": codigo});
    arrayPlaces.add(Places(
        icon: Icons.fastfood,
        name: 'recorrido',
        isActive: false,
        timeStart: null,
        timeEnd: null,
        numeroDeIncidencias: 0));
    return resultado.body;
  }

  List<Places> showValuesArray() {
    return arrayPlaces;
  }
}
