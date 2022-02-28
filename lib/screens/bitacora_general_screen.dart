import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:recorridos_app/screens/screens.dart';
import 'package:recorridos_app/widgets/list_widget.dart';
import 'package:recorridos_app/widgets/widgets.dart';
import 'package:http/http.dart' as http;

Map? arrayrespaldo;
bool cargar = true;
List<dynamic> arrayfinal = [];

class BitacoraGeneral extends StatefulWidget {
  List userArray;
  String user;
  dynamic userName;
  String? codigo;

  BitacoraGeneral(
      {required this.userArray,
      required this.userName,
      required this.user,
      this.codigo});

  @override
  State<BitacoraGeneral> createState() => _BitacoraGeneralState();

  dynamic nameValue;
  dynamic hourValue;

  dynamic isOne(int index) {
    switch (index) {
      case 0:
        {
          return nameValue;
        }
      case 1:
        {
          return hourValue;
        }
    }
  }
}

class _BitacoraGeneralState extends State<BitacoraGeneral> {
  ConectionData connect = ConectionData();

  @override
  void dispose() {
    // TODO: implement dispose
    cargar = true;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    List<String> userInfo = [];

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
        title: const Text('Bitácora de actividades'),
      ),
      body: FutureBuilder(
          future: bitacora(),
          builder: (context, snapshot) {
            List<dynamic> usuarios = [];
            if (snapshot.hasData) {
              // print(snapshot.data);
              if (cargar) {
                arrayfinal = jsonDecode(snapshot.data.toString());
                // arrayrespaldo = arrayfinal;
                cargar = false;
              }
              
              for(var values in arrayfinal){
                print(values);
                if(usuarios.isNotEmpty){
                  (!usuarios.contains(values['7'])) ? usuarios.add(values['7']) : '';
                }else{
                  usuarios.add(values['7']);
                }
              }

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
                          filterWidget(opcion1, filtro1, 0, 'Nombre', usuarios),
                          const SizedBox(width: 20),
                          filterWidget(opcion2, filtro2, 0, 'Hora',
                          [1, 2, 8, 12, 24, 48, 72]),
                        ],
                      ),
                    )),
                   
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          for(var value in arrayfinal)
                          IncidencesClass(
                            incidenceID: value['0'], codeCellPhone: value['6'],
                            dateTime: value['1'], userName: value['2'], typeIncidence: value['3'],
                            status: value['5'], incomings: value['8'], nameWorker: value['7']
                          ).getListData
                        ],
                      ),
                    )
                ],
              );
             
            } else {
              return Center(
                  child: Image.asset(
                'assets/loading-38.gif',
                color: Colors.white,
              ));
            }
          }),
    );
  }

  Widget textGenerator(List arrayList, int index) {
    List mArray = arrayList[index]['actividad'];
    final checkPointList = mArray[0]['checkpoint'] as List;
    final incidencesList = mArray[1]['incidence'] as List;
    List finalList = [];

    for (var checkItem in checkPointList) {
      String hora = checkItem['hora'];
      finalList.add('Realizó un checkPoint a las $hora hrs.');
    }

    for (var incidenceItem in incidencesList) {
      String hora = incidenceItem['hora'];
      String lugar = incidenceItem['lugar'];
      finalList.add('Realizó una incidencia en $lugar a las $hora hrs.');
    }

    return ListView(
      children: [
        for (var item in finalList)
          Container(
              margin: const EdgeInsets.all(8),
              child: Text(
                item,
                style: const TextStyle(fontSize: 15),
              ))
      ],
    );
  }

  dynamic filtro1;

  dynamic filtro2;

  int opcion1 = 0;
  int opcion2 = 1;

  Widget filterWidget( int opcion, var filterName, int index, String filterTitle, List<dynamic> datos) {
    // print('yo soy el filtro $filterName');

    List<dynamic> mList = [widget.nameValue, widget.hourValue];
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Text(
            filterTitle,
            style: const TextStyle(color: Colors.white),
          ),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: const BorderRadius.all(Radius.circular(3))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  ClipRect(
                    child: DropdownButton<String>(
                        value: mList[opcion],
                        items: getItemsDropDown(datos, filterName, opcion),
                        //items: getItemsDropDown(index, filterTitle),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        dropdownColor: Colors.blue[200],
                        icon: const Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Colors.black,
                        ),
                        underline: Container(
                          color: Colors.white,
                        ),
                        onChanged: (opt) {
                          // print(opt);
                          switch (opcion) {
                            case 0:
                              Map<dynamic, dynamic> arrayfiltro = Map();
                              arrayfiltro['entradas'] = List<dynamic>;

                              print('soy el arrayfiltro $arrayfiltro');

                              List<dynamic> datos = [];
                              // arrayfiltro = arrayrespaldo!;
                              widget.nameValue = opt;
                              for (var valor in arrayfinal) {
                                if (valor['7'] == opt) {
                                  datos.add(valor);
                                }
                              }

                              arrayfiltro['entradas'] = datos;
                              // arrayfinal = arrayfiltro;
                              print('soy el arrayfiltro tra vez $arrayfiltro');

                              setState(() {});
                              break;

                            case 1:
                              Map<dynamic, dynamic> arrayfiltro = Map();
                              arrayfiltro['entradas'] = List<dynamic>;
                              List<dynamic> datos = [];
                              DateTime dia = DateTime.now();
                              widget.hourValue = opt;
                              // print(DateTime.now());
                              DateTime diasdespues = dia
                                  .subtract(Duration(hours: int.parse(opt!)));
                              for (var valor in arrayrespaldo!['entradas']) {
                                DateTime dia2 = DateTime.parse(valor[2]);
                                print(
                                    "primero ${diasdespues.microsecondsSinceEpoch}");
                                print("despues ${dia2.microsecondsSinceEpoch}");
                                if (diasdespues.microsecondsSinceEpoch <
                                    dia2.microsecondsSinceEpoch) {
                                  datos.add(valor);
                                }
                              }

                              arrayfiltro['entradas'] = datos;
                              // arrayfinal = arrayfiltro;
                              print(arrayfinal);
                              setState(() {});

                              break;
                          }
                          // print(arrayrespaldo!['entradas']);
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> getItemsDropDown(List<dynamic> datos, String context, int opcion) {
    dynamic mValue = 'Todos';

    List<DropdownMenuItem<String>> itemsAvailable = [];
    print(datos);
    datos.forEach((element) {

      // switch (context) {
      //   case 'Nombre':
      //     {
      //       mValue = element[0];
      //     }
      //     break;

      //   case 'Hora':
      //     {
      //       mValue = element.toString();
      //     }
      //     break;
      // }

      itemsAvailable.add(DropdownMenuItem(
          child: opcion == 1 ? Text('${element.toString()} horas') : Text(element.toString()),
          value: element.toString()));
    });

    return itemsAvailable;
  }
}

class IncidencesClass{
  
  String incidenceID;
  String codeCellPhone;
  String dateTime;
  String userName;
  String typeIncidence;
  String status;
  String nameWorker;
  String incomings;

  IncidencesClass({
    required this.incidenceID,
    required this.codeCellPhone,
    required this.dateTime,
    required this.userName,
    required this.typeIncidence,
    required this.status,
    required this.incomings,
    required this.nameWorker,
    
  });

  //this method is to know the type incidence and convert in String
  Widget convertionData(){
     List<String> extractDateType = dateTime.split(" ");

    //hour
    String hour = extractDateType[1];
    List<String> simpleHour = hour.split(':');

    //date
    String date = extractDateType[0]; 

    switch (typeIncidence) {
      case 'IS':
        return Column(
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),

                Text('Inició Sesión el $date a las ${simpleHour[0]}:${simpleHour[1]}', style: 
                const TextStyle(
                  color: Colors.white,
                  fontSize: 18
                ),
                maxLines: null,
                softWrap: true,
                ),
              ],
            )
          ],
        );
      
      case 'FS':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider( height: 20, color: Colors.white, thickness: 2,),
            Center(child: Text(nameWorker, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center)),
            const SizedBox( height: 18, ),

            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),

                SizedBox(
                  width: 260,
                  child: Text('Finalizó Sesión el $date a las ${simpleHour[0]}:${simpleHour[1]}', style: 
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  )),
                )
              ],
            ),
          ],
        );

      case 'I':
      return Row(
        children: [

          Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(20)
            ),
          ),

          SizedBox(
            width: 260,
            child: Text('Levantó una Incidencia a las ${simpleHour[0]}:${simpleHour[1]}', style: 
            const TextStyle(
              color: Colors.white,
              fontSize: 18
            )),
          )  
        ],
      );
      case 'C':
      return Row(
        children: [

          Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20)
            ),
          ),

          SizedBox(
            width: 260,
            child: Text('Levantó un CheckPoint a las ${simpleHour[0]}:${simpleHour[1]}', style: 
            const TextStyle(
              color: Colors.white,
              fontSize: 18
            )),
          )  
        ],
      );

      case 'TC':
      return Row(
        children: [

          Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20)
            ),
          ),

          SizedBox(
            width: 260,
            child: Text('Levantó una Incidencia tipo COVID-19 a las ${simpleHour[0]}:${simpleHour[1]}', style: 
            const TextStyle(
              color: Colors.white,
              fontSize: 18
            )),
          )  
        ],
      );

      case 'AC':
      return Row(
        children: [

          Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(20)
            ),
          ),

          SizedBox(
            width: 260,
            child: Text('Levantó una Auditoría en comedor a las ${simpleHour[0]}:${simpleHour[1]}', style: 
            const TextStyle(
              color: Colors.white,
              fontSize: 18
            )),
          )  
        ],
      );

      default: return const Text('No disponible.', style: 
      TextStyle(
        color: Colors.white,
        fontSize: 18
      ));
    }
  }

  get getListData{
    Widget incidencesDescription;
    
    incidencesDescription = Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          convertionData()
        ],
      ),
    );

    return incidencesDescription;
  }

}