import 'package:flutter/material.dart';
import 'package:recorridos_app/screens/screens.dart';

class ConectionData {
  String serverName() {
    String ssl = 'https://';
    String nossl = 'http://';
    // String serverName = 'pruebasmatch.000webhostapp.com/';
    String serverName = 'www.medicalfil.com/web/php_movil/';
    return ssl + serverName;
  }

  Future dialog(
      BuildContext context, String title, String description, String photoURL
      //List<Widget> imagesArray
      ) {
    return showDialog(
        context: context,
        builder: (context) {
          Widget image = Image(image: NetworkImage(serverName() + photoURL));

          if (photoURL == 'false') {
            image = Container(
                margin: const EdgeInsets.only(top: 100),
                child: const Center(
                    child: Text(
                  'IMAGEN NO DISPONIBLE',
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                )));
          } else {
            image = Image(image: NetworkImage(serverName() + photoURL));
          }

          return Container(
            margin: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              children: [
                //Description space
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                  child: Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 40),
                    child: Text(
                      description,
                      style: const TextStyle(fontSize: 17),
                    )),

                //Images content space
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                  height: 300,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      const Text(
                        'Evidencias',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 20),
                      ),
                      //delete this line
                      Center(child: image)
                    ],
                  ),
                ),

                //Buttons space
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Colors.amber,
                        child: Text('Cerrar'.toUpperCase()),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
