// ignore_for_file: avoid_unnecessary_containers

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:recorridos_app/data/places_array_data_class.dart';
import 'package:path/path.dart';
import 'package:recorridos_app/providers/login_form_provider.dart';
import 'package:recorridos_app/ui/input_decorations.dart';
import 'package:recorridos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recorridos_app/screens/screens.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import 'package:get_mac/get_mac.dart';

bool? checar;
bool activobtn = false;
var respuesta;
bool cargando = false;
List<dynamic> datosnombres = [];
int nombresn = 0;
ConectionData connect = ConectionData();

class LoginScreen extends StatelessWidget {
  String? codigo;
  LoginScreen({Key? key, this.codigo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData size = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: AuthBackground(
            childr: Column(children: [
          SizedBox(height: size.size.height / 3),
          CardContainer(
            child: Column(children: [
              const SizedBox(height: 10),
              Text('Login', style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 30),
              const Text('Usuarios Activos', style: TextStyle(fontSize: 18)),
              // ChangeNotifierProvider fue importado del package provider
              ChangeNotifierProvider(
                create: (_) => LoginFormProvider(),
                child: _LoginForm(codigo: codigo),
              )
            ]),
          ),
          const SizedBox(height: 50),
        ])),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  String? codigo;
  _LoginForm({Key? key, this.codigo}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  Future<String>? datos;
  Future<String> traerusuarios() async {
    print("${connect.serverName()}traer_usuarios.php");
    var url = Uri.parse("${connect.serverName()}traer_usuarios.php");
    respuesta = await http.post(url, body: {
      "codigo": widget.codigo,
    });
    return respuesta.body;
  }

  @override
  initState() {
    // TODO: implement initState

    super.initState();
  }

  final LocalAuthentication _localAuthentication = LocalAuthentication();

  String _message = "Not Authorized";

  Future<bool> checkingForBioMetrics() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    return canCheckBiometrics;
  }

  Future<bool> _authenticateMe() async {
// 8. this method opens a dialog for fingerprint authentication.
//    we do not need to create a dialog nut it popsup from device natively.
    bool authenticated = false;

    authenticated = await _localAuthentication.authenticate(
      localizedReason: "Authenticate for Testing", // message for dialog
      useErrorDialogs: true, // show error in dialog
      stickyAuth: true,
    ); // native process

    checar = authenticated;
    return authenticated;
  }

  void _showToast(BuildContext context, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.amber,
      content: Text(
        texto,
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 2),
    ));
  }

  Future<String> sacarmac() async {
    String mac = await GetMac.macAddress;
    return mac;
  }

  Future<String> checarusuario(authentificacion) async {
    String usuario;
    var url = Uri.parse("${connect.serverName()}buscar_usuario.php");

    var respuesta =
        await http.post(url, body: {"authentificacion": "$authentificacion"});
    usuario = respuesta.body;
    return usuario;
  }

  List<String> usersActiveArray = [];
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Column(
      children: [
        Container(
          height: 180,
          width: 400,
          child: FutureBuilder<String>(
              future: traerusuarios(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (nombresn == 0) {
                    datosnombres = jsonDecode(snapshot.data!);
                  }
                  if (nombresn == 0) {
                    for (var dato in datosnombres!) {
                      usersActiveArray.add(dato[0]);
                    }
                    nombresn = 1;
                  }

                  print(datos);

                  return Stack(
                    children: [
                      GridView.count(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        crossAxisCount: 3,
                        children:
                            List.generate(usersActiveArray.length, (index) {
                          return UsersActive(
                              cheepName: usersActiveArray[index],
                              codigo: widget.codigo!,
                              nombre: datosnombres[index]);
                        }),
                      ),
                    ],
                  );
                } else {
                  return Image.asset(
                    'assets/loading-38.gif',
                    color: Colors.black,
                  );
                }
              }),
        ),
        const SizedBox(height: 50)
      ],
    );
  }
}

class UsersActive extends StatefulWidget {
  UsersActive(
      {Key? key,
      required this.cheepName,
      required this.codigo,
      required this.nombre})
      : super(key: key);
  String cheepName;
  String codigo;
  dynamic nombre;

  @override
  State<UsersActive> createState() => _UsersActiveState();
}

