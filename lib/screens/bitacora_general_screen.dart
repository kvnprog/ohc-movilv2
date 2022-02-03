import 'package:flutter/material.dart';
import 'package:recorridos_app/widgets/widgets.dart';

class BitacoraGeneral extends StatelessWidget {
  List names = ["", "", "", ""];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora general'),
      ),
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (BuildContext context, index){
          return ListBitacoraWidget();
        },
      
      ),
    );
  }
}