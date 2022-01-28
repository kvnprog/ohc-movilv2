import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recorridos_app/widgets/list_menu_widget.dart';
import 'package:http/http.dart' as http;

void main() => runApp(ListWidget());

class ListWidget extends StatefulWidget {
  ListWidget({Key? key}) : super(key: key);

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  //List item = List<Widget>.generate(20, (index) => ListMenuItem());
  List item = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
  List<dynamic>? datos;

  List<List<String>> elementsArray = [];

  Future<String> incidencias() async {
    var url = Uri.parse(
        "https://pruebasmatch.000webhostapp.com/traer_incidencias_celular.php");
    var respuesta = await http.post(url, body: {"codigo": '5555'});

    return respuesta.body;
  }

  dynamic filtro1;
  dynamic filtro2;
  dynamic filtro3;
  dynamic filtro4;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora de recorridos'),
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            FutureBuilder<String>(
                future: incidencias(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    datos = jsonDecode(snapshot.data!);
                    // print(datos);
                    // return Text(snapshot.data!);
                    return lista_incidencias(datos!);
                  }
                  return Center(child: CircularProgressIndicator());
                }),
          ],
        ),
      ),
    );
  }

  Widget lista_incidencias(List<dynamic> datos) {
    return Column(children: [
      Container(
        height: 80,
        width: double.infinity,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (BuildContext context, index) {
              return Row(
                children: [
                  const SizedBox(width: 15),
                  filterWidget(filtro1, 0, 'Quién captura'),
                  const SizedBox(width: 15),
                  filterWidget(filtro2, 1, 'Responsable'),
                  const SizedBox(width: 15),
                  filterWidget(filtro3, 2, 'Lugar'),
                  const SizedBox(width: 15),
                  filterWidget(filtro4, 3, 'Hora'),
                ],
              );
            }),
      ),
      Container(
          height: 500,
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

  Widget filterWidget(var filterName, int index, String filterTitle) {
    print('yo soy el filtro $filterName');

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
            width: 170,
            decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: const BorderRadius.all(Radius.circular(3))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                  value: filterName,
                  items: getItemsDropDown(index),
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
                    print(filterName);
                    setState(() {
                      switch (index) {
                        case 0:
                          {
                            filtro1 = opt;
                          }
                          break;

                        case 1:
                          {
                            filtro2 = opt;
                          }
                          break;

                        case 2:
                          {
                            filtro3 = opt;
                          }
                          break;

                        case 3:
                          {
                            filtro4 = opt;
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
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> getItemsDropDown(int index) {
    List<DropdownMenuItem<String>> itemsAvailable = [];

    var dropDownOptions = elementsArray.getRange(0, elementsArray.length);
    for (var element in dropDownOptions) {
      itemsAvailable.add(DropdownMenuItem(
        child: Text('${element[index].toString()}'),
        value: element[index],
      ));
    }
    return itemsAvailable;
  }
}
