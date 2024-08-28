import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget widget;
  const CardContainer({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 5))]
        );
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: boxDecoration,
        child: widget,
      ),
    );
  }
}