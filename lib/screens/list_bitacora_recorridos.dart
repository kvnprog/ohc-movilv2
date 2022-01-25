import 'package:flutter/material.dart';
import 'package:recorridos_app/widgets/list_menu_widget.dart';

class BitacoraRecorridos extends StatelessWidget {
  //List item = List<Widget>.generate(20, (index) => ListMenuItem());

  List item = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: const Text('Incidencias en recorrido'),
          ),
          body: Container(
            child: Column(
              children: [
                _personalWidget()
              ],
            ),
          ),
    );
  }

  Widget _personalWidget() {
    final data = item.length;
    return Column(children: [
      Container(
          height: 710,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: data,
            itemBuilder: (BuildContext context, int index) {
              return ListMenuItem();
            },
          )),
    ]);
  }
}
