import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_project/Localization/localization.dart';

class SignUp extends StatelessWidget {
  final Locale locale;

  SignUp({required this.locale});
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
   home :Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Image.asset(
                    'assets/images/small.png', // Add your logo asset here
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)?.translate('createYour') ?? 'Create your',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(17, 101, 190, 1),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)?.translate('account') ?? 'Account',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(17, 101, 190, 1),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(241, 246, 252, 1),
                        prefixIcon:
                            Icon(Icons.email, color: Color.fromRGBO(143, 154, 230, 1)),
                        hintText: AppLocalizations.of(context)?.translate('emailHint') ?? 'levis-andrew@gmail.com',
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(143, 154, 230, 1)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(241, 246, 252, 1),
                        prefixIcon:
                            Icon(Icons.lock, color: Color.fromRGBO(143, 154, 230, 1)),
                        hintText: AppLocalizations.of(context)?.translate('passwordHint') ?? 'Password',
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(143, 154, 230, 1)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(241, 246, 252, 1),
                        prefixIcon:
                            Icon(Icons.lock, color: Color.fromRGBO(143, 154, 230, 1)),
                        hintText: AppLocalizations.of(context)?.translate('confirmPasswordHint') ?? 'Confirm Password',
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(143, 154, 230, 1)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: true,
                          onChanged: (bool? value) {},
                        ),
                        Text(
                          AppLocalizations.of(context)?.translate('rememberMe') ?? 'Remember me',
                          style: TextStyle(
                              color: Color.fromRGBO(17, 101, 190, 1),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 80),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          AppLocalizations.of(context)?.translate('signUpButton') ?? 'Sign up',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(17, 101, 190, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    RichText(
                      text: TextSpan(
                        text: AppLocalizations.of(context)?.translate('alreadyHaveAccount') ?? 'Already have an account? ',
                        style: TextStyle(color: Colors.blue),
                        children: <TextSpan>[
                          TextSpan(
                            text: AppLocalizations.of(context)?.translate('signIn') ?? 'Sign In',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(17, 101, 190, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
   ));
  }
}
