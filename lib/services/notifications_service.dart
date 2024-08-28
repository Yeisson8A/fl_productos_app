import 'package:fl_productos_app/enums/message_enum.dart';
import 'package:flutter/material.dart';

class NotificationsService {
  static GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showErrorSnackbar(String message) {
    final textMessage = MessageEnum.searchByKey(message);
    final snackBar = SnackBar(
      showCloseIcon: true,
      backgroundColor: Colors.red[900],
      content: Center(child: Text(textMessage.value, style: const TextStyle(color: Colors.white, fontSize: 20)))
    );
    messengerKey.currentState!.showSnackBar(snackBar);
  }

  static showSucessfullSnackbar() {
    final snackBar = SnackBar(
      showCloseIcon: true,
      backgroundColor: Colors.green[900],
      content: const Center(child: Text('Guardado exitosamente', style: TextStyle(color: Colors.white, fontSize: 20)))
    );
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}