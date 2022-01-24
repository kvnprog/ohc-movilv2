import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {

  final Widget child;

  const CardContainer({
    Key? key,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          padding: const EdgeInsets.all( 20 ),
          width: double.infinity,
          decoration: _createCardShape(),
          child: child,
      ),
    );
  }

  BoxDecoration _createCardShape() => const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(50)),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 20,
        offset: Offset(0,5)
      )
    ]
  );
}