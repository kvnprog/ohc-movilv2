import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:provider/provider.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:recorridos_app/services/provider_listener_service.dart';
import 'package:recorridos_app/widgets/btnpoint.dart';
import 'package:recorridos_app/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(HomeToursScreen());
var contador = 0;
var recorrido = "-1";
var lugar = 'algo';
bool menuRequest = false;
int setpsAvailable = 0;
int cambio = 0;
ConectionData connect = ConectionData();

enum Mode {
  defaultTheme,
  customTheme,
  advancedTheme,
}

class HomeToursScreen extends StatefulWidget {
  final String? usuario;
  final String? acciones;
  final String? entrada;
  final String? nombre;
  bool? isFromMenu;
  PlacesArrayAvailableData? dataList;
  HomeToursScreen(
      {Key? key,
      this.usuario,
      this.acciones,
      this.dataList,
      this.entrada,
      this.nombre,
      this.isFromMenu})
      : super(key: key);

  @override
  State<HomeToursScreen> createState() => _HomeToursScreenState();
}

class _HomeToursScreenState extends State<HomeToursScreen> {
  final List<String> _actionType = ['Registrar caso especial', 'Recorrido'];
  dynamic _opcionSeleccionada = 'Recorrido';
  double _distance = 120.0;
  List<InteractionMenu> interactionMenuArray = [];

  Intro? intro;
  bool widgetIsAvailable = false;

  Icon iconData = const Icon(Icons.play_arrow);

  // PlacesArrayAvailableData dataList = PlacesArrayAvailableData();

  Places? itemSelected;
  bool isAvailable = false;

  List<Places> mainArray = [];

  String timeValue = '-1';
  bool? isCanceled;
  bool hasBeenCanceled = false;

  bool isActive = false;
  bool tourIsActive = false;
  int stepsCount = 1;
  bool isCheckAvailable = false;

  String status = 'nulo';

  _HomeToursScreenState({Mode? mode, this.intro});

  @override
  void initState() {
    super.initState();

    // dataList.inicializar('5555').then((data) => dataList.arrayPlaces.add(Places(
    //     icon: Icons.fastfood,
    //     name: 'recorrido',
    //     isActive: false,
    //     timeStart: null,
    //     timeEnd: null,
    //     numeroDeIncidencias: 0)));

    Timer(
      const Duration(
        milliseconds: 500,
      ),
      () {
        /// start the intro
        intro!.start(context);
      },
    );

    _justStringValue();
    _waitForValue();
  }

