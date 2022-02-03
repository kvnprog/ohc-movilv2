import 'package:flutter/material.dart';

class ListBitacoraWidget extends StatefulWidget {
  ListBitacoraWidget({
    Key? key,
    required this.user,
    required this.userName,
    required this.contentActivity

  }) : super(key: key);

  String user;
  dynamic userName;
  Widget contentActivity;
  @override
  State<ListBitacoraWidget> createState() => _ListBitacoraWidgetState();
}

class _ListBitacoraWidgetState extends State<ListBitacoraWidget> {
  double height = 80;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: 50,
      height: height,
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(widget.userName.toString(), style: const TextStyle(
              fontSize: 12
            ),),
          ),

          Row(
            children: [
              sesionActivity('start', '10:00'),
              sesionActivity('end', '15:30'),
              IconButton(
                onPressed: (){
                  setState(() {
                    height == 80 ? height = 300 : height = 80;
                  });
                },
                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                splashRadius: 20.0,
              )
            ],
          ),

          if(height == 300)
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('Actividad en la app', style: TextStyle(
                  fontSize: 20,
                ),),
              ),
              const Divider( height: 10, color: Colors.white, indent: 5, endIndent: 5),

              Container(
                height: 180,
                child: widget.contentActivity,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget sesionActivity(String context, String value){
    late Color color;
    late String title;

    if(context == 'start'){
      color = Colors.lightGreenAccent[400]!;
      title = 'Inició sesión';
    }else{
      color = Colors.black;
      title = 'Finalizó sesión';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 3),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(50)
            ),
          ),

          Text('$title: $value')
        ],
      ),
    );
  }

}