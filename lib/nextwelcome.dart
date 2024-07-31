import 'package:flutter/material.dart';
import 'package:flutter_project/login.dart';
import 'package:flutter_project/Localization/localization.dart';

class NextWelcome extends StatelessWidget {
  final Function(Locale) onLocaleChange;

  NextWelcome({required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.center,
            colors: [
              Colors.grey.shade300, // Slight darkness on the left
              Colors.white, // Transition to white
            ],
            stops: [0, 0.2],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Image.asset(
                    'assets/images/welcomebot-blue.png', // Add your image asset here
                    fit: BoxFit.contain,
                    height: 300,
                  ),
                ),
              ),
              SizedBox(height: 40),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)?.translate('welcomeMessage'),
                      style: TextStyle(
                        fontSize: 34,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.translate('select'),
                  style: TextStyle(fontSize: 20,color: const Color.fromARGB(255, 106, 167, 218)),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/images/en_flag.png',
                      height: 50,
                      width: 50,
                    ),
                    iconSize: 50,
                    onPressed: () {
                      onLocaleChange(Locale('en'));
                    },
                  ),
                  SizedBox(width: 40),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/fr_flag.png',
                      height: 50,
                      width: 50,
                    ),
                    iconSize: 50,
                    onPressed: () {
                      onLocaleChange(Locale('fr'));
                    },
                  ),
                  SizedBox(width: 40),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/nl_flag.png',
                      height: 50,
                      width: 50,
                    ),
                    iconSize: 50,
                    onPressed: () {
                      onLocaleChange(Locale('nl'));
                    },
                  ),
                ],
              ),
              SizedBox(height: 100),
              CustomPaint(
                size: Size(50, 5),
                painter: DashedLinePainter(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(52, 153, 242, 1), // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () {
                  Locale currentLocale = Localizations.localeOf(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen(locale: currentLocale)),
                  );
                  // Add your onPressed code here!
                },
                child: Text(
                  AppLocalizations.of(context)?.translate('next') ?? 'next',
                  style: TextStyle(
                      fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color.fromRGBO(52, 153, 242, 1)
      ..strokeWidth = 3;

    double fullLineLength = size.width * 0.7; // Length of continuous line
    double dashWidth = 5;
    double dashSpace = 5;
    double startX = 0;

    // Draw the continuous line part
    canvas.drawLine(Offset(startX, 0), Offset(fullLineLength, 0), paint);
    startX = fullLineLength + dashSpace;

    // Draw the interrupted part
    int dashCount = 2;
    while (dashCount > 0) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
      dashCount--;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
