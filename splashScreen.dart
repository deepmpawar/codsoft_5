// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:recipe_app/main.dart';
//
// class SplashScreen extends StatefulWidget{
//   @override
//   State<SplashScreen> createState() {
//     return _SplashScreenState();
//   }
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//
//     Timer(Duration(seconds: 2), () {
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => MyApp(),
//           ));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.blue,
//         child: Center(child: Text('EL-Classico', style: TextStyle(fontSize: 44,
//             fontWeight: FontWeight.w700,
//             fontFamily: 'FontMain',
//             color: Colors.white),)),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:recipe_app/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeListScreen(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/backgroundimg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            'EL-Classico',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w700,
              fontFamily: 'FontMain',
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