class _UsersActiveState extends State<UsersActive> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _correctPositionedName()[0],
                        style: const TextStyle(
                            color: Colors.white,
                            decorationColor: Colors.black,
                            fontSize: 12.5),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        _correctPositionedName()[1],
                        style: const TextStyle(
                          color: Colors.white,
                          decorationColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () async {
                print(widget.nombre);
                String usuario =
                    await checarusuario(widget.codigo, widget.nombre[0]);
                //print('soy el usuario $usuario');
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return Container(
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: AlertDialog(
                          title: const Text(
                            'Ingresar con contraseña',
                            textAlign: TextAlign.center,
                          ),
                          content: SizedBox(
                            height: 290,
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
                                  onChanged: (value) =>
                                      loginForm.usuario = value,
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
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              textCapitalization:
                                                  TextCapitalization.characters,
                                              decoration: const InputDecoration(
                                                hintText: 'Contraseña',
                                                hintMaxLines: 3,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black38),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black45,
                                                            width: 2)),
                                              ),
                                              onChanged: (value) =>
                                                  loginForm.password = value,
                                              validator: (value) {
                                                return (value != null &&
                                                        value.length >= 6)
                                                    ? null
                                                    : 'La contraseña debe ser de 6 caracteres';
                                              }),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      iconSize: 20,
                                      onPressed: activobtn
                                          ? null
                                          : () async {
                                              var url = Uri.parse(
                                                  "${connect.serverName()}traer_acciones.php");
                                              var respuesta = await http
                                                  .post(url, body: {});
                                              //print(respuesta.body);

                                              PlacesArrayAvailableData
                                                  dataList =
                                                  PlacesArrayAvailableData();
                                              await dataList
                                                  .inicializar(widget.codigo);

                                              // FocusScope.of(context).unfocus();

                                              /* setState(() {
                                activobtn = true;
                              }); */
                                              await loginForm.isValidForms();
                                              /* setState(() {
                                activobtn = false;
                              }); */
                                              print(usuario);

                                              if (loginForm.isLoading == true &&
                                                  loginForm.usuario ==
                                                      usuario) {
                                                var url = Uri.parse(
                                                    "https://pruebasmatch.000webhostapp.com/crear_entrada.php");
                                                var entrada = await http.post(
                                                    url,
                                                    body: {'usuario': usuario});
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    //builder: (BuildContext context) => HomeToursScreen(
                                                    builder: (BuildContext
                                                            context) =>
                                                        MenuHome(
                                                            acciones:
                                                                respuesta.body,
                                                            usuario: usuario,
                                                            dataList: dataList,
                                                            nombre:
                                                                widget.nombre,
                                                            entrada:
                                                                entrada.body),
                                                  ),
                                                );
                                              } else {
                                                _showToast(context,
                                                    'Contraseña o Dispositivo Equivocado');
                                              }
                                            },
                                      icon: const Icon(Icons.login, size: 40),
                                      focusColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                    )
                                  ],
                                ),

                                const SizedBox(height: 20),
                                const Divider(height: 5, color: Colors.black54),
                                const SizedBox(height: 10),
                                const Text('Ingresar con huella'),
                                const SizedBox(height: 20),

                                //botón de huella
                                ClipOval(
                                  child: Material(
                                    child: InkWell(
                                      splashColor: Colors.amberAccent[200],
                                      child: const SizedBox(
                                        width: 80,
                                        height: 80,
                                        child:
                                            Icon(Icons.fingerprint, size: 60),
                                      ),
                                      onTap: () async {
                                        await checkingForBioMetrics();
                                        await _authenticateMe();
                                        var url = Uri.parse(
                                            "${connect.serverName()}traer_acciones.php");
                                        var respuesta =
                                            await http.post(url, body: {});
                                        PlacesArrayAvailableData dataList =
                                            PlacesArrayAvailableData();
                                        await dataList.inicializar('5555');

                                        if (checar == true) {
                                          String usuario = await checarusuario(
                                              widget.codigo, widget.nombre[0]);

                                          var url = Uri.parse(
                                              "https://pruebasmatch.000webhostapp.com/crear_entrada.php");
                                          var entrada = await http.post(url,
                                              body: {'usuario': usuario});

                                          print(usuario);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              //builder: (BuildContext context) => HomeToursScreen(
                                              builder: (BuildContext context) =>
                                                  MenuHome(
                                                      acciones: respuesta.body,
                                                      usuario: usuario,
                                                      dataList: dataList,
                                                      nombre: widget.nombre),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
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
                      );
                    });
              }),
        ),
      ),
    );
  }

  Future loadImageProgress() {
    return Future.delayed(const Duration(seconds: 5), () {
      print(' me ejecuto');
      return Image.asset('assets/loading-38.gif');
    });
  }

  List<String> _correctPositionedName() {
    var prueba = widget.cheepName.split(" ");
    return prueba;
  }

  //huella
  Future<bool> checkingForBioMetrics() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    return canCheckBiometrics;
  }

  Future<bool> _authenticateMe() async {
// 8. this method opens a dialog for fingerprint authentication.
//    we do not need to create a dialog nut it popsup from device natively.
    bool authenticated = false;

    authenticated = await _localAuthentication.authenticate(
        localizedReason: "Authenticate for Testing", // message for dialog
        useErrorDialogs: true, // show error in dialog
        stickyAuth: true,
        biometricOnly: true); // native process

    checar = authenticated;
    return authenticated;
  }

  void _showToast(BuildContext context, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.amber,
      content: Text(
        texto,
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 2),
    ));
  }

  Future<String> sacarmac() async {
    String mac = await GetMac.macAddress;
    return mac;
  }

  Future<String> checarusuario(authentificacion, nombre) async {
    String usuario;
    var url = Uri.parse("${connect.serverName()}buscar_usuario.php");

    var respuesta = await http.post(url,
        body: {"authentificacion": "$authentificacion", "nombre": nombre});
    usuario = respuesta.body;
    return usuario;
  }

  void alertPassword(BuildContext context) {}
}
