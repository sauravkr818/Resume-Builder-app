import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../screens/email_auth/login_screen.dart';
import '../screens/home_screen.dart';
import '../pdf/pdf_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Routes {
  static final router = FluroRouter();

  static var splashHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return (FirebaseAuth.instance.currentUser != null) ? Home() : LoginScreen();
  });

  static var placeHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    //print(params);
    return PdfPage(user: params["user"][0]);
  });

  static dynamic defineRoutes() {
    router.define("/resume/:user",
        handler: placeHandler, transitionType: TransitionType.inFromLeft);
    router.define("/",
        handler: splashHandler, transitionType: TransitionType.fadeIn);
  }
}
