import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:provider/provider.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:recorridos_app/services/provider_listener_service.dart';
import 'package:recorridos_app/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const HomeToursScreen());
var contador = 0;
var recorrido;
bool menuRequest = false;
int setpsAvailable = 0;

enum Mode {
  defaultTheme,
  customTheme,
  advancedTheme,
}

class HomeToursScreen extends StatefulWidget {
  final String? usuario;
  final String? acciones;
  final Mode? mode;
  const HomeToursScreen({Key? key, this.usuario, this.mode, this.acciones})
      : super(key: key);

  @override
  State<HomeToursScreen> createState() => _HomeToursScreenState(
        mode: mode,
      );
}

class _HomeToursScreenState extends State<HomeToursScreen> {
  final List<String> _actionType = ['Registrar caso especial', 'Recorrido'];
  dynamic _opcionSeleccionada = 'Recorrido';
  double _distance = 120.0;
  List<InteractionMenu> interactionMenuArray = [];

  Intro? intro;
  bool widgetIsAvailable = false;

  Icon iconData = const Icon(Icons.play_arrow);

  PlacesArrayAvailableData dataList = PlacesArrayAvailableData();

  Places? itemSelected;
  bool isAvailable = false;

  List<Places> mainArray = [];

  String timeValue = '-1';
  bool? isCanceled;
  bool hasBeenCanceled = false;

  bool isActive = false;
  bool tourIsActive = false;
  int stepsCount = 1;

  String status = 'nulo';

  _HomeToursScreenState({Mode? mode, this.intro});

  @override
  void initState() {
    super.initState();
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
              title: const Text('Recorridos'),
              elevation: 0,
              actions: <Widget>[
                IconButton(
                    onPressed: () => Navigator.of(context).pop('login'),
                    icon: const Icon(
                      Icons.login_outlined,
                      color: Colors.black,
                      size: 30,
                    )),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  _showGridPlaces(provider),
                  
                  _incidencesInteracion()
                  //menú de interacción para generar incidencias
                  //_deleteIncidenceOptions(provider, size),
                  //NewInteractionMenu()
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

  //Functions and Methods
  Widget _floatingActionButtonOptions(ProviderListener provider) {
    late bool initialOpen;

    status == 'finished' ? initialOpen = false : initialOpen = true;

    return Container(
      key: isFinished(0),
      width: 200,
      height: 190,
      child: ExpandableFab(
        initialOpen: initialOpen,
        distance: _distance,
        children: [
          //iniciar/finalizar el recorrido
          if (_opcionSeleccionada == 'Recorrido')
            ActionButton(
              key: isFinished(1),
              onPressed: () async {
                setState(() {});
                if (iconData.icon == const Icon(Icons.play_arrow).icon) {
                  _mostrarAlerta(context);
                } else {
                  //botón de detener
                  await terminarrecorrido();
                  iconData = const Icon(Icons.play_arrow);
                  getTimeValue;
                  isCanceled = true;
                  tourIsActive = false;
                  setState(() {});
                  provider.itemIsReady = null;
                  menuRequest = true;
                  interactionMenuArray.removeRange(
                      0, interactionMenuArray.length);
                }
              },
              icon: iconData,
            ),

          //eliminar un campo de incidencia
          if (isActive == true && isCanceled == false ||
              _opcionSeleccionada != 'Recorrido' ||
              status != 'finished')
            ActionButton(
              key: isFinished(2),
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                //2
                setState(() {});
                int index = interactionMenuArray.length - 1;
                if (index != -1) {
                  if (interactionMenuArray[index].btnsave == true) {
                    interactionMenuArray.removeAt(index);
                    contador -= 1;
                  }
                }
              },
            ),

          //agregar nuevo campo de crear incidencia
          if (isActive == true && isCanceled == false ||
              _opcionSeleccionada != 'Recorrido' ||
              status != 'finished')
            ActionButton(
              key: isFinished(3),
              onPressed: () {
                setState(() {});
                if (provider.itemIsReady != null ||
                    _opcionSeleccionada != 'Recorrido') {
                  if (contador != 9) {
                    contador += 1;
                    var lugar;
                    for (var element in dataList.arrayPlaces) {
                      if (element.isActive == true) {
                        lugar = element.name;
                      }
                    }

                    // interactionMenuArray.add(InteractionMenu(
                    //     tipo: _opcionSeleccionada,
                    //     lugar: lugar,
                    //     acciones: widget.acciones!,
                    //     isNewMenuRequest: menuRequest,
                    //     recorrido: recorrido,
                    //     usuario: widget.usuario,
                    //     btnsave: true));
                  } else {
                    // _showToast(context, 'Solo se puede Agregar 10 Incidencias');
                  }
                }
              }, //_sh_showAction(context, 0),
              icon: const Icon(Icons.new_label_sharp),
            ),
        ],
      ),
    );
  }

  Widget _showGridPlaces(ProviderListener provider) {
    return Container(
      height: 250,
      width: double.infinity,
      child: GridView.count(
        mainAxisSpacing: 10,
        crossAxisSpacing: 5,
        shrinkWrap: true,
        crossAxisCount: 3,
        children: List.generate(dataList.arrayPlaces.length, (index) {
          return PlacesInteraction(
            fun: () {
              setState(() {});
              Places itemUpdated = provider.placeSelected = verMasListas(index);
              return itemUpdated;
            },
            item: verMasListas(index),
            func: () {
              if (hasBeenCanceled == true) {
                ProviderListener changeItemConfiguration =
                    Provider.of<ProviderListener>(context, listen: false);
                return changeItemConfiguration.setBoolValue = null;
              }
            },
            numeroDeIncidencias: interactionMenuArray.length,
          );
        }),
      ),
    );
  }

  Widget _incidencesInteracion(){
    return Container(
      height: 400,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (BuildContext context, index){
        return InteractionMenu(
            acciones: "hola",
            isNewMenuRequest: true,
            btnsave: true,
            tipo: "1"
        );
      }),
    );
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
    List<Places> arrayList = dataList.arrayPlaces;
    Map arrayListMap = arrayList.asMap();
    Places thisItem = arrayListMap[mIndex];
    return thisItem;
  }

