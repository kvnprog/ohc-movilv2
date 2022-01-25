import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recorridos_app/widgets/list_menu_widget.dart';
import 'package:http/http.dart' as http;

<<<<<<< HEAD
void main() => runApp(BitacoraRecorridos());

class BitacoraRecorridos extends StatefulWidget {
  BitacoraRecorridos({Key? key}) : super(key: key);
=======
class BitacoraRecorridos extends StatelessWidget {
  //List item = List<Widget>.generate(20, (index) => ListMenuItem());
>>>>>>> c1ffd9a14afbf1120325dcfdf1fc5b3ed6d19fb7

  @override
  State<BitacoraRecorridos> createState() => _BitacoraRecorridosState();
}

class _BitacoraRecorridosState extends State<BitacoraRecorridos> {
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
          appBar: AppBar(
            title: const Text('Incidencias en recorrido'),
          ),
          body: Container(
            child: Column(
              children: [
<<<<<<< HEAD
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
=======
                _personalWidget()
>>>>>>> c1ffd9a14afbf1120325dcfdf1fc5b3ed6d19fb7
              ],
            ),
          ),
    );
  }

<<<<<<< HEAD
  Widget lista_incidencias(List<dynamic> datos) {
    final data = datos.length;
=======
  Widget _personalWidget() {
    final data = item.length;
>>>>>>> c1ffd9a14afbf1120325dcfdf1fc5b3ed6d19fb7
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
