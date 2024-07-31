import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  // Define your state variables and methods here

  // Example state variable
  bool isLoggedIn = false;

  // Example method to change state
  void login() {
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }

  // Add other state variables and methods as needed
}
