import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:recorridos_app/data/data.dart';
import 'package:recorridos_app/screens/home_screen.dart';

class BtnPoint extends StatefulWidget {
  String? recorrido;
  BtnPoint({Key? key, this.recorrido}) : super(key: key);

  @override
  State<BtnPoint> createState() => _BtnPointState();
}

class _BtnPointState extends State<BtnPoint> {
  bool btnnull = false;
  ConectionData connect = ConectionData();


  final comentario = TextEditingController();

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        decoration:  BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  //botón de checkpoint
                  Container(
                    child: FloatingActionButton(
                      onPressed: btnnull
                          ? null
                          : () async {
                              // final serviceStatusStream =
                              //     _geolocatorPlatform.getServiceStatusStream();
                              LocationPermission permission;
                              btnnull = true;
                              setState(() {});
                              permission =
                                  await _geolocatorPlatform.requestPermission();
                              final position =
                                  await _geolocatorPlatform.getCurrentPosition();
                              var url = Uri.parse(
                                  "${connect.serverName()}check_point.php");
                              //   print("soy yo ${widget.tipo}");

                              //     if (widget.tipo == "Recorrido") {
                              await http.post(url, body: {
                                "recorrido": recorrido.toString(),
                                "latitude": position.latitude.toString(),
                                "longitude": position.longitude.toString(),
                                "comentario": comentario.text
                              });

                              btnnull = false;
                              setState(() {});
                              print(recorrido);
                              print(position);
                            },
                      backgroundColor: btnnull ? Colors.grey : Colors.amber,
                      child: btnnull
                          ? const Icon(Icons.block_outlined)
                          : const Icon(Icons.flag),
                    ),
                  ),

                  const SizedBox(width: 10),

                  //caja de comentario de la acción
                  SizedBox(
                    width: 250,
                    height: 60,
                    child: TextField(
                      controller: comentario,
                      decoration: InputDecoration(
                        hintText: 'Comentario checkpoint',
                        hintStyle: const TextStyle(color: Colors.grey),
                        hintMaxLines: 3,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[350]!),
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 2)),
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 30,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    color: Colors.amber,
                    child: const Text('Foto'),
                    onPressed: (){
                    
                  }),

                  MaterialButton(
                    color: Colors.green,
                    child: const Text('Guardar'),
                    onPressed: (){

                  })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
