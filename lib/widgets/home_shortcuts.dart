import 'package:flutter/material.dart';

class ShortCutAccess extends StatelessWidget {
  const ShortCutAccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(25)
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //lado izquierdo del widget
          Container(
            width: 180,
            height: 200,
            decoration:const BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.all(Radius.circular(25))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Título del shortcut', style: TextStyle(
                  color: Colors.grey[200]
                ),),
                const Icon(Icons.access_time_rounded, size: 50, color: Colors.amber,)
              ],
            ),
          ),

          //lado derecho del widget
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 3),
            width: 160,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (BuildContext context, index){

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Item name position')
                  ],
                );
              }),
          )
        ],
      ),
    );
  }
}