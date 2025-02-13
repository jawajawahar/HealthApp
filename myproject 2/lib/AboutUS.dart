import 'package:flutter/material.dart';
import 'package:untitled1/Colors.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbar,
        title: Text(
          'About Us',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Container(
                child: Image.asset(
                  'assets/abutus.png',
                  height: screenHeight * 0.25,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // About Us Section
              _buildSectionContainer(
                context,
                title: 'About Us',
                content:
                'We are undergraduates from Rajarata University of Sri Lanka. Our goal is to use our knowledge and skills to create innovative solutions that benefit our community and beyond. We are committed to learning, growing, and sharing our passion for technology.',
                backgroundColor: Colors.white,

              ),
              SizedBox(height: screenHeight * 0.02),


              _buildSectionContainer(
                context,
                title: 'Our Mission',
                content:
                'Our mission is to leverage technology to improve the health and wellness of individuals and communities. We aim to create high-quality healthcare monitoring applications that enhance personal health and well-being. By providing accessible tips and information, we help users lead healthier, more fulfilling lives.',
                backgroundColor: Colors.lightBlue[50],
              ),
              SizedBox(height: screenHeight * 0.02),


              Text(
                'Meet Our Developers',
                style: TextStyle(
                  fontSize: screenWidth * 0.06, // Scaled font size
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Developer List
              Column(
                children: [
                  DeveloperTile(
                    name: 'M.M.A. Abeel',
                    email: 'abeel@example.com',
                    isFemale: true,
                  ),
                  DeveloperTile(
                    name: 'M.J.F. Fasahath',
                    email: 'fasahath@example.com',
                    isFemale: true,
                  ),
                  DeveloperTile(
                    name: 'A.M. Hizam',
                    email: 'hizam@example.com',
                    isFemale: false,
                  ),
                  DeveloperTile(
                    name: 'R.M. Ihsan',
                    email: 'ihsan@example.com',
                    isFemale: false,
                  ),
                  DeveloperTile(
                    name: 'M.S.M. Jawahar',
                    email: 'jawahar@example.com',
                    isFemale: false,
                  ),
                  DeveloperTile(
                    name: 'M. Manaseer',
                    email: 'manaseer@example.com',
                    isFemale: false,
                  ),
                  DeveloperTile(
                    name: 'LM. Ashfak Sazni',
                    email: 'sazni@example.com',
                    isFemale: false,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),

              // Closing Section
              Center(
                child: Text(
                  'Thank you for choosing our app!',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSectionContainer(BuildContext context,
      {required String title, required String content, Color? backgroundColor}) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          SizedBox(height: screenWidth * 0.04),
          Text(
            content,
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              color: Colors.black87,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

// Custom widget for each developer's tile
class DeveloperTile extends StatelessWidget {
  final String name;
  final String email;
  final bool isFemale;

  DeveloperTile({required this.name, required this.email, required this.isFemale});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: ListTile(
        leading: CircleAvatar(
          radius: screenWidth * 0.08, // Scaled radius
          backgroundColor: Colors.teal[isFemale ? 300 : 500],
          child: Icon(
            isFemale ? Icons.person_2 : Icons.person,
            color: Colors.white,
            size: screenWidth * 0.07, // Scaled icon size
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          email,
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
