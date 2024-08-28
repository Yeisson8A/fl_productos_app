import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyAiGdZ_n5i1bnvhLhpsWaC7gnnebZ1mGz8';
  final storage = FlutterSecureStorage();

  Future<String?> createUser(String email, String password) async {
    // Body de la petición
    final Map<String, dynamic> authData = {'email': email, 'password': password, 'returnSecureToken': true};
    // Crear petición y asignar headers
    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});
    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedData = json.decode(resp.body);

    if (decodedData.containsKey('idToken')) {
      // Guardar id token obtenido de firebase en el secure storage
      await storage.write(key: 'token', value: decodedData['idToken']);
      return null;
    }
    else {
      return decodedData['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    // Body de la petición
    final Map<String, dynamic> authData = {'email': email, 'password': password, 'returnSecureToken': true};
    // Crear petición y asignar headers
    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {'key': _firebaseToken});
    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedData = json.decode(resp.body);

    if (decodedData.containsKey('idToken')) {
      // Guardar id token obtenido de firebase en el secure storage
      await storage.write(key: 'token', value: decodedData['idToken']);
      return null;
    }
    else {
      return decodedData['error']['message'];
    }
  }

  Future logout() async {
    // Borrar id token de firebase del secure storage
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    // Buscar si esta guardado el id token en el secure storage
    return await storage.read(key: 'token') ?? '';
  }
}