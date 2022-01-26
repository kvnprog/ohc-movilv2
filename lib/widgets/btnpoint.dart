import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class BtnPoint extends StatefulWidget {
  BtnPoint({Key? key}) : super(key: key);

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
                btnnull = false;
                setState(() {});
                print(position);
              },
        backgroundColor: btnnull ? Colors.grey : Colors.amber,
        child:
            btnnull ? const Icon(Icons.block_outlined) : const Icon(Icons.flag),
      ),
    );
  }
}
