import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:recorridos_app/widgets/list_menu_widget.dart';
import 'package:http/http.dart' as http;

void main() => runApp(ListWidget());

class ListWidget extends StatefulWidget {
  String? codigo;
  ListWidget({Key? key, this.codigo}) : super(key: key);

  @override
  State<ListWidget> createState() => _ListWidgetState();
  ConectionData connect = ConectionData();
}

class _ListWidgetState extends State<ListWidget> {
  //List item = List<Widget>.generate(20, (index) => ListMenuItem());
  List item = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
  List<dynamic>? datos;

  List<dynamic>? elementsArray;
  List<dynamic> filtradoArray = [];
  List<dynamic> totalArray = [];

  Future<String> incidencias() async {
    var url = Uri.parse(
        "${widget.connect.serverName()}traer_incidencias_celular.php");
    var respuesta = await http.post(url, body: {"codigo": widget.codigo});

    return respuesta.body;
  }

  dynamic filtro1;
  dynamic filtro2;
  dynamic filtro3;
  dynamic filtro4;
  dynamic filtro5;

  int pintarfiltro = 0;

  List<dynamic>? capturo;
  List<dynamic> filtrado = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora de Incidencias'),
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            FutureBuilder<String>(
                future: incidencias(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (pintarfiltro == 0) {
                      print(snapshot.data!);
                      elementsArray = jsonDecode(snapshot.data!);
                      totalArray = elementsArray!;
                    }
                    return lista_incidencias(elementsArray!);
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          ],
        ),
      ),
    );
  }

  Widget lista_incidencias(List<dynamic> datos) {
    return Column(children: [
      SizedBox(
        height: 130,
        width: double.infinity,
        child: GridView.count(
            childAspectRatio: 3,
            mainAxisSpacing: 3,
            crossAxisSpacing: 5,
            shrinkWrap: true,
      
            crossAxisCount: 2,
            children: [
                  filterWidget(filtro1, 9, 'Quién captura', 0),
                  filterWidget(filtro2, 3, 'Responsable', 1),
                  filterWidget(filtro3, 1, 'Lugar', 2),
                  filterWidget(filtro4, 2, 'fecha', 3),
                  filterWidget(filtro5, 2, 'Hora', 4),
            ]
        )
      ),
      Container(
          height: 580,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: datos.length,
            itemBuilder: (BuildContext context, int index) {
              return ListMenuItem(datos: datos[index]);
            },
          )),
    ]);
  }

  Widget filterWidget(var filterName, int index, String filterTitle, int tipo) {
    // print('yo soy el filtro $filterName');

    return Column(
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
            child: 
            
            ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                ClipRect(
                  child: DropdownButton<String>(
                      value: filterName,
                      items: getItemsDropDown(index, filterTitle),
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
                        setState(() {
                          switch (index) {
                            case 9:
                              {
                                filtro1 = opt;
                                filtradoArray = [];
                                elementsArray = totalArray;
                                for (var element in elementsArray!) {
                                  if (element[index] == opt) {
                                    filtradoArray.add(element);
                                    // print("entre");
                                  }
                                }
                                pintarfiltro = 1;
                                elementsArray = [];
                                elementsArray = filtradoArray;
                                print(filtradoArray);
                                setState(() {});
                              }
                              break;
                
                            case 1:
                              {
                                filtro3 = opt;
                                filtradoArray = [];
                                elementsArray = totalArray;
                                for (var element in elementsArray!) {
                                  if (element[index] == opt) {
                                    filtradoArray.add(element);
                                    // print("entre");
                                  }
                                }
                                pintarfiltro = 1;
                                elementsArray = [];
                                elementsArray = filtradoArray;
                                print(filtradoArray);
                                setState(() {});
                                // for (var element in elementsArray!) {
                                //   // if (element[index] == opt) {
                                //   //   filtradoArray.add(element[index]);
                                //   // }
                                //   print(element[index]);
                                // }
                              }
                              break;
                
                            case 2:
                              {
                                if (tipo == 3) {
                                  filtro4 = opt;
                                } else {
                                  filtro5 = opt;
                                }
                
                                filtradoArray = [];
                                elementsArray = totalArray;
                                for (var element in elementsArray!) {
                                  var separador =
                                      element[index].toString().split(" ");
                
                                  // print(element[index]);
                                  if (element[index] != null) {
                                    if (separador[0] == opt ||
                                        separador[1] == opt) {
                                      filtradoArray.add(element);
                                      // print("entre");
                                    }
                                  }
                                }
                                pintarfiltro = 1;
                                elementsArray = [];
                                elementsArray = filtradoArray;
                                print(filtradoArray);
                                setState(() {});
                                print(opt);
                              }
                              break;
                
                            case 3:
                              {
                                filtro2 = opt;
                                filtradoArray = [];
                                elementsArray = totalArray;
                                for (var element in elementsArray!) {
                                  if (element[index] == opt) {
                                    filtradoArray.add(element);
                                    // print("entre");
                                  }
                                }
                                pintarfiltro = 1;
                                elementsArray = [];
                                elementsArray = filtradoArray;
                                print(filtradoArray);
                                setState(() {});
                              }
                              break;
                
                            default:
                              {
                                return null;
                              }
                          }
                        });
                      }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> getItemsDropDown( int index, String filterTitle) {
    List<DropdownMenuItem<String>> itemsAvailable = []; 
    if (index == 2) {

      Map datos = new Map();
      List<dynamic> arreglo = [];
      for (var element in totalArray) {
        if (element[index] != null) {
          List<String> fechahora = element[index].split(' ');
          if (filterTitle == 'fecha') {
            datos[fechahora[0]] = fechahora[0];
          } else {
             datos[fechahora[1]] = fechahora[1];
          }
        }
      }
    
      datos.forEach((key, value) {
        itemsAvailable.add(DropdownMenuItem(
          child: Text(value.toString()),
          value: value,
        ));
      });

    } else {
      Map datos = new Map();
      List<dynamic> arreglo = [];
      for (var element in totalArray) {
        datos['${element[index]}'] = element[index];
      }

      datos.forEach((key, value) {
        itemsAvailable.add(DropdownMenuItem(
          child: Text(value.toString()),
          value: value,
        ));
      });
    }

    return itemsAvailable;
  }
}
