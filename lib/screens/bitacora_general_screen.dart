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
}

class _BitacoraGeneralState extends State<BitacoraGeneral> {
  ConectionData connect = ConectionData();

  @override
  Widget build(BuildContext context) {
    List arrayList = [
      {
        'nombre': 'Manuel Neuer',
        'actividad': [
          {
            'title': 'checkpoints',
            'checkpoint': [
              {'hora': '10:00'},
              {'hora': '20:00'},
              {'hora': '18:00'},
            ]
          },
          {
            'title': 'incidencias',
            'incidence': [
              {'hora': '10:00', 'lugar': 'cocina'},
              {'hora': '20:00', 'lugar': 'oficina'},
              {'hora': '18:00', 'lugar': 'consultorio'},
            ],
          }
        ]
      },
      {
        'nombre': 'Christian Martinoli',
        'actividad': [
          {
            'title': 'checkpoints',
            'checkpoint': [
              {'hora': '12:00'},
              {'hora': '00:00'},
              {'hora': '15:00'},
            ]
          },
          {
            'title': 'incidencias',
            'incidence': [
              {'hora': '2:00', 'lugar': 'estacionamiento'},
              {'hora': '21:00', 'lugar': 'baño'},
              {'hora': '8:00', 'lugar': 'losa'},
            ],
          }
        ]
      },
      {
        'nombre': 'Luis García',
        'actividad': [
          {
            'title': 'checkpoints',
            'checkpoint': [
              {'hora': '20:00'},
              {'hora': '2:00'},
              {'hora': '7:00'},
            ]
          },
          {
            'title': 'incidencias',
            'incidence': [
              {'hora': '21:00', 'lugar': 'patio'},
              {'hora': '20:00', 'lugar': 'estacionamiento'},
              {'hora': '2:00', 'lugar': 'gerencia'},
            ],
          }
        ]
      },
      {
        'nombre': 'Francesco Toti',
        'actividad': [
          {
            'title': 'checkpoints',
            'checkpoint': [
              {'hora': '17:00'},
              {'hora': '00:00'},
              {'hora': '4:00'},
            ]
          },
          {
            'title': 'incidencias',
            'incidence': [
              {'hora': '3:00', 'lugar': 'almacén'},
              {'hora': '12:00', 'lugar': 'estacionamiento'},
              {'hora': '8:00', 'lugar': 'sala'},
            ],
          }
        ]
      },
      {
        'nombre': 'Roberto Carlos',
        'actividad': [
          {
            'title': 'checkpoints',
            'checkpoint': [
              {'hora': '10:40'},
              {'hora': '20:20'},
              {'hora': '18:10'},
            ]
          },
          {
            'title': 'incidencias',
            'incidence': [
              {'hora': '10:09', 'lugar': 'sala'},
              {'hora': '20:50', 'lugar': 'cuartos'},
              {'hora': '18:20', 'lugar': 'planta'},
            ],
          }
        ]
      },
      {
        'nombre': 'Zinedine Zidane',
        'actividad': [
          {
            'title': 'checkpoints',
            'checkpoint': [
              {'hora': '10:10'},
              {'hora': '20:20'},
              {'hora': '18:10'},
            ]
          },
          {
            'title': 'incidencias',
            'incidence': [
              {'hora': '10:20', 'lugar': 'consultorio'},
              {'hora': '20:30', 'lugar': 'estacionamiento'},
              {'hora': '18:20', 'lugar': 'patio'},
            ],
          }
        ]
      },
    ];
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
                                  // contentActivity: textGenerator(arrayList, index),
                                );
                              },
                              reverse: true,
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

  List<DropdownMenuItem<String>> getItemsDropDown(List<dynamic> datos) {
    List<DropdownMenuItem<String>> itemsAvailable = [];

    datos.forEach((element) {
      itemsAvailable.add(DropdownMenuItem(
        child: Text('${element.toString()}'),
        value: element.toString(),
      ));
    });

    // datos.forEach((key, value) {
    //   itemsAvailable.add(DropdownMenuItem(
    //     child: Text('${value.toString()}'),
    //     value: value,
    //   ));
    // });

    return itemsAvailable;
  }

  dynamic filtro1;

  dynamic filtro2;

  int opcion1 = 0;
  int opcion2 = 1;

  Widget filterWidget(int opcion, var filterName, int index, String filterTitle,
      List<dynamic> datos) {
    // print('yo soy el filtro $filterName');

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Text(
            filterTitle,
            style: const TextStyle(color: Colors.white),
          ),
          Container(
            height: 40,
            width: 200,
            decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: const BorderRadius.all(Radius.circular(3))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                  value: filterName,
                  items: getItemsDropDown(datos),
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

                        // print(DateTime.now());
                        DateTime diasdespues =
                            dia.subtract(Duration(hours: int.parse(opt!)));
                        for (var valor in arrayrespaldo!['entradas']) {
                          DateTime dia2 = DateTime.parse(valor[2]);
                          if (diasdespues.microsecondsSinceEpoch >
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
}
