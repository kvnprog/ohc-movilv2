import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recorridos_app/widgets/list_menu_widget.dart';
import 'package:http/http.dart' as http;

void main() => runApp(BitacoraInicio());

class BitacoraInicio extends StatefulWidget {
  BitacoraInicio({Key? key}) : super(key: key);

  @override
  State<BitacoraInicio> createState() => _BitacoraInicioState();
}

class _BitacoraInicioState extends State<BitacoraInicio> {
  //List item = List<Widget>.generate(20, (index) => ListMenuItem());
  List item = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
  List<dynamic>? datos;

  Future<String> incidencias() async {
    var url = Uri.parse(
        "https://pruebasmatch.000webhostapp.com/traer_incidencias24.php");
    var respuesta = await http.post(url, body: {});
    return respuesta.body;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            FutureBuilder<dynamic>(
                future: incidencias(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    datos = jsonDecode(snapshot.data!);
                    return lista_incidencias(datos!);
                  }
                  return CircularProgressIndicator();
                }),
          ],
        ),
      ),
    );
  }

  Widget lista_incidencias(List<dynamic> datos) {
    final data = datos.length;
    return Column(children: [
      Container(
          height: 710,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: data,
            itemBuilder: (BuildContext context, int index) {
              return ListMenuItem(datos: datos[index]);
            },
          )),
    ]);
  }
}
