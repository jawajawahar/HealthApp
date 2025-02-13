import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Colors.dart';

class EChannelingPage extends StatefulWidget {
  const EChannelingPage({super.key});

  @override
  State<EChannelingPage> createState() => _EChannelingPageState();
}

class _EChannelingPageState extends State<EChannelingPage> {
  final List<Map<String, String>> _specialists = [
    {
      'specialist': 'ENT Specialist',
      'hospital': 'National Hospital of Sri Lanka',
      'contact': '011-2691111',
      'url': 'https://echanneling.ent-specialist.com',
      'image': 'https://cdn.prod.website-files.com/6266a573c84a6327a305c916/65a69e80ccf18dc4668d266f_ent_icon.png',
      'specialty': 'Ear, Nose, and Throat'
    },
    {
      'specialist': 'Cardiologist',
      'hospital': 'Kandy General Hospital',
      'contact': '081-2222261',
      'url': 'https://echanneling.cardiologist.com',
      'image': 'https://thumbs.dreamstime.com/z/cardiology-department-rgb-color-icon-cardiologist-consultant-heart-disease-treatment-medical-diagnosis-cardiac-surgeon-hospital-193855153.jpg',
      'specialty': 'Heart and Circulatory System'
    },
    {
      'specialist': 'Dermatologist',
      'hospital': 'Teaching Hospital Karapitiya',
      'contact': '091-2232460',
      'url': 'https://echanneling.dermatologist.com',
      'image': 'https://cdn-icons-png.flaticon.com/512/3468/3468053.png',
      'specialty': 'Skin and Dermatology'
    },
    {
      'specialist': 'Neurologist',
      'hospital': 'Jaffna Teaching Hospital',
      'contact': '021-2222261',
      'url': 'https://echanneling.neurologist.com',
      'image': 'https://www.shutterstock.com/image-vector/stethoscope-vector-icon-illustration-design-260nw-1988830835.jpg',
      'specialty': 'Brain and Nervous System'
    },
    {
      'specialist': 'Pediatrician',
      'hospital': 'Batticaloa Teaching Hospital',
      'contact': '065-2222261',
      'url': 'https://echanneling.pediatrician.com',
      'image': 'https://www.shutterstock.com/image-vector/baby-stethoscope-icon-physical-examination-260nw-1118864003.jpg',
      'specialty': 'Children\'s Health'
    },
    {
      'specialist': 'Orthopedic Surgeon',
      'hospital': 'Anuradhapura Teaching Hospital',
      'contact': '025-2222261',
      'url': 'https://echanneling.orthopedic.com',
      'image': 'https://cdn-icons-png.freepik.com/512/8175/8175789.png',
      'specialty': 'Bone and Joint Surgery'
    },
  ];

  String _searchText = '';
  List<Map<String, String>> _filteredSpecialists = [];

  @override
  void initState() {
    super.initState();
    _filteredSpecialists = _specialists;
  }

  void _filterSpecialists(String searchText) {
    setState(() {
      _searchText = searchText.toLowerCase();
      _filteredSpecialists = _specialists.where((specialist) {
        final specialistName = specialist['specialist']!.toLowerCase();
        final hospitalName = specialist['hospital']!.toLowerCase();
        return specialistName.contains(_searchText) || hospitalName.contains(_searchText);
      }).toList();
    });
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbar,
        title: const Text(
          'E Channelling',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color:text),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),  // Reduced padding
            child: TextField(
              onChanged: _filterSpecialists,
              decoration: InputDecoration(
                labelText: 'Search by specialist or hospital',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),  // Smaller border radius
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredSpecialists.length,
              itemBuilder: (context, index) {
                final specialist = _filteredSpecialists[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.03),  // Reduced margins
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),  // Smaller border radius
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(screenWidth * 0.03),  // Reduced content padding
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(specialist['image']!),
                      radius: screenWidth * 0.1,  // Reduced avatar size
                    ),
                    title: Text(
                      specialist['specialist']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04,  // Reduced font size
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${specialist['hospital']} - ${specialist['contact']}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: screenWidth * 0.035,  // Reduced font size
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          'Specialty: ${specialist['specialty']}',
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.035,  // Reduced font size
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.link, color: Colors.teal),
                      onPressed: () => _launchURL(specialist['url']!),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
