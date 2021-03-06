import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:recorridos_app/data/places_array_data_class.dart';
import 'package:recorridos_app/screens/screens.dart';
import 'package:recorridos_app/services/provider_listener_service.dart';

List<String> fotopreview = ['', '', '', '', '', '', '', '', '', ''];
String resultado = '';
List<int>? imageBytes;
String? base64Image;

class InteractionMenu extends StatefulWidget {
  final String? usuario;
  final String acciones;
  final String? lugar;
  final String? estado;
  final index;
  final recorrido;
  bool btnsave;
  bool isNewMenuRequest;
  String tipo;

  InteractionMenu(
      {Key? key,
      this.lugar,
      this.usuario,
      this.index,
      this.recorrido,
      this.estado,
      required this.acciones,
      required this.isNewMenuRequest,
      required this.btnsave,
      required this.tipo})
      : super(key: key);

  @override
  _InteractionMenuState createState() => _InteractionMenuState();
}

class _InteractionMenuState extends State<InteractionMenu> {
  final comentario = TextEditingController();
  double height = 15;

  bool btnload = true;

  //metodo de traer acciones

  //lista de acciones disponibles
  final List<String> _actionType = [
    'Acción',
  ];

  dynamic _opcionSeleccionada = 'Acción';

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProviderListener>(context, listen: false);
    if (provider.itemIsReady != null) {
      if (widget.isNewMenuRequest && fotopreview[widget.index] != '') {
        fotopreview[widget.index] = '';
      }
    }
  }

  PlacesArrayAvailableData dataList = PlacesArrayAvailableData();

  @override
  Widget build(BuildContext context) {
    var acciones = json.decode(widget.acciones);

    for (var element in acciones) {
      _actionType.add(element);
    }

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProviderListener())],
      child: Container(
        margin: const EdgeInsets.only(bottom: 25, left: 5, right: 5),
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: comentario,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Ingrese un comentario',
                  icon: Icon(
                    Icons.comment_sharp,
                    color: Colors.amber,
                  ),
                  hintMaxLines: 3,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber, width: 2)),
                ),
              ),
              SizedBox(height: height),
              const Divider(),
              (fotopreview[widget.index] == '')
                  ? (const Text(''))
                  : (Transform.rotate(
                      angle: 0,
                      child: Transform.scale(
                          scale: 0.70,
                          child: Image.file(
                            File(fotopreview[widget.index]),
                          )))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /*  //acciones a mostrar
                MaterialButton(
                  onPressed: (){
                    
                  },
                  color: Colors.amber,
                  elevation: 1,
                  child: Row(
                    children: const [
                      Icon(Icons.warning_outlined),
                      SizedBox(width: 5),
                      Text('Acción')
                    ],
                  ),
                ), */
                  _dropDownOptions(),
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
                                if (fotopreview[widget.index] != '') {
                                  print("imagen ${fotopreview[widget.index]}");
                                }
                              } else {
                                fotopreview[widget.index] = value;
                              }

                              print(widget.index);
                              var acciones = json.decode(widget.acciones);

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

                  //guardar la incidencia
                  MaterialButton(
                    onPressed: widget.btnsave
                        ? () async {
                            // print(widget.usuario);
                            // print(widget.key);

                            // print(widget.lugar);
                            var url = Uri.parse(
                                "https://pruebasmatch.000webhostapp.com/crear_incidencia_recorrido.php");
                            print("soy yo ${widget.tipo}");
                            Future<void> pedirdatos() async {
                              if (widget.tipo == "Recorrido") {
                                await http.post(url, body: {
                                  "comentario": "${comentario.text}",
                                  "imagen": base64Image,
                                  "usuario": widget.usuario,
                                  "recorrido": widget.recorrido,
                                  "tipo_inc": _opcionSeleccionada,
                                  "lugar": widget.lugar
                                });
                              } else {
                                await http.post(url, body: {
                                  "comentario": "${comentario.text}",
                                  "imagen": base64Image,
                                  "usuario": widget.usuario,
                                  "recorrido": '-1',
                                  "tipo_inc": _opcionSeleccionada,
                                  "lugar": '-1'
                                });
                              }

                              // final List json = jsonDecode(respuesta.body.toString());
                            }

                            if (fotopreview[widget.index] != '') {
                              imageBytes = File(fotopreview[widget.index])
                                  .readAsBytesSync();
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
                            widget.btnsave = false;

                            for (var element in acciones) {
                              _actionType.remove(element);
                            }

                            setState(() {});
                          }
                        : (null),
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
            ],
          ),
        ),
      ),
    );
  }

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