  @override
  Widget build(BuildContext context) {
    if (status != 'nulo') {
      if (status != 'finished') {
        _stepsAvailable(Mode.defaultTheme, 7, [
          'Menú para controlar la creación de incidencias y transcurso del recorrido.',
          'Iniciar/Detener el recorrido.',
          'Eliminar una incidencia antes de ser guardada.',
          'Agregar un nuevo campo para generar una incidencia.',
          'Espacio de trabajo donde podrá llenar los campos para generar las incidencias.',
          'Listado horizontal de lugares de recorrido disponibles.',
          'Menú desplegable para elegir sobre hacer un recorrido completo o solo generar una incidencia.',
        ]);
      } else {}
      MediaQueryData size = MediaQuery.of(context);
      if (_opcionSeleccionada != 'Recorrido') {
        _distance = 80.50;
      } else {
        _distance = 120.0;
      }

      return ChangeNotifierProvider(
        create: (_) => ProviderListener(),
        child: Consumer<ProviderListener>(
          builder: (context, provider, child) => Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('Lugares'),
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  _showGridPlaces(provider),
                  _incidencesInteracion(),
                  if (isCheckAvailable)
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: BtnPoint(recorrido: recorrido))
                ],
              ),
            ),
            //floatingActionButton: _floatingActionButtonOptions(provider),
          ),
        ),
      );
    } else {
      _waitForValue();
      return Container();
    }
  }

  Widget _showGridPlaces(ProviderListener provider) {
    _itemStatus(provider);

    return Container(
      height: 265,
      width: double.infinity,
      child: GridView.count(
        mainAxisSpacing: 10,
        crossAxisSpacing: 5,
        shrinkWrap: true,
        crossAxisCount: 3,
        children: List.generate(widget.dataList!.arrayPlaces.length, (index) {
          return PlacesInteraction(
            isFromMenu: () {
              if (widget.isFromMenu != null) {
                if (widget.isFromMenu!) {
                  return true;
                } else {
                  return false;
                }
              } else {
                return false;
              }
            },
            fun: () {
              setState(() {});

              Places itemUpdated = provider.placeSelected = verMasListas(index);

              return itemUpdated;
            },
            item: verMasListas(index),
            numeroDeIncidencias: interactionMenuArray.length,
          );
        }),
      ),
    );
  }

  Widget _incidencesInteracion() {
    return Container(
      height: 250,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (BuildContext context, index) {
            return InteractionMenu(
                func: () {
                  setState(() {});
                },
                recorrido: recorrido,
                usuario: widget.usuario,
                nombre: widget.nombre!,
                lugar: lugar,
                acciones: widget.acciones!,
                isNewMenuRequest: true,
                btnsave: true,
                tipo: "1");
          }),
    );
  }

  _itemStatus(ProviderListener provider) async {
    if (provider.itemIsReady != null) {
      if (provider.itemIsReady!.name == 'recorrido' &&
          provider.itemIsReady!.isActive) {
        isCheckAvailable = true;
      } else {
        isCheckAvailable = false;
      }
      if (provider.itemIsReady!.timeStart != null &&
          provider.itemIsReady!.timeEnd == null) {
        // print(recorrido);
        if (cambio == 0) {
          recorrido = await crearrecorrido(provider.itemIsReady!.name);
          lugar = provider.itemIsReady!.name;
          cambio = 1;
        }

        // print(recorrido);
      } else {
        var termino = await terminarrecorrido();
        print(termino);
        recorrido = "-1";
        lugar = 'algo';
        cambio = 0;
      }
    }
  }

  Key? isFinished(int position) {
    if (status != 'finished') {
      return intro!.keys[position];
    } else {
      return null;
    }
  }

  List<DropdownMenuItem<String>> getItemsDropDown() {
    List<DropdownMenuItem<String>> lista = [];

    for (var element in _actionType) {
      lista.add(DropdownMenuItem(
        child: Text(element),
        value: element,
      ));
    }

    return lista;
  }

  verMasListas(int index) {
    int mIndex = index;
    List<Places> arrayList = widget.dataList!.arrayPlaces;
    Map arrayListMap = arrayList.asMap();
    Places thisItem = arrayListMap[mIndex];
    return thisItem;
  }

  Future<String> crearrecorrido(String lugar) async {
    var url = Uri.parse("${connect.serverName()}crear_recorrido.php");
    var respuesta = await http.post(url, body: {
      "quien_capturo": widget.usuario,
      "entrada": widget.entrada,
      "lugar": lugar
    });

    return respuesta.body;
  }

  List<String> datoss = [];

  Future<String> terminarrecorrido() async {
    // for (var elemento in dataList.arrayPlaces) {
    //   var datos = jsonEncode(elemento);
    //   datoss.add(datos);
    // }
    var json = jsonEncode(widget.dataList!.arrayPlaces);

    String jsons = json;

    var url = Uri.parse("${connect.serverName()}terminar_recorrido.php");
    var respuesta =
        await http.post(url, body: {"index": recorrido, "informacion": jsons});
    // print(jsons);

    return respuesta.body;
  }

  //llena un arreglo local con los valores de la dataClass
  List<Places> placesArray() {
    if (isCanceled != null) {
      if (isCanceled!) {
        mainArray.clear();
        for (var item in widget.dataList!.arrayPlaces) {
          item.isActive = false;
          item.timeEnd = null;
          item.timeStart = null;

          mainArray.add(item);
          hasBeenCanceled = true;
        }
      } else {
        for (var item in widget.dataList!.arrayPlaces) {
          mainArray.add(item);
        }
        hasBeenCanceled = false;
      }
    } else {
      for (var item in widget.dataList!.arrayPlaces) {
        item.isActive = false;
        item.timeEnd = null;
        item.timeStart = null;

        mainArray.add(item);
        hasBeenCanceled = true;
      }
    }
    return mainArray;
  }

  set setTimeValue(String newTimeValue) {
    timeValue = newTimeValue;
  }

  get getTimeValue {
    return timeValue;
  }

  _stepsAvailable(Mode mode, int steps, List<String> textSteps) {
    if (mode == Mode.defaultTheme) {
      /// init Intro
      intro = Intro(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        stepCount: steps,
        maskClosable: true,
        onHighlightWidgetTap: (introStatus) {
          print('soy el intro $introStatus');
        },

        /// use defaultTheme
        widgetBuilder: StepWidgetBuilder.useDefaultTheme(
          texts: [
            for (String text in textSteps) text,
          ],
          buttonTextBuilder: (currPage, totalPage) {
            if (currPage < totalPage - 1) {
              return 'Siguiente';
            } else {
              _saveData();
              return 'Finalizar';
            }
          },
        ),
      );

      intro!.setStepConfig(0, borderRadius: BorderRadius.circular(64));
    }
  }

  //Shared Preferences
  _saveData() async {
    // obtener preferencias compartidas
    final prefs = await SharedPreferences.getInstance();

    // fijar valor
    prefs.setString('status', 'finished');
  }

  Future<String> _readData() async {
    final prefs = await SharedPreferences.getInstance();

    // Intenta leer datos de la clave del contador. Si no existe, retorna none.
    final data = prefs.getString('status') ?? 'none';
    return data;
  }

  _waitForValue() async {
    if (status == 'nulo') {
      await _justStringValue();
    } else {}
    await Future.delayed(const Duration(seconds: 3));
  }

  _justStringValue() {
    _readData().then((value) {
      setState(() {
        status = value;
      });
    });
  }

  //eliminar el código
  _deleteData() async {
    final prefs = await SharedPreferences.getInstance();
    print('soy el cambio');
    prefs.remove('status');
  }
}
