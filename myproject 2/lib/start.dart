import 'package:flutter/material.dart';
import 'package:untitled1/login.dart';
import 'Colors.dart';

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.07),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      fontSize: screenWidth * 0.065,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.015),
                  Text(
                    'Health Expert',
                    style: TextStyle(
                      fontSize: screenWidth * 0.055,
                      fontWeight: FontWeight.bold,
                      color: appbar,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Image(
                image: AssetImage('assets/startback.png'),
                fit: BoxFit.cover,
              ),
              height: screenHeight * 0.45,
              width: double.infinity,
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.03),
                    child: Text(
                      'Health Monitoring Mobile Application',
                      style: TextStyle(
                        fontSize: screenWidth * 0.055,
                        fontWeight: FontWeight.bold,
                        color: appname,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02,
                    ),
                    child: Text(
                      'Improve your health with tailored tips and daily reminders. Our app provides personalized insights to help you enhance your well-being and achieve a healthier, more balanced lifestyle every day.',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03,),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LogIn()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: button,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.32,
                        vertical: screenHeight * 0.012,
                      ),
                    ),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
