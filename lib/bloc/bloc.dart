import 'dart:async';

import '../message_handler.dart';

class Bloc  {
  StreamController<MessageType>? msgController;

  Bloc([this.msgController]) {
    msgController ??= StreamController.broadcast();
  }

  void showMessage(MessageType message) {
    msgController?.sink.add(message);
  }

  void dispose() {
    msgController?.close();
  }
}