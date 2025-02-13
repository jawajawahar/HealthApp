import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/AboutUS.dart';
import 'package:untitled1/BMI.dart';
import 'package:untitled1/BMITipsPage.dart';
import 'package:untitled1/ContactUs.dart';
import 'package:untitled1/Other%20features.dart';
import 'package:untitled1/acccreate.dart';
import 'package:untitled1/echanneling.dart';
import 'package:untitled1/econtact.dart';
import 'package:untitled1/healthtips.dart';
import 'package:untitled1/home.dart';
import 'package:untitled1/login.dart';
import 'package:untitled1/reminder.dart';
import 'package:untitled1/start.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('your-recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<ThemeNotifier>(context).themeMode;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: AuthCheck(),
    );
  }
}


class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {

          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {

          return HomePage();
        } else {

          return Start();
        }
      },
    );
  }
}

Future<void> getAppCheckTokenWithRetry() async {
  int retryAttempts = 0;
  final maxRetryAttempts = 5;
  final initialDelay = Duration(seconds: 1);

  while (retryAttempts < maxRetryAttempts) {
    try {
      var appCheckToken = await FirebaseAppCheck.instance.getToken();
      print("App Check Token: $appCheckToken");
      return;
    } catch (e) {
      if (retryAttempts < maxRetryAttempts) {
        retryAttempts++;
        final delay = initialDelay * retryAttempts;
        print("Retrying in $delay seconds...");
        await Future.delayed(delay);
      } else {
        print("Max retry attempts reached. Please try again later.");
        break;
      }
    }
  }
}
