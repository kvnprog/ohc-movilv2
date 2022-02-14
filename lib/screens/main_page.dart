import 'package:flutter/material.dart';
import 'package:recorridos_app/screens/screens.dart';
import 'package:recorridos_app/widgets/list_widget.dart';
import 'package:recorridos_app/widgets/widgets.dart';

class MainClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              GestureDetector(
                child: Column(
                  children: const [
                    Icon(Icons.place, size: 65, color: Colors.red,),
              
                    Text('Ubicaciones', style: TextStyle(
                      fontSize: 10,
                      color: Colors.white
                    ),)
                  ],
                ),

                onTap: ()=> Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return HomeToursScreen(
                          isFromMenu: true,

                          //acciones: widget.acciones,
                          //usuario: widget.usuario,
                          //dataList: widget.dataList,
                          //entrada: widget.entrada

                      );
                    })),
              ),

              GestureDetector(
                  child: Column(
                    children: const [
                      Icon(Icons.file_copy, size: 65, color: Colors.white),
                             
                      Text('Bitácora de incidencias',
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
                                //codigo: widget.codigo,
                              )));
                    },
               ),

               GestureDetector(
                child: Column(
                  children: const [
                    Icon(Icons.file_present_rounded, size: 65, color: Colors.white,),
              
                    Text('Bitácora de actividades',
                     overflow: TextOverflow.ellipsis,
                     maxLines: null,
                     semanticsLabel: '...',
                     textWidthBasis: TextWidthBasis.parent,
                     style: TextStyle(
                       fontSize: 10,
                       color: Colors.white
                     ),
                    )
                  ],
                ),

                onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => BitacoraGeneral(
                              userArray: ['Luis', 'Carlos', 'Pepe'],
                              user: 'Carlos',
                              userName: 'Carlos Reynoso',
                              //codigo: widget.codigo
                      )));
                    },
              ),

            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add, color: Colors.black,),
          onPressed: (){
             showDialog(context: context, builder: (context){
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  
                ),
              );
            });
        }),
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[850],
        appBarTheme: const AppBarTheme(backgroundColor: Colors.amber),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.amber
        )
      ),
    );
  }
}