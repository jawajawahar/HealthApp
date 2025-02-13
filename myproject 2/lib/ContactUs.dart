import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Colors.dart';

class HelpSupport extends StatefulWidget {
  @override
  _HelpSupportState createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  final String contactEmail = 'healthexpert165@gmail.com';
  final String contactName = 'Health Expert Support';
  final String contactAddress = 'Faculty of Technology, Rajarata University of Sri Lanka';
  final String contactPhone = '+123 456 7890';

  void openEmailApp() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: contactEmail,
      queryParameters: {
        'subject': 'Support Inquiry',
      },
    );

    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Error"),
          content: Text("Could not open email application. Please check your email settings."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: appbar,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.support_agent,
                    color: Colors.teal.shade800,
                    size: screenWidth * 0.2,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'We\'re here to help!',
                    style: TextStyle(fontSize: screenWidth * 0.065, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Feel free to reach out with any questions or concerns.',
                    style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Divider(color: Colors.teal.shade200, thickness: 1.5),
            SizedBox(height: screenHeight * 0.02),
            _buildSectionTitle('Contact Information', screenWidth),
            SizedBox(height: screenHeight * 0.02),
            _buildContactCard(Icons.person, 'Name:', contactName, screenWidth),
            _buildContactCard(Icons.email, 'Email:', contactEmail, screenWidth),
            _buildContactCard(Icons.phone, 'Phone:', contactPhone, screenWidth),
            _buildContactCard(Icons.location_on, 'Address:', contactAddress, screenWidth, isMultiLine: true),
            SizedBox(height: screenHeight * 0.05),
            Center(
              child: ElevatedButton.icon(
                onPressed: openEmailApp,
                icon: Icon(Icons.email, color: Colors.white),
                label: Text('Email Us', style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2, vertical: screenHeight * 0.02),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Text(
        title,
        style: TextStyle(fontSize: screenWidth * 0.055, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String label, String value, double screenWidth, {bool isMultiLine = false}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Row(
          crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.teal.shade800, size: screenWidth * 0.07),
            SizedBox(width: screenWidth * 0.05),
            Text(
              label,
              style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(width: screenWidth * 0.02),
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.black54),
                overflow: TextOverflow.ellipsis,
                maxLines: isMultiLine ? 3 : 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
