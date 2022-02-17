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

String dfotopreview = '';
String dresultado = '';
List<int>? dimageBytes;
String? dbase64Image;

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
                IconButton(
                    onPressed: () async {
                      var url = Uri.parse(
                          "${widget.conectionData.serverName()}crear_salida.php");
                      var entrada =
                          await http.post(url, body: {'index': widget.entrada});
                      print(entrada.body);
                      //var url = Uri.parse("${widget.conectionData.serverName()}crear_salida.php");
                      //var entrada = await http.post(url, body: {'index': widget.entrada});
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

  showDialogFunction(BuildContext context) {
    final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              margin: const EdgeInsets.all(30),
              width: 350,
              height: 350,
              child: Material(
                shadowColor: Colors.amber,
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 40),
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

                    //comentario
                    Container(
                      margin: const EdgeInsets.all(18),
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        onTap: () {},
                        onChanged: (responsable) {},
                        controller: dcomentario,
                        decoration: const InputDecoration(
                          hintText: 'Comentario',
                          hintMaxLines: 3,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black45, width: 2)),
                        ),
                      ),
                    ),

                    //lugar
                    Container(
                      margin: const EdgeInsets.all(18),
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        onTap: () {},
                        onChanged: (responsable) {},
                        controller: dlugar,
                        decoration: const InputDecoration(
                          hintText: 'Lugar',
                          hintMaxLines: 3,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black45, width: 2)),
                        ),
                      ),
                    ),
                    // (dfotopreview == '')
                    //     ? (const Text(''))
                    //     : (Transform.rotate(
                    //         angle: 0,
                    //         child: Transform.scale(
                    //             scale: 0.70,
                    //             child: Image.file(
                    //               File(dfotopreview),
                    //             )))),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MaterialButton(
                            color: Colors.amber,
                            child: Text(
                              'Foto'.toUpperCase(),
                              style: const TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DisplayPictureScreen(),
                                ),
                              ).then((value) {
                                if (value == null) {
                                  if (dfotopreview != '') {
                                    print("imagen ${fotopreview}");
                                  }
                                } else {
                                  dfotopreview = value;
                                }

                                // print(widget.index);
                                // var acciones = json.decode(widget.acciones);
                                // // var acciones = ['', '', ''];
                                // for (var element in acciones) {
                                //   _actionType.remove(element);
                                // }
                                setState(() {});
                              });
                            }),
                        MaterialButton(
                            color: Colors.greenAccent[400],
                            child: Text(
                              'Guardar'.toUpperCase(),
                              style: const TextStyle(color: Colors.black),
                            ),
                            onPressed: () async {
                              LocationPermission permission;

                              setState(() {});
                              permission =
                                  await _geolocatorPlatform.requestPermission();
                              final position = await _geolocatorPlatform
                                  .getCurrentPosition();
                              var url = Uri.parse(
                                  "${connect.serverName()}check_point.php");
                              //   print("soy yo ${widget.tipo}");
                              if (dfotopreview != '') {
                                dimageBytes =
                                    File(dfotopreview).readAsBytesSync();
                                dbase64Image = base64Encode(dimageBytes!);
                              } else {
                                dbase64Image = '';
                              }

                              //     if (widget.tipo == "Recorrido") {
                              await http.post(url, body: {
                                "recorrido": widget.entrada,
                                "latitude": position.latitude.toString(),
                                "longitude": position.longitude.toString(),
                                "comentario": dcomentario.text,
                                "lugar": dlugar.text,
                                "imagen": dbase64Image
                              });

                              setState(() {});
                            })
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
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
              func: () {
                setState(() {});
              }),
        ],
      ),
    );
  }
}

class DisplayPictureScreen extends StatefulWidget {
  const DisplayPictureScreen({Key? key}) : super(key: key);

  @override
  _DisplayPictureScreen createState() => _DisplayPictureScreen();
}

class _DisplayPictureScreen extends State<DisplayPictureScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  Future<void> iniciar() async {
    final cameras = await availableCameras();

    _controller = CameraController(
      // Obtén una cámara específica de la lista de cámaras disponibles
      cameras.first,
      // Define la resolución a utilizar
      ResolutionPreset.medium,
    );

    // A continuación, debes inicializar el controlador. Esto devuelve un Future!
    _initializeControllerFuture = _controller!.initialize();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    iniciar();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // La imagen se almacena como un archivo en el dispositivo. Usa el
      // constructor `Image.file` con la ruta dada para mostrar la imagen
      body: Column(
        children: [
          SizedBox(
            width: 410,
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // Si el Future está completo, muestra la vista previa

                  return Transform.rotate(
                      angle: 0, child: CameraPreview(_controller!));
                } else {
                  // De lo contrario, muestra un indicador de carga
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          FloatingActionButton(
            child: const Icon(Icons.camera_alt),
            // Agrega un callback onPressed
            onPressed: () async {
              try {
                await _initializeControllerFuture;
                XFile foto = await _controller!.takePicture();
                // fotopreview = foto.path;
                // fotopreview = '';
                Navigator.pop(context, foto.path);
              } catch (e) {
                // Si se produce un error, regístralo en la consola.
                print(e);
              }
            },
          ),
        ],
      ),
    );
  }
}
