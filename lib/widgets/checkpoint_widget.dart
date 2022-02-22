import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:recorridos_app/services/provider_listener_service.dart';
import 'package:recorridos_app/widgets/checkpoint_widget.dart';
import 'package:recorridos_app/widgets/interaction_menu_widget.dart';
import 'package:recorridos_app/widgets/list_widget.dart';
import 'package:recorridos_app/widgets/widgets.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:recorridos_app/data/conections_data.dart';
import 'package:http/http.dart' as http;

String dfotopreview = '';
String dresultado = '';
List<int>? dimageBytes;
String? dbase64Image;
bool? status;

final dcomentario = TextEditingController();
final dlugar = TextEditingController();
final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
ConectionData conectionData = ConectionData();

class CheckPointWidget extends StatefulWidget {
  final String? entrada;

  CheckPointWidget({Key? key, required this.entrada}) : super(key: key);

  @override
  State<CheckPointWidget> createState() => _CheckPointWidgetState();

  Color color = Colors.green;
  String prueba = 'nada';
}

class _CheckPointWidgetState extends State<CheckPointWidget> {
  bool btnactivo = false;
  bool btnload = true;
  bool? activeStatus;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProviderListener(),
      child: Consumer<ProviderListener>(
        builder: (context, provider, child) => Center(
          child: Container(
            margin: const EdgeInsets.all(30),
            width: 350,
            height: 450,
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

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('Iniciar Recorrido'),
                      Column(
                        children: [
                          if (status != null)
                            (!status!)
                                ? const Text('Detenido')
                                : const Text('Iniciado'),
                          Switch(
                            value: (status == null)
                                ? status = false
                                : status = status!,
                            onChanged: (value) {
                              setState(() {
                                print(value);
                                if (status == null) {
                                  status = value;
                                } else {
                                  (!status!) ? status = true : status = false;
                                }
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ],
                      ),
                    ],
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
                          child: btnload
                              ? btnactivo
                                  ? Center(
                                      child: Text(
                                        'checkpoint guardado'.toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    )
                                  : Text(
                                      'foto'.toUpperCase(),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    )
                              : const CircularProgressIndicator(),
                          onPressed: btnactivo
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DisplayPictureScreen(),
                                    ),
                                  ).then((value) {
                                    if (value == null) {
                                      if (dfotopreview != '') {
                                        print("imagen ${dfotopreview}");
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
                          child: btnload
                              ? btnactivo
                                  ? Text(
                                      ''.toUpperCase(),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    )
                                  : Text(
                                      'Guardar'.toUpperCase(),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    )
                              : const CircularProgressIndicator(),
                          onPressed: btnactivo
                              ? null
                              : () async {
                                  LocationPermission permission;
                                  btnload = false;
                                  btnactivo = true;
                                  setState(() {});
                                  permission = await _geolocatorPlatform
                                      .requestPermission();
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
                                  print(status);
                                  //     if (widget.tipo == "Recorrido") {
                                  await http.post(url, body: {
                                    "recorrido": widget.entrada,
                                    "latitude": position.latitude.toString(),
                                    "longitude": position.longitude.toString(),
                                    "comentario": dcomentario.text,
                                    "lugar": dlugar.text,
                                    "imagen": dbase64Image
                                  });
                                  btnload = true;

                                  dcomentario.text = "";
                                  dlugar.text = "";
                                  dfotopreview = "";

                                  setState(() {});
                                })
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
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
