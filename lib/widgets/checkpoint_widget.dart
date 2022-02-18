import 'package:flutter/material.dart';

class CheckPointWidget extends StatefulWidget {
  CheckPointWidget({Key? key}) : super(key: key);

  @override
  State<CheckPointWidget> createState() => _CheckPointWidgetState();

  Color color = Colors.green;
}

class _CheckPointWidgetState extends State<CheckPointWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
            child: Container(
              margin: const EdgeInsets.all(30),
              width: 350,
              height: 350,
              child: Material(
                shadowColor: Colors.amber,
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                child: Column(
                  children: [

                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 40),
                      child: const Text(
                        'Crear CheckPoint',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            textBaseline: null,
                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    //comentario
                    Container(
                      margin: const EdgeInsets.all(18),
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        onTap: () {},
                        onChanged: (responsable) {},
                        decoration: const InputDecoration(
                          hintText: 'Comentario',
                          hintMaxLines: 3,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black45, width: 2)),
                        ),
                      ),
                    ),

                    //lugar
                    Container(
                      margin: const EdgeInsets.all(18),
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        onTap: () {},
                        onChanged: (responsable) {},
                        decoration: const InputDecoration(
                          hintText: 'Lugar',
                          hintMaxLines: 3,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black45, width: 2)),
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MaterialButton(
                            color: Colors.amber,
                            child: Text(
                              'Foto'.toUpperCase(),
                              style: const TextStyle(color: Colors.black),
                            ),
                            onPressed: () {}),

                        MaterialButton(
                            color: Colors.greenAccent[400],
                            child: Text(
                              'Guardar'.toUpperCase(),
                              style: const TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              setState(() {});
                              
                            })
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
