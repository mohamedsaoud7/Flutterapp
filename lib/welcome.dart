import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 153, 243, 1), // Light blue background
      body: Column(
        children: [
           Center(
            child:Padding(padding: EdgeInsets.only(top: 100), child:  Image.asset(
          'assets/images/welcomebot.png', // Add your image asset here
          fit: BoxFit.cover,
        ), 
          ),
           )

        ],
      )
      );
  }
}
