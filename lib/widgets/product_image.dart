import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? url;
  const ProductImage({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    const boxDecoration = BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]
    );
    
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        width: double.infinity,
        height: 450,
        decoration: boxDecoration,
        child: Opacity(
          opacity: 0.8,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
            child: getImage(url)
          ),
        ),
      ),
    );
  }

  Widget getImage(String? picture) {
    // Cuando no se indico ninguna imagen
    if (picture == null) {
      return const Image(
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover
      );
    }

    // Cuando la imagen proviene de la web
    if (picture.startsWith('http')) {
      return FadeInImage(
        placeholder: const AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(url!),
        fit: BoxFit.cover,
      );
    }

    // Cuando la imagen es local del dispositivo
    return Image.file(File(picture), fit: BoxFit.cover);
  }
}