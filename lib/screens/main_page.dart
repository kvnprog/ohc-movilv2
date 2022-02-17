import 'package:flutter/material.dart';
import 'package:recorridos_app/data/places_array_data_class.dart';
import 'package:recorridos_app/screens/screens.dart';
import 'package:recorridos_app/widgets/list_widget.dart';
import 'package:recorridos_app/widgets/widgets.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:http/http.dart' as http;

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
}

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
                IconButton(
                    onPressed: () async {
                      var url = Uri.parse(
                          "${widget.conectionData.serverName()}crear_salida.php");
                      var entrada =
                          await http.post(url, body: {'index': widget.entrada});
                      print(entrada.body);
                      Navigator.of(context).pop('login');
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.black,
                      size: 30,
                    )),
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
                        Icons.emoji_flags_sharp,
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
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                            child: Container(
                              width: 350,
                              height: 300,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 40),
                                    child: const Text(
                                      'Crear CheckPoint',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          textBaseline: null,
                                          fontStyle: FontStyle.normal,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.normal),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ),
              ],
            ),
            SizedBox(
              width: 500,
              height: 630,
              child: Container(
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    InteractionMenu(
                        recorrido: widget.entrada,
                        nombre: widget.nombre.toString(),
                        acciones: widget.acciones!,
                        isNewMenuRequest: true,
                        btnsave: true,
                        tipo: "1",
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
          appBarTheme: const AppBarTheme(backgroundColor: Colors.amber),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.amber)),
    );
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
              func: () {
                setState(() {});
              }),
        ],
      ),
    );
  }
}
