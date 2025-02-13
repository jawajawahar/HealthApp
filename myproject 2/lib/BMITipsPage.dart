import 'package:flutter/material.dart';
import 'Colors.dart';

class BMITipsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbar,
        title: Text(
          'BMI Tips',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips for Maintaining a Healthy BMI:',
                  style: TextStyle(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildTip(
                  '1. Eat a Balanced Diet',
                  'Include a variety of fruits, vegetables, whole grains, and lean proteins in your diet. Limit intake of processed foods, sugars, and fats.',
                  Icons.fastfood,
                  screenWidth,
                  screenHeight,
                ),
                _buildTip(
                  '2. Be Physically Active',
                  'Aim for at least 150 minutes of moderate-intensity physical activity or 75 minutes of vigorous activity each week.',
                  Icons.directions_run,
                  screenWidth,
                  screenHeight,
                ),
                _buildTip(
                  '3. Maintain a Healthy Weight',
                  'Achieving and maintaining a healthy weight is crucial for overall health. Consuming fewer calories than you burn can help you lose weight or prevent weight gain.',
                  Icons.fitness_center,
                  screenWidth,
                  screenHeight,
                ),
                _buildTip(
                  '4. Drink Plenty of Water',
                  'Drink at least 6-8 glasses of water per day to stay hydrated and help manage appetite.',
                  Icons.water_drop,
                  screenWidth,
                  screenHeight,
                ),
                _buildTip(
                  '5. Get Enough Sleep',
                  'Aim for 7-9 hours of quality sleep per night. Poor sleep patterns can contribute to weight gain and obesity.',
                  Icons.nightlight_round,
                  screenWidth,
                  screenHeight,
                ),
                _buildTip(
                  '6. Reduce Stress',
                  'Chronic stress can lead to unhealthy eating behaviors and weight gain. Practice relaxation techniques like meditation or yoga.',
                  Icons.self_improvement,
                  screenWidth,
                  screenHeight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTip(String title, String description, IconData icon, double screenWidth, double screenHeight) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: screenWidth * 0.1,
              backgroundColor: Colors.grey[300],
              child: Icon(
                icon,
                color: Colors.black87,
                size: screenWidth * 0.08,
              ),
            ),
            SizedBox(width: screenWidth * 0.05),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black87,
                      fontFamily: 'Roboto',
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
