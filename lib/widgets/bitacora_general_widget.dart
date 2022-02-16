import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recorridos_app/helpers/helpers.dart';
import 'package:recorridos_app/screens/screens.dart';

class ListBitacoraWidget extends StatefulWidget {
  ListBitacoraWidget(
      {Key? key,
      // required this.user,
      required this.userName,
      required this.start,
      required this.end,
      required this.incidencias,
      required this.checkpoint
      // required this.contentActivity
      })
      : super(key: key);

  String start;
  String end;
  // String user;
  dynamic incidencias;
  dynamic userName;
  dynamic checkpoint;
  // Widget contentActivity;
  @override
  State<ListBitacoraWidget> createState() => _ListBitacoraWidgetState();

  DateConverter dateConverter = DateConverter();
}

class _ListBitacoraWidgetState extends State<ListBitacoraWidget> {
  double height = 110;
  
  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: const EdgeInsets.all(8),
      width: 50,
      height: height,
      decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              widget.userName.toString(),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Column(
            children: [
              sesionActivity('start', widget.start),
              sesionActivity('end', widget.end),
              IconButton(
                onPressed: () {
                  print(widget.incidencias);
                  setState(() {
                    height == 110 ? height = 300 : height = 110;
                  });
                },
                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                splashRadius: 20.0,
              )
            ],
          ),
          if (height == 300)
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Actividad en la app',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const Divider(
                    height: 10, color: Colors.white, indent: 5, endIndent: 5),
                SizedBox(
                    height: 150,
                    child: ListView(
                      children: [
                        for (var incidence in widget.incidencias)
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, bottom: 8.0),
                            child: Text('${widget.userName.toString().toLowerCase()} levantó una incidencia en ${incidence['lugar']} a las ${getSimpleHour(incidence['fechahora'])}',
                              style: const TextStyle(
                                fontSize: 18
                              ),
                            ),
                          ),

                        for (var checkpoint in widget.checkpoint)
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, bottom: 8.0),
                            child: Text('${widget.userName.toString().toLowerCase()} realizo un checkpoint', style: const TextStyle(
                              fontSize: 18
                            ),),
                          )
                      ],
                    ))
              ],
            )
        ],
      ),
    );
  }

  String getSimpleHour(String simpleDate){
      DateDataConvert dateDataConvert = DateDataConvert(dateFormat: simpleDate);

      return dateDataConvert.hourData;
  }


  Widget sesionActivity(String context, String value) {
    late Color color;
    late String title;
    DateDataConvert dateDataConvert = DateDataConvert(dateFormat: value);

    String textValue = 'nulo';

    if (context == 'start') {
      color = Colors.lightGreenAccent[400]!;
      title = 'Inició sesión';
    } else {
      color = Colors.black;
      title = 'Finalizó sesión';
    }

    if (value != null) {
      textValue =
          '$title: ${dateDataConvert.dateData} a las ${dateDataConvert.hourData}';
    } else {
      textValue = '$title: No disponible';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 3),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(50)),
          ),
          Text(textValue)
        ],
      ),
    );
  }

}

class DateDataConvert {
  String dateFormat;

  DateDataConvert({required this.dateFormat});

  final DateConverter _dateConverter = DateConverter();

  get dateData {
    if (dateFormat != null) {
      List<String> dateComplete = dateFormat.split(" ");
      List<String> fecha = dateComplete[0].split("-");

      return _dateConverter.convert(fecha);
    } else {
      return 'null';
    }
  }

  get hourData {
    if (dateFormat != null) {
      List<String> dateComplete = dateFormat.split(" ");
      List<String> hora = dateComplete[1].split(":");
      String hour = hora[0] + ':' + hora[1];

      return hour;
    } else {
      return null;
    }
  }
}
