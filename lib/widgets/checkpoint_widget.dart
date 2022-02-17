import 'package:flutter/material.dart';

class CheckPointWidget extends StatefulWidget {
  CheckPointWidget({Key? key}) : super(key: key);

  @override
  State<CheckPointWidget> createState() => _CheckPointWidgetState();
}

class _CheckPointWidgetState extends State<CheckPointWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
          child: Container(
            width: 350,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20)
          ),
              child: Material(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 40),
                      child: const Text('Crear CheckPoint', style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      textBaseline: null,
                      fontStyle: FontStyle.normal,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal
                ),
                      textAlign: TextAlign.center,
                  ),
                ),
                        
                    TextField()
                ],
              ),
            
            ),
        ),
  );
  
  }
}

/*Container(
                  child: ClipOval(
        child: Material(
          color: Colors.grey[800],
          child: InkWell(
              splashColor: Colors.white,
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Texto 1',
                        style: const TextStyle(
                            color: Colors.white,
                            decorationColor: Colors.black,
                            fontSize: 12.5),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Texto 2',
                        style: const TextStyle(
                          color: Colors.white,
                          decorationColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return Container(
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: Stack(children: [
                          AlertDialog(
                            title: const Text(
                              'Ingresar con contraseña',
                              textAlign: TextAlign.center,
                            ),
                            content: SizedBox(
                              height: 150,
                              child: Column(
                                children: [
                                  //campo usuario
                                  TextFormField(
                                    autocorrect: false,
                                    decoration: const InputDecoration(
                                      hintText: 'Usuario',
                                      hintMaxLines: 3,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black38),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45, width: 2)),
                                    ),
                                    onChanged: (value){}
                                  ),

                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 180,
                                        height: 60,
                                        child: Column(
                                          children: [
                                            //campo password
                                            TextFormField(
                                                autocorrect: false,
                                                obscureText: true,
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .characters,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Contraseña',
                                                  hintMaxLines: 3,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black38),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .black45,
                                                                  width: 2)),
                                                ),
                                                onChanged: (value){}
                                            ),
                                          ],
                                        ),
                                      ),

                                      IconButton(
                                        iconSize: 20,
                                        onPressed: (){},
                                        icon: const Icon(Icons.login, size: 40),
                                        focusColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                  child: const Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  onPressed: () => Navigator.of(context).pop()),
                            ],
                          ),
                        ]),
                      );
                    });
              }),
        ),
      ),
                ), */