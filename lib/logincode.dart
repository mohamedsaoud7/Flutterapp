import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/signup.dart';
import 'package:flutter_project/finger.dart';
import 'package:flutter_project/Localization/localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class VerificationScreen extends StatelessWidget {
  final Locale locale;

  VerificationScreen({required this.locale});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('fr'),
        Locale('nl'),
      ],
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.center,
              colors: [
                Colors.grey.shade300,
                Colors.white,
              ],
              stops: [0.0, 0.2],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/small.png',
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 14),
                          child: Text(
                            'AlphaBot',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Center(
                  child: Image.asset(
                    'assets/images/welcomebot-blue.png',
                    fit: BoxFit.contain,
                    height: 250,
                  ),
                ),
                SizedBox(height: 20),
                Center(child:Text(
                  AppLocalizations.of(context)!.translate('enterVerification'),
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Monospace',
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  )),
                ),
                SizedBox(height: 10),
                Center(child:Text(
                  AppLocalizations.of(context)!.translate('code'),
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Monospace',
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  )),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white.withOpacity(0.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              decoration: InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FingerprintScreen(locale: locale,)),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.translate('verify'),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: Text(
                    '_________________   or   __________________',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: AppLocalizations.of(context)!.translate('noAccount'),
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.translate('signUp'),
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SignUp(locale: locale)),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
