import 'package:flutter/material.dart';

class ListMenuItem extends StatelessWidget {
  const ListMenuItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
          width: double.infinity,
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.amber[200],
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text('Ángel Romano'),
              Text('Lucas Cardenas'),
              Text('Consultorio'),
              Text('14:22')
            ],
          ),
    );
  }
}