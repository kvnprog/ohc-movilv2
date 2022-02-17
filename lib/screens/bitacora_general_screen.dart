import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:recorridos_app/screens/screens.dart';
import 'package:recorridos_app/widgets/list_widget.dart';
import 'package:recorridos_app/widgets/widgets.dart';
import 'package:http/http.dart' as http;

Map? arrayrespaldo;
bool cargar = true;
Map arrayfinal = Map();

class BitacoraGeneral extends StatefulWidget {
  List userArray;
  String user;
  dynamic userName;
  String? codigo;

  BitacoraGeneral(
      {required this.userArray,
      required this.userName,
      required this.user,
      this.codigo});

  @override
  State<BitacoraGeneral> createState() => _BitacoraGeneralState();

  dynamic nameValue;
  dynamic hourValue;

  dynamic isOne(int index) {
    switch (index) {
      case 0:
        {
          return nameValue;
        }
      case 1:
        {
          return hourValue;
        }
    }
  }
}

class _BitacoraGeneralState extends State<BitacoraGeneral> {
  ConectionData connect = ConectionData();

  @override
  void dispose() {
    // TODO: implement dispose
    cargar = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<String> bitacora() async {
      var url = Uri.parse("${connect.serverName()}traer_bitacora.php");
      var resultado = await http.post(url, body: {"codigo": widget.codigo});

      return resultado.body;
    }

    Future<String> usuarios() async {
      var url = Uri.parse("${connect.serverName()}traer_usuarios.php");
      var resultado = await http.post(url, body: {"codigo": widget.codigo});

      return resultado.body;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora general'),
      ),
      body: FutureBuilder(
          future: bitacora(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(cargar);
              if (cargar) {
                arrayfinal = jsonDecode(snapshot.data.toString());
                arrayrespaldo = arrayfinal;
                cargar = false;
              }

              // print(arrayfinal);
              // print(snapshot.data);
              // print(arrayfinal['entradas']);

              return FutureBuilder(
                  future: usuarios(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // print(snapshot.data);
                      List<dynamic> usuariosjson =
                          jsonDecode(snapshot.data.toString());
                      List<dynamic> usuarios = [];
                      for (var usuario in usuariosjson) {
                        usuarios.add(usuario[0]);
                      }

                      return Column(
                        children: [
                          SizedBox(
                              height: 100,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  children: [
                                    filterWidget(opcion1, filtro1, 0, 'Nombre',
                                        usuarios),
                                    const SizedBox(width: 20),
                                    filterWidget(opcion2, filtro2, 0, 'Hora',
                                        [1, 2, 8, 12, 24, 48, 72]),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 600,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: arrayfinal['entradas'].length,
                              itemBuilder: (BuildContext context, index) {
                                // print(snapshot.data);

                                // return Text("${arrayfinal['entradas'][index]}");
                                return ListBitacoraWidget(
                                  // user: user,
                                  userName: arrayfinal['entradas'][index][5],
                                  start: arrayfinal['entradas'][index][2],
                                  end: arrayfinal['entradas'][index][3],
                                  incidencias: arrayfinal['entradas'][index][4],
                                  checkpoint: arrayfinal['entradas'][index][6],
                                  // contentActivity: textGenerator(arrayList, index),
                                );
                              },
                              reverse: false,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  });
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Widget textGenerator(List arrayList, int index) {
    List mArray = arrayList[index]['actividad'];
    final checkPointList = mArray[0]['checkpoint'] as List;
    final incidencesList = mArray[1]['incidence'] as List;
    List finalList = [];

    for (var checkItem in checkPointList) {
      String hora = checkItem['hora'];
      finalList.add('Realizó un checkPoint a las $hora hrs.');
    }

    for (var incidenceItem in incidencesList) {
      String hora = incidenceItem['hora'];
      String lugar = incidenceItem['lugar'];
      finalList.add('Realizó una incidencia en $lugar a las $hora hrs.');
    }

    return ListView(
      children: [
        for (var item in finalList)
          Container(
              margin: const EdgeInsets.all(8),
              child: Text(
                item,
                style: const TextStyle(fontSize: 15),
              ))
      ],
    );
  }

  dynamic filtro1;

  dynamic filtro2;

  int opcion1 = 0;
  int opcion2 = 1;

  Widget filterWidget(int opcion, var filterName, int index, String filterTitle,
      List<dynamic> datos) {
    // print('yo soy el filtro $filterName');
    List<dynamic> mList = [widget.nameValue, widget.hourValue];
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Text(
            filterTitle,
            style: const TextStyle(color: Colors.white),
          ),
          Container(
            height: 50,
            width: 210,
            decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: const BorderRadius.all(Radius.circular(3))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                  value: mList[opcion],
                  items: getItemsDropDown(datos, filterName),
                  //items: getItemsDropDown(index, filterTitle),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  dropdownColor: Colors.amber[200],
                  icon: const Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Colors.black,
                  ),
                  underline: Container(
                    color: Colors.white,
                  ),
                  onChanged: (opt) {
                    // print(opt);
                    switch (opcion) {
                      case 0:
                        Map<dynamic, dynamic> arrayfiltro = Map();
                        arrayfiltro['entradas'] = List<dynamic>;
                        List<dynamic> datos = [];
                        // arrayfiltro = arrayrespaldo!;
                        widget.nameValue = opt;
                        for (var valor in arrayrespaldo!['entradas']) {
                          if (valor[5] == opt) {
                            datos.add(valor);
                          }
                        }
                        arrayfiltro['entradas'] = datos;
                        arrayfinal = arrayfiltro;

                        setState(() {});
                        break;

                      case 1:
                        Map<dynamic, dynamic> arrayfiltro = Map();
                        arrayfiltro['entradas'] = List<dynamic>;
                        List<dynamic> datos = [];
                        DateTime dia = DateTime.now();
                        widget.hourValue = opt;
                        // print(DateTime.now());
                        DateTime diasdespues =
                            dia.subtract(Duration(hours: int.parse(opt!)));
                        for (var valor in arrayrespaldo!['entradas']) {
                          DateTime dia2 = DateTime.parse(valor[2]);
                          print(
                              "primero ${diasdespues.microsecondsSinceEpoch}");
                          print("despues ${dia2.microsecondsSinceEpoch}");
                          if (diasdespues.microsecondsSinceEpoch <
                              dia2.microsecondsSinceEpoch) {
                            datos.add(valor);
                          }
                        }

                        arrayfiltro['entradas'] = datos;
                        arrayfinal = arrayfiltro;
                        print(arrayfinal);
                        setState(() {});

                        break;
                    }
                    // print(arrayrespaldo!['entradas']);
                  }),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> getItemsDropDown(
      List<dynamic> datos, String context) {
    dynamic mValue = 'Todos';

    List<DropdownMenuItem<String>> itemsAvailable = [];
    print(datos);
    datos.forEach((element) {
      // switch (context) {
      //   case 'Nombre':
      //     {
      //       mValue = element[0];
      //     }
      //     break;

      //   case 'Hora':
      //     {
      //       mValue = element.toString();
      //     }
      //     break;
      // }

      itemsAvailable.add(DropdownMenuItem(
          child: Text(element.toString()), value: element.toString()));
    });

    return itemsAvailable;
  }
}
