import 'package:fl_productos_app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
   
  const LoadingScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: const Center(
         child: CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary)
         )
      ),
    );
  }
}