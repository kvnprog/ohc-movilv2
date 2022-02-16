import 'package:flutter/material.dart';
import 'package:recorridos_app/data/places_array_data_class.dart';
import 'package:recorridos_app/screens/screens.dart';
import 'package:recorridos_app/widgets/list_widget.dart';
import 'package:recorridos_app/widgets/widgets.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:http/http.dart' as http;


class MainClass extends StatefulWidget {
  final String? acciones;
  final String? usuario;
  PlacesArrayAvailableData? dataList;
  final String? entrada;
  final String? codigo;
  dynamic nombre;

  MainClass({
    Key? key,
    this.acciones,
    this.usuario,
    this.dataList,
    this.nombre,
    this.entrada,
    this.codigo,
  }) : super(key: key);

  @override
  State<MainClass> createState() => _MainClassState();

  double width = 20.0;
  double height = 100.0;

  ConectionData conectionData = ConectionData();
}

class _MainClassState extends State<MainClass> {
  List userArray = ["uno", "dos", "tres", "cuatro"];
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Home',
        home: Scaffold(
          appBar: AppBar(
            actions: [
              Row(
                children: [
                  const Text('Salir', style: TextStyle(color: Colors.black),),

                  IconButton(
                      onPressed: () async {
                           var url = Uri.parse(
                        "${widget.conectionData.serverName()}crear_salida.php");
                        var entrada = await http.post(url,
                        body: {'index': widget.entrada});
                        print(entrada.body);
                        Navigator.of(context).pop('login'); 

                      },
                        icon: const Icon(
                        Icons.logout,
                        color: Colors.black,
                        size: 30,
                      )),
                ],
              ),
            ],
            title: const Text('Home'),
          ),
          body: Stack (
            children: [
           
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Column(
                        children: const [
                          Icon(
                            Icons.place,
                            size: 65,
                            color: Colors.red,
                          ),
                          Text(
                            'Ubicaciones',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          )
                        ],
                      ),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return HomeToursScreen(
                            isFromMenu: true,
                            acciones: widget.acciones,
                            usuario: widget.usuario,
                            nombre: widget.nombre[0],
                            dataList: widget.dataList,
                            entrada: widget.entrada);
                      })),
                    ),
                    
                    GestureDetector(
                      child: Column(
                        children: const [
                          Icon(Icons.file_copy, size: 65, color: Colors.white),
                          Text(
                            'Bitácora de incidencias',
                            overflow: TextOverflow.visible,
                            softWrap: false,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => ListWidget(
                                  codigo: widget.codigo,
                                )));
                      },
                    ),
                    
                    GestureDetector(
                      child: Column(
                        children: const [
                          Icon(
                            Icons.file_present_rounded,
                            size: 65,
                            color: Colors.white,
                          ),
                          Text(
                            'Bitácora de actividades',
                            overflow: TextOverflow.ellipsis,
                            maxLines: null,
                            semanticsLabel: '...',
                            textWidthBasis: TextWidthBasis.parent,
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => BitacoraGeneral(
                                userArray: userArray,
                                user: widget.usuario.toString(),
                                userName: widget.nombre,
                                codigo: widget.codigo
                                //codigo: widget.codigo
                                )));
                      },
                    ),
                  
                  ],
                ),
              ),
            
              GestureDetector(
                onTap: (){
                  setState(() {
                    if(widget.width == 20){
                      widget.width = 350;
                      widget.height = 800;
                    }else{
                      widget.width = 20;
                      widget.height = 100;
                    }
                  });
                },
    
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn,
                    alignment: Alignment.centerRight,
                    width: widget.width,
                    height: widget.height,
                    decoration: const BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), topRight: Radius.circular(20))
                    ),
                    child: const Icon(Icons.arrow_forward_ios_sharp),
                  ),
                ),
              ),
    
              if(widget.width == 350)
              FutureBuilder(
                future: Future.delayed(const Duration(seconds: 1)),
                builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return interactionMenuWidget();
                }else{
                  return const Text('');
                }
              })
            
            ],
          ),
        ),
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.grey[850],
            appBarTheme: const AppBarTheme(backgroundColor: Colors.amber),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.amber)),
      ),
    );
  }

  Widget interactionMenuWidget(){
    return AnimatedContainer(
        duration: const Duration(seconds: 10),
        curve: Curves.fastOutSlowIn,
        margin: const EdgeInsets.only(left: 10),
        width: 320,
        child: ListView(
        shrinkWrap: true,
        children: [
          InteractionMenu(
            nombre: widget.nombre[0],
            acciones: widget.acciones!, 
            isNewMenuRequest: true, 
            btnsave: true, 
            tipo: "1", 
            func: (){
              setState(() {});
            }),
        ],
      ),
    );
            
  }
}