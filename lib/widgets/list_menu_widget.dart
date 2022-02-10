import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recorridos_app/widgets/widgets.dart';

class ListMenuItem extends StatelessWidget {
  List<dynamic>? datos;

  ListMenuItem({
    Key? key,
    this.datos,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var index = datos!.getRange(0, datos!.length);
    connect;
    String description;
    String status = 'No disponible';
    String route;

    if(datos![3] != null){
      description =  
      'La persona ${datos![0]} registró una incidencia a las ${datos![2]} en ${datos![1]} poniendo como infractor de la incidencia a ${datos![3]}, declarando que: ${datos![8]}.';
    }else{
      description =  'La persona ${datos![0]} registró una incidencia a las ${datos![2]} en ${datos![1]}, declarando que: ${datos![8]}.';
    }

    if(datos![4] == 'Sí' || datos![4] == 'Si'){
      status = 'Abierta';
    }else{
      status = 'Cerrada';
    }

    if(datos![7] == null || datos![7] == ''){
      route = 'false';
    }else{
      route = datos![7];
    }
    
    return GestureDetector(
      onTap: (){
        print(datos![7]);
        connect.dialog( context, 'Descripción de la incidencia', description, route);
      },
      child: Container(
        width: double.infinity,
        height: 150,
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
                    color: Colors.amber),
    
                const SizedBox(width: 10),
                //parte derecha
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Captura: ${datos![0]}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Responsable: ${datos![3]}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[200],
                      ),
                    ),
                    Text(
                      'Lugar: ${datos![1]}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[200],
                      ),
                    ),
                    Text(
                      'Fecha y Hora: ${datos![2]}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[200],
                      ),
                    ),
                    Text(
                      'Status: $status',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[200],
                      ),
                    ),
                    Text(
                      'Ubicación: ${datos![5]},${datos![6]}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[200],
                      ),
                    ),
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
