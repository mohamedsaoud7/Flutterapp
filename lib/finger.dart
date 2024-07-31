import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Import for localization
import 'package:flutter_project/Localization/localization.dart';
import 'package:flutter_project/chat_screen.dart';
import 'package:flutter_project/chat_screen_fr.dart';
import 'package:flutter_project/chat_screen_nl.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintScreen extends StatefulWidget {
  final Locale locale;

  FingerprintScreen({required this.locale});

  @override
  _FingerprintScreenState createState() => _FingerprintScreenState();
}

class _FingerprintScreenState extends State<FingerprintScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;
  bool _isAuthenticated = false;

  Future<void> _authenticate() async {
    setState(() {
      _isAuthenticating = true;
    });
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticated = authenticated;
        _isAuthenticating = false;
      });
      if (authenticated) {
        _navigateToChatScreen();
      }
    } catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _isAuthenticated = false;
      });
    }
  }

  void _navigateToChatScreen() {
    switch (widget.locale.languageCode) {
      case "en":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen()),
        );
        break;
      case "nl":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreenNl()),
        );
        break;
      case "fr":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreenFr()),
        );
        break;
      default:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen()),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: widget.locale,
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
        backgroundColor: Colors.white,
        body: Container(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Arrow back icon and logo
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Row(children: [
                        Image.asset(
                          'assets/images/small.png', // Replace with your logo URL
                          height: 40,
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
                        ),
                      ]),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                // Title
                Text(
                  AppLocalizations.of(context)?.translate('setFingerprint') ??
                      'Set Your Fingerprint',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                SizedBox(height: 60),
                // Description text
                Text(
                  AppLocalizations.of(context)
                          ?.translate('fingerprintDescription') ??
                      'Add a fingerprint to make your account more secure',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue.shade900,
                  ),
                ),
                SizedBox(height: 50),
                // Fingerprint image
                Image.asset(
                  'assets/images/finger.png', // Replace with your fingerprint image URL
                  height: 200,
                ),
                SizedBox(height: 50),
                // Instruction text
                Text(
                  AppLocalizations.of(context)
                          ?.translate('fingerprintInstruction') ??
                      'Please put your finger on the fingerprint scanner to get started',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue.shade900,
                  ),
                ),
                SizedBox(height: 70),
                // Skip and Continue buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        side: BorderSide(color: Colors.blue.shade700),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)
                                ?.translate('returnButton') ??
                            'Return',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _isAuthenticating ? null : _authenticate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)
                                ?.translate('continueButton') ??
                            'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
