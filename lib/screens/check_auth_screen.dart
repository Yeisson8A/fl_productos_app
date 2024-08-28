import 'package:fl_productos_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';
import 'screens.dart';

class CheckAuthScreen extends StatelessWidget {
   
  const CheckAuthScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Obtener instancia de servicio de login
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
         child: FutureBuilder(
           future: authService.readToken(),
           builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              // Validar si no hay datos en el future builder
              if (!snapshot.hasData) {
                return const CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary)
                );
              }

              // Validar si no hay token y redirigir al login
              if (snapshot.data == '') {
                Future.microtask(() {
                  Navigator.pushReplacement(context, PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const LoginScreen(),
                    transitionDuration: const Duration(seconds: 0)
                  ));
                });
              }
              else {
                Future.microtask(() {
                  Navigator.pushReplacement(context, PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const HomeScreen(),
                    transitionDuration: const Duration(seconds: 0)
                  ));
                });
              }
              return Container();
           },
         ),
      ),
    );
  }
}