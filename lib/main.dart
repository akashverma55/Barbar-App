import 'package:firebase_app/Admin/AdminHome.dart';
import 'package:firebase_app/Admin/AdminLogin.dart';
import 'package:firebase_app/Screen/booking.dart';
import 'package:firebase_app/utils/firebase_options.dart';
import 'package:firebase_app/Screen/home.dart';
import 'package:firebase_app/Screen/signin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  ); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Color(0xFF2b1615)),
      debugShowCheckedModeBanner: false,
      // home: StreamBuilder(
      //   stream: FirebaseAuth.instance.authStateChanges(), 
      //   builder: (context, snapshot){
      //     if(snapshot.connectionState == ConnectionState.waiting){
      //       return Center(child: CircularProgressIndicator());
      //     }else if(snapshot.hasData){
      //       return Home();
      //     }else if(snapshot.hasError){
      //       return Center(child: Text("Something went wrong"));
      //     }else{
      //       return SignInPage();
      //     }
      //   }
      // ),
      home: const Adminlogin(),
    );
  }
}

