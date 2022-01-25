import 'package:flutter/material.dart';

class NewInteractionMenu extends StatefulWidget {
  NewInteractionMenu({Key? key}) : super(key: key);

  @override
  State<NewInteractionMenu> createState() => _NewInteractionMenuState();
}

class _NewInteractionMenuState extends State<NewInteractionMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: double.infinity,
      
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Column(
        children: [

          const SizedBox(height: 20),

          const Text('Registrar Incidencia', style: TextStyle(
            color: Colors.black,
            fontSize: 18
          ),),

          const SizedBox(height: 20),
          
          Row(
            children: const [
              TextField(
                textCapitalization: TextCapitalization.sentences,
                decoration:   InputDecoration(
                  hintText: 'Ingrese un comentario',
                  icon: Icon(
                    Icons.comment_sharp,
                    color: Colors.amber,
                  ),
                  hintMaxLines: 3,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber, width: 2)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}