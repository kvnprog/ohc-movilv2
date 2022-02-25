import 'package:flutter/material.dart';

class ShortCutAccess extends StatelessWidget {
  String shortcutTitle;
  IconData shortcutIcon;
  List<Widget> widgetsListActions;
  ShortCutAccess({
    Key? key,
    required this.shortcutIcon,
    required this.shortcutTitle,
    required this.widgetsListActions
  }) : super(key: key);

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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  child: Text(shortcutTitle, style: TextStyle(
                    color: Colors.grey[200]
                  ),
                  textAlign: TextAlign.center,
                  ),
                ),
                Icon(shortcutIcon, size: 50, color: Colors.blue,)
              ],
            ),
          ),

          //lado derecho del widget
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 3),
            width: 160,
            height: 200,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (BuildContext context, index){

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: widgetsListActions,
                );
              }),
          )
        ],
      ),
    );
  }
}