import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '/firebase_options.dart';
import './screens/email_auth/login_screen.dart';
import './screens/home_screen.dart';
// import 'package:project/screens/phone_auth/sign_in_with_phone.dart';
// import 'package:project/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './screens/home_screen_controller.dart';
import './pdf/pdf_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // await NotificationService.initialize();

  // FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("users").doc("Z3kfNrbsVBlgqPnP94S2").get();
  // log(snapshot.data().toString());

  // Map<String, dynamic> newUserData = {
  //   "name": "SlantCode",
  //   "email": "slantcode@gmail.com"
  // };
  // await _firestore.collection("users").doc("your-id-here").update({
  //   "email": "slantcode2@gmail.com"
  // });
  // log("User updated!");

  // await _firestore.collection("users").doc("Z3kfNrbsVBlgqPnP94S2").delete();
  // log("User deleted!");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        // Handle '/'
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) => MyHome());
        }

        // Handle '/details/:id'
        var uri = Uri.parse(settings.name.toString());
        if (uri.pathSegments.length == 2 &&
            uri.pathSegments.first == 'resume') {
          var user = uri.pathSegments[1];
          return MaterialPageRoute(
              settings: settings, builder: (context) => PdfPage(user: user));
        }

        return MaterialPageRoute(builder: (context) => LoginScreen());
      },
    );
  }
}
