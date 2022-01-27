import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:recorridos_app/screens/home_screen.dart';

class BtnPoint extends StatefulWidget {
  String? recorrido;
  BtnPoint({Key? key, this.recorrido}) : super(key: key);

  @override
  State<BtnPoint> createState() => _BtnPointState();
}

class _BtnPointState extends State<BtnPoint> {
  bool btnnull = false;

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FloatingActionButton(
        onPressed: btnnull
            ? null
            : () async {
                // final serviceStatusStream =
                //     _geolocatorPlatform.getServiceStatusStream();
                LocationPermission permission;
                btnnull = true;
                setState(() {});
                permission = await _geolocatorPlatform.requestPermission();
                final position = await _geolocatorPlatform.getCurrentPosition();
                var url = Uri.parse(
                    "https://pruebasmatch.000webhostapp.com/check_point.php");
                //   print("soy yo ${widget.tipo}");

                //     if (widget.tipo == "Recorrido") {
                await http.post(url, body: {
                  "recorrido": recorrido.toString(),
                  "latitude": position.latitude.toString(),
                  "longitude": position.longitude.toString()
                });

                btnnull = false;
                setState(() {});
                print(recorrido);
                print(position);
              },
        backgroundColor: btnnull ? Colors.grey : Colors.amber,
        child:
            btnnull ? const Icon(Icons.block_outlined) : const Icon(Icons.flag),
      ),
    );
  }
}
