import 'package:fl_productos_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/screens.dart';
import 'services/services.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => AuthService()),
        ChangeNotifierProvider(create: ( _ ) => ProductsService())
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productos App',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: NotificationsService.messengerKey,
      initialRoute: 'checking',
      routes: {
        'login': ( _ ) => const LoginScreen(),
        'register': ( _ ) => const RegisterScreen(),
        'home': ( _ ) => const HomeScreen(),
        'product': ( _ ) => const ProductScreen(),
        'checking': ( _ ) => const CheckAuthScreen()
      },
      theme: AppTheme.lightTheme,
    );
  }
}
