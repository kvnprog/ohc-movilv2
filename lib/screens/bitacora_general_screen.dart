import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:recorridos_app/screens/screens.dart';
import 'package:recorridos_app/widgets/list_widget.dart';
import 'package:recorridos_app/widgets/widgets.dart';
import 'package:http/http.dart' as http;

class BitacoraGeneral extends StatefulWidget {
  List userArray;
  String user;
  dynamic userName;
  String? codigo;


  BitacoraGeneral(
    {required this.userArray,
      required this.userName,
      required this.user,
      this.codigo
    });

  @override
  State<BitacoraGeneral> createState() => _BitacoraGeneralState();

  dynamic nameValue;
  dynamic hourValue;
  
  dynamic isOne(int index){
    switch(index){
      case 0: {
        return nameValue;
      }
      case 1: {
        return hourValue;
      }
    }
  }
}

class _BitacoraGeneralState extends State<BitacoraGeneral> {
  ConectionData connect = ConectionData();
  
  @override
  Widget build(BuildContext context) {
    dynamic filtro1;
    dynamic filtro2;
  
    Future<String> bitacora() async {
      var url = Uri.parse("${connect.serverName()}traer_bitacora.php");
      var resultado = await http.post(url, body: {"codigo": widget.codigo});

      return resultado.body;
    }

    Future<String> usuarios() async {
      var url = Uri.parse("${connect.serverName()}traer_usuarios.php");
      var resultado = await http.post(url, body: {"codigo": widget.codigo});

      return resultado.body;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora general'),
      ),
      body: FutureBuilder(
          future: bitacora(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map arrayfinal = jsonDecode(snapshot.data.toString());
              // print(snapshot.data);
              // print(arrayfinal['entradas']);

              return FutureBuilder(
                  future: usuarios(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // print(snapshot.data);
                      List<dynamic> usuarios = jsonDecode(snapshot.data.toString());

                      return Column(
                        children: [
                          SizedBox(
                              height: 100,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  children: [
                                    //filterWidget(filtro1, 0, 'Nombre', usuarios, 0),
                                    const SizedBox(width: 20),
                                    //filterWidget(filtro2, 0, 'Hora', [1, 2, 8, 12, 24, 48, 72], 1),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 600,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: arrayfinal['entradas'].length,
                              itemBuilder: (BuildContext context, index) {
                                // print(snapshot.data);

                                // return Text("${arrayfinal['entradas'][index]}");
                                return ListBitacoraWidget(
                                  // user: user,
                                  userName: arrayfinal['entradas'][index][5],
                                  start: arrayfinal['entradas'][index][2],
                                  end: arrayfinal['entradas'][index][3],
                                  incidencias: arrayfinal['entradas'][index][4],
                                  // contentActivity: textGenerator(arrayList, index),
                                );
                              },
                              reverse: true,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  });
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  
  }

}
