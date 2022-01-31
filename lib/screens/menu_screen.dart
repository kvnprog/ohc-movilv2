import 'package:flutter/material.dart';
import 'package:recorridos_app/data/places_array_data_class.dart';
import 'package:recorridos_app/screens/screens.dart';
import 'package:recorridos_app/screens/list_bitacora_inicio.dart';
import 'package:recorridos_app/widgets/btnpoint.dart';
import 'package:recorridos_app/widgets/list_widget.dart';
import 'package:recorridos_app/widgets/widgets.dart';

class MenuHome extends StatelessWidget {
  final String acciones;
  final String? usuario;
  dynamic nombre;
  PlacesArrayAvailableData? dataList;
  MenuHome(
      {Key? key,
      required this.acciones,
      this.usuario,
      this.dataList,
      required this.nombre})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Main Home Menu',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
          ),
          drawer: Drawer(
            backgroundColor: Colors.grey[800],
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            _userIcon(nombre),
                            IconButton(
                                onPressed: () =>
                                    Navigator.of(context).pop('login'),
                                icon: const Icon(
                                  Icons.login_outlined,
                                  color: Colors.black,
                                  size: 30,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nombre[0].toString(),
                                  style: TextStyle(fontSize: 25),
                                ),
                                Text(
                                  'Bienvenido',
                                  style: TextStyle(color: Colors.grey[800]),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    )),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  style: ListTileStyle.list,
                  focusColor: Colors.grey[600],
                  iconColor: Colors.grey[600],
                  minLeadingWidth: 2.0,
                  textColor: Colors.white,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => MenuHome(
                              acciones: acciones,
                              nombre: nombre,
                              dataList: dataList,
                              usuario: usuario,
                            )));
                  },
                ),
                const Divider(
                    height: 10, color: Colors.white, indent: 10, endIndent: 10),
                const SizedBox(height: 30),
                ListTile(
                  leading: const Icon(Icons.place),
                  title: const Text('Lugares'),
                  style: ListTileStyle.list,
                  focusColor: Colors.grey[600],
                  iconColor: Colors.red,
                  minLeadingWidth: 2.0,
                  textColor: Colors.white,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => HomeToursScreen(
                              acciones: acciones,
                              usuario: usuario,
                              dataList: dataList,
                            )));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.file_copy_sharp),
                  title: const Text('Incidencias'),
                  style: ListTileStyle.list,
                  focusColor: Colors.grey[600],
                  iconColor: Colors.white60,
                  minLeadingWidth: 2.0,
                  textColor: Colors.white,
                  selectedTileColor: Colors.grey[600],
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ListWidget()));
                  },
                ),
              ],
            ),
          ),
          body: Center(
            child: BitacoraInicio(),
          )),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[850],
        appBarTheme: const AppBarTheme(backgroundColor: Colors.amber),
      ),
    );
  }

  Widget _userIcon(dynamic mNombre) {
    String userName = mNombre[0].toString();
    var cheepName = userName.split(" ");
    return Container(
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
                child: Text('${cheepName[0][0]}${cheepName[1][0]}')),
          ),
        ),
      ),
    ));
  }
}
