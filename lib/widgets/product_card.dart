import 'package:fl_productos_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0, 7), blurRadius: 10)]
    );
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: boxDecoration,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // Imagen de fondo
            _BackgroundImage(url: product.picture),
            // Sección con detalle del producto
            _ProductDetails(title: product.name, subTitle: product.id!),
            // Sección del precio del producto
            Positioned(top: 0, right: 0, child: _PriceTag(price: product.price)),

            if (!product.available)
              // Sección producto no disponible
              const Positioned(top: 0, left: 0, child: _NotAvailable())
          ],
        ),
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  final String? url;
  const _BackgroundImage({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: url == null
        ? const Image(
            image: AssetImage('assets/no-image.png'),
            fit: BoxFit.cover
          )
        : FadeInImage(
            placeholder: const AssetImage('assets/jar-loading.gif'),
            image: NetworkImage(url!),
            fit: BoxFit.cover
          )
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final String title;
  final String subTitle;
  const _ProductDetails({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    const boxDecoration = BoxDecoration(
      color: AppTheme.primary,
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), topRight: Radius.circular(25))
    );
    
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        decoration: boxDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title, 
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)
            ),
            Text(subTitle, style: const TextStyle(fontSize: 15, color: Colors.white))
          ],
        ),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final double price;
  const _PriceTag({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Container(
        width: 100,
        height: 70,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25))
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text('\$$price', style: const TextStyle(fontSize: 20, color: Colors.white)),
        )
      ),
    );
  }
}

class _NotAvailable extends StatelessWidget {
  const _NotAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Container(
        width: 150,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.yellow[800],
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), bottomRight: Radius.circular(25))
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('No disponible', style: TextStyle(fontSize: 20, color: Colors.white))
        ),
      ),
    );
  }
}