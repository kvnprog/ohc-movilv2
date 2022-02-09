import 'package:flutter/material.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:recorridos_app/data/places_array_data_class.dart';
import 'package:recorridos_app/screens/bitacora_general_screen.dart';
import 'package:recorridos_app/screens/screens.dart';
import 'package:recorridos_app/screens/list_bitacora_inicio.dart';
import 'package:recorridos_app/widgets/btnpoint.dart';
import 'package:recorridos_app/widgets/list_widget.dart';
import 'package:recorridos_app/widgets/widgets.dart';
import 'package:http/http.dart' as http;

class MenuHome extends StatefulWidget {
  final String acciones;
  final String? usuario;
  final String? entrada;
  final String? codigo;
  List userArray = ["uno", "dos", "tres", "cuatro"];

  dynamic nombre;
  PlacesArrayAvailableData? dataList;
  MenuHome(
      {Key? key,
      required this.acciones,
      this.usuario,
      this.dataList,
      required this.nombre,
      this.entrada,
      this.codigo})
      : super(key: key);

  ConectionData connect = ConectionData();

  @override
  State<MenuHome> createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MenuHome> {
  int _selectDestination = 0;
  static int selectDrawerIndex = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List name = widget.nombre[0].toString().split(" ");
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: MaterialApp(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                   _userIcon(widget.nombre),
                                      IconButton(
                                          onPressed: () async {
                                            var url = Uri.parse(
                                                "${widget.connect.serverName()}crear_salida.php");
                                            var entrada = await http.post(url,
                                                body: {'index': widget.entrada});
                                            print(entrada.body);
                                            Navigator.of(context).pop('login');
                                          },
                                          icon: const Icon(
                                            Icons.login_outlined,
                                            color: Colors.black,
                                            size: 30,
                                    )),
                                ],
                              ),
                              
                                  Image.asset('assets/logo.png', width: 100, height: 90,)
                            ],
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name[0]+" "+name[1],
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
                    selected: _selectDestination == 0,
                    onTap: () {},
                  ),
                  const Divider(
                      height: 10,
                      color: Colors.white,
                      indent: 10,
                      endIndent: 10),
                  const SizedBox(height: 30),
                  ListTile(
                    leading: const Icon(Icons.place),
                    title: const Text('Lugares'),
                    style: ListTileStyle.list,
                    focusColor: Colors.grey[600],
                    iconColor: Colors.red,
                    minLeadingWidth: 2.0,
                    textColor: Colors.white,
                    selected: _selectDestination == 1,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return HomeToursScreen(
                          acciones: widget.acciones,
                          usuario: widget.usuario,
                          dataList: widget.dataList,
                          entrada: widget.entrada);
                    })),
                  ),
                  ListTile(
                    leading: const Icon(Icons.file_copy_sharp),
                    title: const Text('Bitácora de Incidencias'),
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
                  ListTile(
                    leading: const Icon(Icons.file_present_sharp),
                    title: const Text('Bitácora de actividades'),
                    style: ListTileStyle.list,
                    focusColor: Colors.grey[600],
                    iconColor: Colors.white60,
                    minLeadingWidth: 2.0,
                    textColor: Colors.white,
                    selectedTileColor: Colors.grey[600],
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => BitacoraGeneral(
                              userArray: widget.userArray,
                              user: widget.usuario.toString(),
                              userName: widget.nombre,
                              codigo: widget.codigo)));
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
      ),
    );
  }

  void selectDestination(int index) {
    setState(() {
      _selectDestination = index;
    });
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
