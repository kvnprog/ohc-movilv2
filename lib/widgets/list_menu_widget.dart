import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recorridos_app/helpers/helpers.dart';
import 'package:recorridos_app/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:recorridos_app/data/conections_data.dart';

class ListMenuItem extends StatefulWidget {
  List<dynamic>? datos;

  ListMenuItem({
    Key? key,
    this.datos,
  }) : super(key: key);

  @override
  State<ListMenuItem> createState() => _ListMenuItemState();
}

class _ListMenuItemState extends State<ListMenuItem> {
  bool checkBoxStatus = false;
  @override
  Widget build(BuildContext context) {
    var index = widget.datos!.getRange(0, widget.datos!.length);
    connect;
    String description;
    String status = 'No disponible';
    String route;

//hora
    List<String> fechaHora = widget.datos![2].toString().split(" ");
    List<String> horaWithouthSeconds = fechaHora[1].split(":");
    String hour = horaWithouthSeconds[0] + ":" + horaWithouthSeconds[1];

//fecha
    List<String> fecha = fechaHora[0].split("-");
    DateConverter dateConverter = DateConverter();
    String convertedDate = dateConverter.convert(fecha);

    for (var date in widget.datos!) {
      // print(date);
    }

    if (widget.datos![3] != null) {
      description =
          'La persona ${widget.datos![0]} registró una incidencia a las $hour el día $convertedDate, en ${widget.datos![1]} poniendo como infractor de la incidencia a ${widget.datos![3]}, declarando que: ${widget.datos![8]}.';
    } else {
      description =
          'La persona ${widget.datos![0]} registró una incidencia a las $hour el día $convertedDate, en ${widget.datos![1]}, declarando que: ${widget.datos![8]}.';
    }

    if (widget.datos![4] == 'Sí') {
      status = 'Abierta';
    } else {
      status = 'Cerrada';
    }

    if (widget.datos![7] == null || widget.datos![7] == '') {
      route = 'false';
    } else {
      route = widget.datos![7];
    }

    List<String> shortName = widget.datos![0].toString().split(" ");

    return GestureDetector(
      onTap: () {
        // print(widget.datos![7]);
        connect.dialog(
            context, 'Descripción de la incidencia', description, route);
      },
      child: Container(
        width: double.infinity,
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.grey[600],
            borderRadius: const BorderRadius.all(Radius.circular(15.0))),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                //parte izquierda
                const Image(
                    image: AssetImage('assets/file.png'),
                    width: 60,
                    color: Colors.blue),

                const SizedBox(width: 10),
                //parte derecha
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Tipo: ${widget.datos![9]}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Responsable: ${widget.datos![3]}',
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Lugar: ${widget.datos![1]}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[200],
                      ),
                    ),
                    Text(
                      'Fecha: ${fechaHora[0]}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[200],
                      ),
                    ),
                    Text(
                      'Hora: $hour',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[200],
                      ),
                    ),

                    Row(
                      children: [
                        Text(
                          'Status: $status',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[200],
                          ),
                        ),
                        (status == 'Cerrada')
                            ? Text('')
                            : Checkbox(
                                value: checkBoxStatus,
                                fillColor:
                                    MaterialStateProperty.all(Colors.blue),
                                onChanged: (val) async {
                                  // print(checkBoxStatus);
                                  var url = Uri.parse(
                                      "${connect.serverName()}cerrar_incidencia.php");
                                  var respuesta = await http.post(url,
                                      body: {"index": widget.datos![10]});
                                  print(respuesta.body);
                                  setState(() {
                                    checkBoxStatus = true;
                                    widget.datos![4] = 'No';
                                  });
                                })
                      ],
                    ),

                    Text(
                      'Captura: ${shortName[0]} ${shortName[1]}',
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontSize: 15,
                      ),
                    ),
                    //la ubicación es: long datos![5] y lat datos![6]
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
