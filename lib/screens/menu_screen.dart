import 'package:flutter/material.dart';
import 'package:recorridos_app/screens/screens.dart';
import 'package:recorridos_app/screens/list_bitacora_inicio.dart';
import 'package:recorridos_app/widgets/btnpoint.dart';
import 'package:recorridos_app/widgets/list_widget.dart';
import 'package:recorridos_app/widgets/widgets.dart';

class MenuHome extends StatelessWidget {
  final String acciones;
  final String? usuario;
  const MenuHome({Key? key, required this.acciones, this.usuario})
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
                            _userIcon(),

                             IconButton(
                              onPressed: () => Navigator.of(context).pop('login'),
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
                                  'Ángel Romano',
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

                
                /*ListTile(
                  leading: const Icon(Icons.upload_file),
                  title: const Text('Registrar incidencia'),
                  style: ListTileStyle.list,
                  focusColor: Colors.grey[600],
                  iconColor: Colors.white60,
                  minLeadingWidth: 2.0,
                  textColor: Colors.white,
                  selectedTileColor: Colors.grey[600],
                  onTap: () {},
                ), */

                
              ],
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ShortCutAccess(
                    shortcutTitle: 'Ver incidencias de últimas 24 hrs.',
                    shortcutIcon: Icons.file_copy_outlined,
                    widgetsListActions: [
                      ListTile(
                        leading:
                            const Icon(Icons.remove_red_eye_outlined, size: 20),
                        title: const Text('Ver incidencias'),
                        style: ListTileStyle.list,
                        focusColor: Colors.white,
                        iconColor: Colors.white,
                        minLeadingWidth: 2.0,
                        textColor: Colors.black,
                        selectedTileColor: Colors.white,
                        selectedColor: Colors.amber,
                        onTap: () {
                          print('soy el objeto');
                        },
                      ),
                    ],
                  ),
                  //BtnPoint(),
                ],
              ),
            ),
          )),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[850],
        appBarTheme: const AppBarTheme(backgroundColor: Colors.amber),
      ),
    );
  }

  Widget _userIcon() {
    print(usuario);
    String userName = usuario.toString();
    List<String> cheepName = userName.split("");
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
                child: Text('AR')),
          ),
        ),
      ),
    ));
  }
}

class Contacto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CONTACTO"),
      ),
      body: Center(
        child: Text("ESTAS EN CONTACTO"),
      ),
    );
  }
}