  Future<String> crearrecorrido() async {
    var url =
        Uri.parse("https://pruebasmatch.000webhostapp.com/crear_recorrido.php");
    var respuesta = await http.post(url, body: {
      "quien_capturo": widget.usuario,
    });

    return respuesta.body;
  }

  List<String> datoss = [];

  Future<String> terminarrecorrido() async {
    // for (var elemento in dataList.arrayPlaces) {
    //   var datos = jsonEncode(elemento);
    //   datoss.add(datos);
    // }
    var json = jsonEncode(dataList.arrayPlaces);

    String jsons = json;

    var url = Uri.parse(
        "https://pruebasmatch.000webhostapp.com/terminar_recorrido.php");
    var respuesta =
        await http.post(url, body: {"index": recorrido, "informacion": jsons});
    print(jsons);
    return respuesta.body;
  }

  //llena un arreglo local con los valores de la dataClass
  List<Places> placesArray() {
    if (isCanceled != null) {
      if (isCanceled!) {
        mainArray.clear();
        for (var item in dataList.arrayPlaces) {
          item.isActive = false;
          item.timeEnd = null;
          item.timeStart = null;

          mainArray.add(item);
          hasBeenCanceled = true;
        }
      } else {
        for (var item in dataList.arrayPlaces) {
          mainArray.add(item);
        }
        hasBeenCanceled = false;
      }
    } else {
      for (var item in dataList.arrayPlaces) {
        item.isActive = false;
        item.timeEnd = null;
        item.timeStart = null;

        mainArray.add(item);
        hasBeenCanceled = true;
      }
    }
    return mainArray;
  }

  void _mostrarAlerta(BuildContext context) {
    late String message;

    if (iconData.icon == const Icon(Icons.stop).icon) {
      message = 'Detener recorrido';
    } else {
      message = 'Iniciar recorrido';
    }

    showDialog(
        context: context,
        //se puede cerrar haciendo click al rededor de la pantalla
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: const Text('Estás por iniciar un nuevo recorrido'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Text(
                    'Si aceptas, el tiempo empezará a contar inmediatamente y finalizará hasta que detengas el recorrido.'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(message),
                onPressed: () async {
                  String time =
                      "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";
                  recorrido = await crearrecorrido();
                  setState(() {});
                  Navigator.of(context).pop();
                  iconData = const Icon(Icons.stop);
                  isCanceled = false;
                  setTimeValue = time;
                  isActive = true;
                  tourIsActive = true;

                  menuRequest = true;
                  interactionMenuArray.removeRange(
                      0, interactionMenuArray.length);
                },
              ),
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
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
