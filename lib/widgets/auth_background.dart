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

          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(80)
              ),  
              margin: const EdgeInsets.only(top: 10),
              child: const Image(
                image: AssetImage('assets/ohc.png'),
                height: 150,
              ),
            ),
          ),

          const SizedBox( height: 20, ),
          const Text(
            'OHC',
            textScaleFactor: 3,
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
          Positioned(child: _Bubble(), top: 40, bottom: 200, left: -30,),
          Positioned(child: _Bubble(), top: 150, bottom: 90, right: 10,),
          Positioned(child: _Bubble(), bottom: -30, left: -40,),
          Positioned(child: _Bubble(), top: 149, left: 80,),
          Positioned(child: _Bubble(), top: 1, right: 40,),
          Positioned(child: _Bubble(), bottom: -40, right: -20,),
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
  const _Bubble({Key? key
  
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return bubbleDesign(1);
  }

  Widget bubbleDesign(double index){
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color:  const Color.fromRGBO(255, 255, 255, 190)),
    );
  }
}

