import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:recorridos_app/widgets/checkpoint_widget.dart';
import 'package:recorridos_app/widgets/list_widget.dart';
import 'package:recorridos_app/widgets/widgets.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class MainClass extends StatefulWidget {
  final String? acciones;
  final String? usuario;
  PlacesArrayAvailableData? dataList;
  final String? entrada;
  final String? codigo;

  dynamic nombre;

  MainClass({
    Key? key,
    this.acciones,
    this.usuario,
    this.dataList,
    this.nombre,
    this.entrada,
    this.codigo,
  }) : super(key: key);

  @override
  State<MainClass> createState() => _MainClassState();

  double width = 20.0;
  double height = 100.0;

  ConectionData conectionData = ConectionData();
  bool isCharging = true;
}

final dcomentario = TextEditingController();
final dlugar = TextEditingController();

class _MainClassState extends State<MainClass> {
  List userArray = ["uno", "dos", "tres", "cuatro"];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home',
      home: Scaffold(
        appBar: AppBar(
          actions: [
            Row(
              children: [
                const Text(
                  'Salir',
                  style: TextStyle(color: Colors.black),
                ),
                widget.isCharging
                    ? IconButton(
                        onPressed: () async {
                          widget.isCharging = false;
                          setState(() {});
                          var url = Uri.parse(
                              "${widget.conectionData.serverName()}crear_salida.php");
                          var entrada = await http.post(url, body: {
                            'index': widget.entrada,
                            'usuario': widget.usuario,
                            'codigo': widget.codigo
                          });
                          widget.isCharging = true;
                          print(entrada.body);
                          //var url = Uri.parse("${widget.conectionData.serverName()}crear_salida.php");
                          //var entrada = await http.post(url, body: {'index': widget.entrada});

                          Navigator.of(context).pop('login');
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.black,
                          size: 30,
                        ))
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: const CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          color: Colors.black,
                        ),
                      )
              ],
            ),
          ],
          title: const Text('Home'),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  child: Column(
                    children: const [
                      Icon(Icons.file_copy, size: 65, color: Colors.white),
                      Text(
                        'Incidencias',
                        overflow: TextOverflow.visible,
                        softWrap: false,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ListWidget(
                              codigo: widget.codigo,
                            )));
                  },
                ),
                GestureDetector(
                  child: Column(
                    children: const [
                      Icon(
                        Icons.file_present_rounded,
                        size: 65,
                        color: Colors.white,
                      ),
                      Text(
                        'Actividades',
                        overflow: TextOverflow.ellipsis,
                        maxLines: null,
                        semanticsLabel: '...',
                        textWidthBasis: TextWidthBasis.parent,
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => BitacoraGeneral(
                            userArray: userArray,
                            user: widget.usuario.toString(),
                            userName: widget.nombre,
                            codigo: widget.codigo
                            //codigo: widget.codigo
                            )));
                  },
                ),
                GestureDetector(
                    child: Column(
                      children: const [
                        Icon(
                          Icons.flag,
                          size: 65,
                          color: Colors.white,
                        ),
                        Text(
                          'CheckPoint',
                          overflow: TextOverflow.ellipsis,
                          maxLines: null,
                          semanticsLabel: '...',
                          textWidthBasis: TextWidthBasis.parent,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        )
                      ],
                    ),
                    onTap: () => showDialogFunction(context)),
              ],
            ),
            Expanded(
              child: SizedBox(
                width: 500,
                height: 630,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    InteractionMenu(
                        recorrido: widget.entrada,
                        nombre: widget.nombre.toString(),
                        acciones: widget.acciones!,
                        isNewMenuRequest: true,
                        btnsave: true,
                        tipo: "1",
                        codigo: widget.codigo!,
                        usuario: widget.usuario,
                        func: () {
                          setState(() {});
                        }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[850],
      ),
    );
  }

  barProgress(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
  }

  showDialogFunction(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return CheckPointWidget(
              entrada: widget.entrada,
              usuario: widget.usuario,
              codigo: widget.codigo);
        });
  }

  Widget interactionMenuWidget() {
    return AnimatedContainer(
      duration: const Duration(seconds: 10),
      curve: Curves.fastOutSlowIn,
      margin: const EdgeInsets.only(left: 10),
      width: 320,
      child: ListView(
        shrinkWrap: true,
        children: [
          InteractionMenu(
              nombre: widget.nombre[0],
              acciones: widget.acciones!,
              isNewMenuRequest: true,
              btnsave: true,
              tipo: "1",
              codigo: widget.codigo!,
              usuario: widget.usuario,
              func: () {
                setState(() {});
              }),
        ],
      ),
    );
  }
}
