import 'package:fl_productos_app/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Obtener instancia del servicio
    final productsService = Provider.of<ProductsService>(context);
    // Obtener instancia de servicio de login
    final authService = Provider.of<AuthService>(context, listen: false);
    final products = productsService.products;

    // Validar si los productos se están cargando
    if (productsService.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            onPressed: () {
              // Borrar token del secure storage
              authService.logout();
              // Redirigir al login
              Navigator.pushReplacementNamed(context, 'login');
            }, 
            icon: const Icon(Icons.logout_rounded, color: Colors.white)
          )
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) => GestureDetector(
          child: ProductCard(product: products[index]),
          onTap: () {
            // Obtener una copia del producto seleccionado
            productsService.selectedProduct = products[index].copy();
            Navigator.pushNamed(context, 'product');
          },
        ),
      ),
      // Botón para agregar producto
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Crear una nueva instancia de producto
          productsService.selectedProduct = Product(name: '', price: 0, available: false);
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}