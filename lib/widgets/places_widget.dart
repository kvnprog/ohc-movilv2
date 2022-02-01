import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:recorridos_app/data/places_data_class.dart';
import 'package:recorridos_app/services/provider_listener_service.dart';
import 'package:recorridos_app/widgets/widgets.dart';

// ignore: must_be_immutable
class PlacesInteraction extends StatefulWidget {
  Places item;
  Places Function()? fun;
  Function()? func;
  int numeroDeIncidencias;

  PlacesInteraction({Key? key, 
    required this.item, 
    required this.numeroDeIncidencias,
    this.fun,
    this.func
  }) : super(key: key);

  
    @override
  _PlacesInteractionState createState() => _PlacesInteractionState();
}

class _PlacesInteractionState extends State<PlacesInteraction> {
  late Color color;
  Color? colorActive = Colors.amber;
  Color colorEnabled = Colors.grey;

  @override
  Widget build(BuildContext context) {
    final changeItemConfiguration = Provider.of<ProviderListener>(context, listen: false);
    if(widget.func != null){
      widget.func!();
    }

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProviderListener())],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          itemClickeable(changeItemConfiguration),
          Text(
            widget.item.name,
            maxLines: null,
            style: const TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
   
  itemClickeable(ProviderListener changeItemConfiguration) {
    String itemName = widget.item.name;
    String cheepName = itemName.characters.take(3).toString();
      return GestureDetector(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
          color: isIconActive(),
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        ),

        child: Center(
          child: whichItem(cheepName)
        ),
      ),
      onTap: (){
          setState(() {});
          print('evaluando');
          final time = '${TimeOfDay.now().hour}:${TimeOfDay.now().minute}';    

          if(widget.item.timeEnd != null && widget.item.timeStart != null && widget.item.isActive == false){
            
            if(changeItemConfiguration.itemIsReady != null){
              if(changeItemConfiguration.itemIsReady!.timeEnd != null){
              widget.item.isActive = false;
              widget.item.timeStart = time;
              widget.item.timeEnd = null; 
              //changeItemConfiguration.setBoolValue = widget.item;
            }
            }
          }

          //verifica si hay un item seleccionado para así no seleccionar otros sin antes haber finalizado el actual
            if(changeItemConfiguration.itemIsReady == null){
              print("if 1");
              //colorEnabled = Colors.grey;
              changeItemConfiguration.setBoolValue = widget.item;
              widget.fun!();
              changeItemConfiguration.placeAffected;
              widget.item.timeStart = time;
              setState(() {
                isIconActive();                
              });
          }else{
          //se activa para darle una hora final a un item 
            if(changeItemConfiguration.itemIsReady!.name == widget.item.name){
              print("if 2");              
              //esto hace que puedan volver al ultimo lugar seleccionado
              if(color == Colors.blue){
                  widget.fun!();
                  widget.item.isActive = true;
                  widget.item.timeStart = time;
                  widget.item.timeEnd = null; 
              }else{
              print('es el else');
              widget.fun!();
              widget.item.timeEnd = time;            
              changeItemConfiguration.placeAffected;
              setState(() {
              colorActive = Colors.transparent;
              color = Colors.blue;
            });
              }
          if(widget.item.numeroDeIncidencias == 0){
                widget.item.numeroDeIncidencias = widget.numeroDeIncidencias;
          }else{
            print('ya tiene incidencias generadas así que no se guardan');
          }
            print('hay ${widget.numeroDeIncidencias} incidencias hechas en ${widget.item.name}');
          
        }else{
    //agrega un valor de inicio a un item que no ha sido inicializado
          if(changeItemConfiguration.itemIsReady!.timeEnd != null){
            print('actual item ${widget.item} y el otro es ${changeItemConfiguration.itemIsReady}');
            print("if 3");
              changeItemConfiguration.setBoolValue = widget.item;
              widget.fun!();
              changeItemConfiguration.placeAffected;
              widget.item.timeStart = time;
          }

        }
      }
    },
  
  );    
}

  //metodo que dibuja el color del icono mostrando si está activo o no
    Color isIconActive(){
     if (widget.item.isActive) {
      color = Colors.greenAccent[400]!;
    }else{
        color = Colors.grey;
    }
      if(widget.item.timeEnd != null){
      color = Colors.blue;
    }
  
    return color;
  }

  Widget whichItem(String cheepName){
    if(widget.item.name == 'recorrido'){
      return Icon(widget.item.icon, size: 50,);
    }else{
      return Text(cheepName.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(
        color: Colors.black,
        fontSize: 30
      ));
    }
  }

}