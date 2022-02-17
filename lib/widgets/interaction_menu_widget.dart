import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:recorridos_app/data/places_array_data_class.dart';
import 'package:recorridos_app/screens/screens.dart';
import 'package:recorridos_app/services/provider_listener_service.dart';

String fotopreview = '';
String resultado = '';
List<int>? imageBytes;
String? base64Image;
ConectionData connect = ConectionData();

final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

class InteractionMenu extends StatefulWidget {
  final String nombre;
  final String? usuario;
  final String acciones;
  final String? lugar;
  final String? estado;
  final Function() func;

  final recorrido;
  bool btnsave;
  bool isNewMenuRequest;
  String tipo;

  InteractionMenu(
      {Key? key,
      this.lugar,
      this.usuario,
      this.recorrido,
      this.estado,
      required this.nombre,
      required this.acciones,
      required this.isNewMenuRequest,
      required this.btnsave,
      required this.tipo,
      required this.func})
      : super(key: key);

  @override
  _InteractionMenuState createState() => _InteractionMenuState();
}

class _InteractionMenuState extends State<InteractionMenu> {
  // PlacesArrayAvailableData dataList = PlacesArrayAvailableData();
  final comentario = TextEditingController();
  final responsable = TextEditingController();
  final accion = TextEditingController();
  final lugar = TextEditingController();

  double height = 15;

  bool btnload = true;
  bool activeStatus = false;

  bool isAccident = false;
  String accidentText = 'No';
  String isActive = 'No';

  //metodo de traer acciones

  //lista de acciones disponibles
  final List<String> _actionType = [
    'Acción',
  ];

  dynamic _opcionSeleccionada = 'Acción';

  @override
  void initState() {
    super.initState();
    var acciones = json.decode(widget.acciones);
    for (var element in acciones) {
      _actionType.remove(element);
    }
    //final provider = Provider.of<ProviderListener>(context, listen: false);

    /* if (provider.itemIsReady != null) {
      if (widget.isNewMenuRequest && fotopreview != '') {
        fotopreview = '';
      }
    } */
  }

