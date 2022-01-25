import 'dart:convert';

import 'package:flutter/material.dart';

class ListMenuItem extends StatelessWidget {
  List<dynamic>? datos;
  ListMenuItem({Key? key, this.datos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("${datos![0]}");

    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.amber[200],
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('${datos![0]}'),
        ],
      ),
    );
  }
}
