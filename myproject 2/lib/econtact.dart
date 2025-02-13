import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Colors.dart';

class EmergencyContactPage extends StatefulWidget {
  const EmergencyContactPage({super.key});

  @override
  State<EmergencyContactPage> createState() => _EmergencyContactPageState();
}

class _EmergencyContactPageState extends State<EmergencyContactPage> {
  final List<Map<String, String>> _hospitalContacts = [
    {'hospital': 'National Hospital of Sri Lanka', 'district': 'Colombo', 'contact': '011-2691111'},
    {'hospital': 'Lady Ridgeway Hospital for Children', 'district': 'Colombo', 'contact': '011-2693711'},
    {'hospital': 'Colombo South Teaching Hospital', 'district': 'Kalubowila', 'contact': '011-2442222'},
    {'hospital': 'Gampaha District General Hospital', 'district': 'Gampaha', 'contact': '033-2222261'},
    {'hospital': 'Negombo District General Hospital', 'district': 'Negombo', 'contact': '031-2232261'},
    {'hospital': 'Kandy General Hospital', 'district': 'Kandy', 'contact': '081-2233333'},
    {'hospital': 'Teaching Hospital Peradeniya', 'district': 'Peradeniya', 'contact': '081-2396200'},
    {'hospital': 'Teaching Hospital Kurunegala', 'district': 'Kurunegala', 'contact': '037-2222261'},
    {'hospital': 'Wariyapola Base Hospital', 'district': 'Kurunegala', 'contact': '037-2261234'},
    {'hospital': 'Teaching Hospital Jaffna', 'district': 'Jaffna', 'contact': '021-2222261'},
    {'hospital': 'Chavakachcheri Base Hospital', 'district': 'Chavakachcheri', 'contact': '021-2244461'},
    {'hospital': 'Teaching Hospital Karapitiya', 'district': 'Galle', 'contact': '091-2232563'},
    {'hospital': 'Balapitiya Base Hospital', 'district': 'Balapitiya', 'contact': '091-2261234'},
    {'hospital': 'Matara General Hospital', 'district': 'Matara', 'contact': '041-2232261'},
    {'hospital': 'Akuressa Base Hospital', 'district': 'Akuressa', 'contact': '041-2261234'},
    {'hospital': 'Batticaloa Teaching Hospital', 'district': 'Batticaloa', 'contact': '065-2222261'},
    {'hospital': 'Kattankudy Base Hospital', 'district': 'Kattankudy', 'contact': '065-2251234'},
    {'hospital': 'Ampara General Hospital', 'district': 'Ampara', 'contact': '063-2222261'},
    {'hospital': 'Kalmunai Base Hospital', 'district': 'Kalmunai', 'contact': '063-2256789'},
    {'hospital': 'Trincomalee General Hospital', 'district': 'Trincomalee', 'contact': '026-2222261'},
    {'hospital': 'Kinniya Base Hospital', 'district': 'Kinniya', 'contact': '026-2261234'},
    {'hospital': 'Ratnapura Teaching Hospital', 'district': 'Ratnapura', 'contact': '045-2222261'},
    {'hospital': 'Embilipitiya Base Hospital', 'district': 'Embilipitiya', 'contact': '045-2234567'},
    {'hospital': 'Anuradhapura Teaching Hospital', 'district': 'Anuradhapura', 'contact': '025-2222261'},
    {'hospital': 'Medawachchiya Base Hospital', 'district': 'Medawachchiya', 'contact': '025-2261234'},
    {'hospital': 'Polonnaruwa General Hospital', 'district': 'Polonnaruwa', 'contact': '027-2222261'},
    {'hospital': 'Hingurakgoda Base Hospital', 'district': 'Hingurakgoda', 'contact': '027-2261234'},
  ];

  final List<Map<String, String>> _ambulanceContacts = [
    {'service': 'National Ambulance Service', 'contact': '1990'},
    {'service': 'Private Ambulance Service', 'contact': '011-2549876'},
    {'service': 'Colombo Ambulance Service', 'contact': '071-2345678'},
    {'service': 'Galle Ambulance Service', 'contact': '091-2242244'},
    {'service': 'Kandy Ambulance Service', 'contact': '081-2398765'},
    {'service': 'Jaffna Ambulance Service', 'contact': '021-2222222'},
    {'service': 'Kurunegala Ambulance Service', 'contact': '037-2233445'},
    {'service': 'Batticaloa Ambulance Service', 'contact': '065-2271234'},
    {'service': 'Ampara Ambulance Service', 'contact': '063-2245678'},
    {'service': 'Trincomalee Ambulance Service', 'contact': '026-2281234'},
    {'service': 'Anuradhapura Ambulance Service', 'contact': '025-2293456'},
    {'service': 'Ratnapura Ambulance Service', 'contact': '045-2267890'},
  ];

  String _searchText = '';
  List<Map<String, String>> _filteredHospitalContacts = [];
  List<Map<String, String>> _filteredAmbulanceContacts = [];

  @override
  void initState() {
    super.initState();
    _filteredHospitalContacts = _hospitalContacts;
    _filteredAmbulanceContacts = _ambulanceContacts;
  }

  void _filterContacts(String searchText) {
    setState(() {
      _searchText = searchText.toLowerCase();
      _filteredHospitalContacts = _hospitalContacts.where((contact) {
        final hospitalName = contact['hospital']!.toLowerCase();
        final districtName = contact['district']!.toLowerCase();
        return hospitalName.contains(_searchText) || districtName.contains(_searchText);
      }).toList();

      _filteredAmbulanceContacts = _ambulanceContacts.where((contact) {
        final serviceName = contact['service']!.toLowerCase();
        return serviceName.contains(_searchText);
      }).toList();
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbar,
        title: Text(
          'Emergency Contacts',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color:text),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: TextField(
                onChanged: _filterContacts,
                decoration: InputDecoration(
                  labelText: 'Search Here...',
                  labelStyle: TextStyle(color: Colors.teal[700], fontSize: screenWidth * 0.04),
                  prefixIcon: Icon(Icons.search, color: Colors.teal[700]),
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.08),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2.0),
                    borderRadius: BorderRadius.circular(screenWidth * 0.08),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  hintText: 'Enter hospital or service name...',
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
              child: Text(
                'Hospital Contacts',
                style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.w700, color: Colors.teal),
              ),
            ),
            _buildContactList(_filteredHospitalContacts, isHospital: true),
            const Divider(thickness: 2, color: Colors.grey),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
              child: Text(
                'Ambulance Contacts',
                style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.w700, color: Colors.redAccent),
              ),
            ),
            _buildContactList(_filteredAmbulanceContacts, isHospital: false),
          ],
        ),
      ),
    );
  }

  Widget _buildContactList(List<Map<String, String>> contacts, {required bool isHospital}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return Card(
          color: Colors.teal[50],
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            title: Text(
              isHospital ? contact['hospital']! : contact['service']!,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(isHospital ? contact['district']! : 'Ambulance Service'),
            trailing: IconButton(
              icon: const Icon(Icons.call, color: Colors.teal),
              onPressed: () => _makePhoneCall(contact['contact']!),
            ),
          ),
        );
      },
    );
  }
}
