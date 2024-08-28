import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget widget;
  const AuthBackground({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Fondo morado superior
          _PurpleBox(),
          // Icono circular
          _HeaderIcon(),
          // Contenedor para el formulario
          widget
        ],
      ),
    );
  }
}

// Diseño del icono circular superior
class _HeaderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        child: const Icon(Icons.person_pin, color: Colors.white, size: 100),
      ),
    );
  }
}

// Diseño del fondo morado superior
class _PurpleBox extends StatelessWidget {
  final boxDecoration = const BoxDecoration(
    gradient: LinearGradient(colors: [Color.fromRGBO(63, 63, 156, 1), Color.fromRGBO(90, 70, 178, 1)])
  );

  @override
  Widget build(BuildContext context) {
    // Obtener tamaño de la pantalla del dispositivo
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: boxDecoration,
      child: Stack(
        children: [
          Positioned(top: 90, left: 30, child: _Bubble()),
          Positioned(top: -40, left: -30, child: _Bubble()),
          Positioned(top: -50, right: -20, child: _Bubble()),
          Positioned(bottom: -50, left: 10, child: _Bubble()),
          Positioned(bottom: 120, right: 20, child: _Bubble())
        ],
      ),
    );
  }
}

// Diseño de burbujas del fondo
class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: const Color.fromRGBO(255, 255, 255, 0.05)),
    );
  }
}