  @override
  Widget build(BuildContext context) {
    var acciones = json.decode(widget.acciones);

    for (var element in acciones) {
      _actionType.remove(element);
    }

    // List<String> acciones = ['', '', ''];

    for (var element in acciones) {
      _actionType.add(element);
    }

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProviderListener())],
      child: Container(
        margin: const EdgeInsets.only(bottom: 25, left: 5, right: 5, top: 35),
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: const Text(
                  'Nueva Incidencia',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              TextField(
                controller: responsable,
                textCapitalization: TextCapitalization.sentences,
                onTap: () {
                  var acciones = json.decode(widget.acciones);
                  // var acciones = ['', '', ''];
                  for (var element in acciones) {
                    _actionType.remove(element);
                  }
                },
                onChanged: (responsable) {
                  // print(widget.index);
                  var acciones = json.decode(widget.acciones);
                  // var acciones = ['', '', ''];
                  for (var element in acciones) {
                    _actionType.remove(element);
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'Infractor de la incidencia',
                  icon: Icon(
                    Icons.person_off_outlined,
                    color: Colors.black87,
                  ),
                  hintMaxLines: 3,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45, width: 2)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: comentario,
                textCapitalization: TextCapitalization.sentences,
                onTap: () {
                  var acciones = json.decode(widget.acciones);
                  // var acciones = ['', '', ''];
                  for (var element in acciones) {
                    _actionType.remove(element);
                  }
                },
                onChanged: (comentario) {
                  // print(widget.index);
                  var acciones = json.decode(widget.acciones);
                  // var acciones = ['', '', ''];
                  for (var element in acciones) {
                    _actionType.remove(element);
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'Comentario',
                  icon: Icon(
                    Icons.comment_sharp,
                    color: Colors.black,
                  ),
                  hintMaxLines: 3,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45, width: 2)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: lugar,
                textCapitalization: TextCapitalization.sentences,
                onTap: () {
                  var acciones = json.decode(widget.acciones);
                  // var acciones = ['', '', ''];
                  for (var element in acciones) {
                    _actionType.remove(element);
                  }
                },
                onChanged: (lugar) {
                  // print(widget.index);
                  var acciones = json.decode(widget.acciones);
                  // var acciones = ['', '', ''];
                  for (var element in acciones) {
                    _actionType.remove(element);
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'lugar',
                  icon: Icon(
                    Icons.place,
                    color: Colors.black,
                  ),
                  hintMaxLines: 3,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45, width: 2)),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: accion,
                textCapitalization: TextCapitalization.sentences,
                onTap: () {
                  var acciones = json.decode(widget.acciones);
                  // var acciones = ['', '', ''];
                  for (var element in acciones) {
                    _actionType.remove(element);
                  }
                },
                onChanged: (accion) {
                  // print(widget.index);
                  var acciones = json.decode(widget.acciones);
                  // var acciones = ['', '', ''];
                  for (var element in acciones) {
                    _actionType.remove(element);
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'Descripción de acción inmediata',
                  icon: Icon(
                    Icons.warning,
                    color: Colors.black,
                  ),
                  hintMaxLines: 3,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45, width: 2)),
                ),
              ),

              (fotopreview == '')
                  ? (const Text(''))
                  : (Transform.rotate(
                      angle: 0,
                      child: Transform.scale(
                          scale: 0.70,
                          child: Image.file(
                            File(fotopreview),
                          )))),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('¿Está abierta la incidencia?'),
                  Column(children: [
                    Text(isActive),
                    Switch(
                      value: activeStatus,
                      onChanged: (value) {
                        setState(() {
                          if (activeStatus) {
                            activeStatus = false;
                            isActive = 'No';
                          } else {
                            activeStatus = true;
                            isActive = 'Sí';
                          }
                        });
                      },
                      activeColor: Colors.green,
                    )
                  ])
                ],
              ),
              _dropDownOptions(),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     const Text('¿Es accidente?'),
              //     Column(children: [
              //       Text(accidentText),
              //       Switch(
              //         value: isAccident,
              //         onChanged: (value) {
              //           setState(() {
              //             if (isAccident) {
              //               isAccident = false;
              //               accidentText = 'No';
              //             } else {
              //               isAccident = true;
              //               accidentText = 'Sí';
              //             }
              //           });
              //         },
              //         activeColor: Colors.green,
              //       )
              //     ])
              //   ],
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // capturar foto de la incidencia
                  MaterialButton(
                    onPressed: widget.btnsave
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DisplayPictureScreen(),
                              ),
                            ).then((value) {
                              if (value == null) {
                                if (fotopreview != '') {
                                  print("imagen ${fotopreview}");
                                }
                              } else {
                                fotopreview = value;
                              }

                              // print(widget.index);
                              var acciones = json.decode(widget.acciones);
                              // var acciones = ['', '', ''];
                              for (var element in acciones) {
                                _actionType.remove(element);
                              }
                              setState(() {});
                            });
                          }
                        : (null),
                    color: Colors.amber,
                    elevation: 1,
                    child: Row(
                      children: const [
                        Icon(Icons.camera_alt_sharp),
                        SizedBox(width: 5),
                        Text('Foto'),
                      ],
                    ),
                  ),

                  //eliminar la incidencia
                  MaterialButton(
                    onPressed: widget.btnsave
                        ? () async {
                            fotopreview = '';
                            comentario.text = '';
                            responsable.text = '';

                            for (var element in acciones) {
                              _actionType.remove(element);
                            }
                            setState(() {});
                          }
                        : (null),
                    disabledColor: Colors.red,
                    color: Colors.orange[400],
                    elevation: 1,
                    child: widget.btnsave
                        ? btnload
                            ? const Icon(Icons.delete)
                            : const SizedBox(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  color: Colors.black,
                                ),
                                height: 15,
                                width: 15,
                              )
                        : const Text('Guardado'),
                  ),

                  //guardar la incidencia
                  MaterialButton(
                    onPressed: () async {
                      print(recorrido);
                      print(lugar);
                      LocationPermission permission;

                      permission =
                          await _geolocatorPlatform.requestPermission();
                      final position =
                          await _geolocatorPlatform.getCurrentPosition();

                      // print(widget.usuario);
                      // print(widget.key);

                      // print(widget.lugar);
                      var url = Uri.parse(
                          "${connect.serverName()}crear_incidencia_recorrido.php");
                      //   print("soy yo ${widget.tipo}");
                      Future<void> pedirdatos() async {
                        //     if (widget.tipo == "Recorrido") {
                        String nombre_bd = widget.nombre.replaceAll('[', '');
                        nombre_bd = nombre_bd.replaceAll(']', '');
                        var resultado = await http.post(url, body: {
                          "responsable": "${responsable.text}",
                          "comentario": "${comentario.text}",
                          "imagen": base64Image,
                          "usuario": nombre_bd,
                          "recorrido": widget.recorrido,
                          "tipo_inc": "${accion.text}",
                          "lugar": "${lugar.text}",
                          "longitude": position.longitude.toString(),
                          "latitude": position.latitude.toString(),
                          "status": isActive,
                          "accidente": _opcionSeleccionada
                        });

                        print(resultado.body);
                      }
                      //     } else {
                      //       await http.post(url, body: {
                      //         "comentario": "${comentario.text}",
                      //         "imagen": base64Image,
                      //         "usuario": widget.usuario,
                      //         "recorrido": '-1',
                      //         "tipo_inc": _opcionSeleccionada,
                      //         "lugar": '-1'
                      //       });
                      //     }

                      //     // final List json = jsonDecode(respuesta.body.toString());
                      //   }

                      if (fotopreview != '') {
                        imageBytes = File(fotopreview).readAsBytesSync();
                        base64Image = base64Encode(imageBytes!);
                      } else {
                        base64Image = '';
                      }
                      btnload = false;
                      var acciones = json.decode(widget.acciones);

                      for (var element in acciones) {
                        _actionType.remove(element);
                      }
                      setState(() {});

                      await pedirdatos();
                      btnload = true;

                      for (var element in acciones) {
                        _actionType.remove(element);
                      }
                      fotopreview = '';
                      comentario.text = '';
                      responsable.text = '';
                      accion.text = '';
                      lugar.text = '';
                      isActive = 'No';
                      activeStatus = false;

                      setState(() {});
                    },
                    disabledColor: Colors.greenAccent[400],
                    color: Colors.amber,
                    elevation: 1,
                    child: Row(
                      children: [
                        widget.btnsave
                            ? btnload
                                ? const Icon(Icons.save_sharp)
                                : const SizedBox(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                      color: Colors.black,
                                    ),
                                    height: 15,
                                    width: 15,
                                  )
                            : const Text('Guardado'),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              //menú de acciones
              /*   Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                   _dropDownOptions(),

                  const SizedBox( width: 10 ),

                  const SizedBox(
                    width: 210,
                    height: 60,
                    child: TextField(

                    decoration: InputDecoration(
                    hintText: 'Ingrese un comentario',
                    hintMaxLines: 3,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black45, width: 2)),
                  ),
                    ),
                  )
                  /* */
                 
                 ],
               ),
               */
            ],
          ),
        ),
      ),
    );
  }

//menú de acciones
  Widget _dropDownOptions() {
    return widget.btnsave
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                height: 38,
                decoration: const BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.all(Radius.circular(3.0))),
                child: DropdownButton(
                    value: _opcionSeleccionada,
                    items: getItemsDropDown(),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    dropdownColor: Colors.amber[200],
                    icon: const Icon(
                      Icons.warning_outlined,
                      color: Colors.black,
                      size: 25.0,
                    ),
                    underline: Container(
                      color: Colors.white,
                    ),
                    onChanged: (opt) {
                      _opcionSeleccionada = opt;
                      setState(() {
                        var acciones = json.decode(widget.acciones);

                        for (var element in acciones) {
                          _actionType.remove(element);
                        }
                      });
                    }),
              ),
            ],
          )
        : Row();
  }

  List<DropdownMenuItem<String>> getItemsDropDown() {
    List<DropdownMenuItem<String>> lista = [];

    for (var element in _actionType) {
      lista.add(DropdownMenuItem(
        child: Text(element),
        value: element,
      ));
    }

    return lista;
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
