import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget childr;

  const AuthBackground({Key? key, required this.childr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          const _PurpleBox(),
          const _HeaderIcon(),
          childr,
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  //Nota, este constructor fue hecho extrayendo solo el widget de SafeArea
  const _HeaderIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SafeArea es por si un dispositivo tiene un notch, el contenido se siga viendo bien
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10),
            child: const Image(
              image: AssetImage('assets/ohc.png'),
              height: 150,
            ),
          ),
          const Text(
            'OHC',
            textScaleFactor: 5,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  const _PurpleBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.4, //40%
      decoration: _buildBoxDecoration(),

      //burbujas de fondo
      child: Stack(
        children: const [
          Positioned(
            child: _Bubble(),
            top: 70,
            left: 145,
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return const BoxDecoration(
        gradient: LinearGradient(colors: [
      Color.fromRGBO(0, 191, 255, 1),
      Color.fromRGBO(0, 191, 255, 1)
    ]));
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromRGBO(255, 255, 255, 1)),
    );
  }
}
