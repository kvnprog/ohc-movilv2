// ignore_for_file: avoid_unnecessary_containers

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
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
    print("entre");
    var url =
        Uri.parse("https://pruebasmatch.000webhostapp.com/traer_usuarios.php");
    respuesta = await http.post(url, body: {
      "codigo": "5555",
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
    var url =
        Uri.parse("https://pruebasmatch.000webhostapp.com/buscar_usuario.php");

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
          height: 300,
          width: 400,
          child: FutureBuilder<String>(
              future: traerusuarios(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<dynamic> datos = jsonDecode(snapshot.data!);

                  for (var dato in datos) {
                    usersActiveArray.add(dato[0]);
                  }
                  print(datos);
                  return GridView.count(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 3,
                    children: List.generate(usersActiveArray.length, (index) {
                      return UsersActive(
                        cheepName: usersActiveArray[index],
                        codigo: widget.codigo!,
                      );
                    }),
                  );
                } else {
                  return Image.asset('assets/loading-38.gif', color: Colors.black,);
                }
              }),
        ),
        const SizedBox(height: 50)
      ],
    );
  }

  //mostrar solo las dos primeras iniciales del nombre
  String _extractCheepName(int index) {
    String mCheepName = usersActiveArray[index];
    final mFinalName = mCheepName.characters.take(2);
    return mFinalName.toUpperCase().toString();
  }
}

class UsersActive extends StatelessWidget {
  UsersActive({Key? key, required this.cheepName, required this.codigo})
      : super(key: key);
  String cheepName;
  String codigo;
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Random random = Random();
  @override
  Widget build(BuildContext context) {
    Color color = Color.fromARGB(
        255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
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
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () async {
                await checkingForBioMetrics();
                await _authenticateMe();
                var url = Uri.parse(
                    "https://pruebasmatch.000webhostapp.com/traer_acciones.php");
                var respuesta = await http.post(url, body: {});

                if (checar == true) {
                  String usuario = await checarusuario(codigo);
                  print(usuario);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      //builder: (BuildContext context) => HomeToursScreen(
                      builder: (BuildContext context) => MenuHome(
                        //usuario: usuario,
                        //acciones: respuesta.body,
                      ),
                    ),
                  );
                }
              }),
        ),
      ),
    );
  
  }

  List<String> _correctPositionedName() {
    var prueba = cheepName.split(" ");
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
    var url =
        Uri.parse("https://pruebasmatch.000webhostapp.com/buscar_usuario.php");

    var respuesta =
        await http.post(url, body: {"authentificacion": "$authentificacion"});
    usuario = respuesta.body;
    return usuario;
  }
}
