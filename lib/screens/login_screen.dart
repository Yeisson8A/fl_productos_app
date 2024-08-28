import 'package:fl_productos_app/theme/app_theme.dart';
import 'package:fl_productos_app/ui/input_decorations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
   
  const LoginScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        widget: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              // Contenedor para el formulario
              CardContainer(
                widget: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Login', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 30),
                    // Formulario
                    ChangeNotifierProvider(create: ( _ ) => LoginFormProvider(), child: const _LoginForm())
                  ],
                )
              ),
              const SizedBox(height: 50),
              // Registro
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, 'register'), 
                style: ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(AppTheme.primary.withOpacity(0.1)),
                  shape: const WidgetStatePropertyAll(StadiumBorder())
                ),
                child: const Text('Crear una nueva cuenta', style: TextStyle(fontSize: 18, color: Colors.black87))
              ),
              const SizedBox(height: 50)
            ],
          ),
        )
      )
    );
  }
}

// Formulario
class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    const String textEmail = 'Correo electrónico';
    const String textPassword = 'Contraseña';
    // Obtener la instancia del provider
    final loginFormProvider = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginFormProvider.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false, 
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(hintText: textEmail, labelText: textEmail, prefixIcon: Icons.alternate_email_outlined),
              onChanged: (value) => loginFormProvider.email = value, // Asignar valor del formulario
              validator: (value) {
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = RegExp(pattern);
                return regExp.hasMatch(value ?? '') ? null : 'El correo electrónico no es válido';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false, 
              obscureText: true,
              decoration: InputDecorations.authInputDecoration(hintText: textPassword, labelText: textPassword, prefixIcon: Icons.lock_outlined),
              onChanged: (value) => loginFormProvider.password = value, // Asignar valor del formulario
              validator: (value) => (value != null && value.length >= 6) ? null : 'La contraseña debe tener 6 caracteres'
            ),
            const SizedBox(height: 30),
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: InputDecorations.primary,
              onPressed: loginFormProvider.isLoading ? null : () async {
                // Obtener instancia de servicio de login
                final authService = Provider.of<AuthService>(context, listen: false);
                // Para cerrar el teclado al dar clic al botón
                FocusScope.of(context).unfocus();
                // Validar si el formulario es válido
                if (!loginFormProvider.isValidForm()) return;
                // Indicar que esta cargando la información
                loginFormProvider.isLoading = true;
                // Login con usuario y contraseña almacenadas en firebase
                final String? errorMessage = await authService.login(loginFormProvider.email, loginFormProvider.password);

                // Validar si el login fue correcto
                if (errorMessage == null) {
                  // Navegar a la siguiente pantalla
                  Navigator.pushReplacementNamed(context, 'home');
                }
                else {
                  // Mostrar alerta con mensaje de error
                  NotificationsService.showErrorSnackbar(errorMessage);
                  // Indicar la información ya esta cargada
                  loginFormProvider.isLoading = false;
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(loginFormProvider.isLoading ? 'Por favor espere' : 'Ingresar', style: const TextStyle(color: Colors.white))
              )
            )
          ],
        )
      ),
    );
  }
}