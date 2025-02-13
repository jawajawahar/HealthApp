import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final _firestore = FirebaseFirestore.instance;
  final _picker = ImagePicker();
  File? _selectedImage;
  DateTime? _selectedDateTime;
  String? _dosage;
  String? _name;
  bool _isLoading = false;
  List<Map<String, dynamic>> _alarms = [];
  Timer? _notificationTimer;
  bool _isReminderActive = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _fetchAlarms();
  }

  Future<void> _initializeNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _notificationsPlugin.initialize(initSettings);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveAlarm() async {
    if (_selectedDateTime == null ||
        _selectedImage == null ||
        _dosage == null ||
        _dosage!.isEmpty ||
        _name == null ||
        _name!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the details')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload image to Firebase Storage
      final imagePath = 'alarms/${DateTime.now().millisecondsSinceEpoch}.png';
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      await ref.putFile(_selectedImage!);
      final imageUrl = await ref.getDownloadURL();

      // Save alarm details to Firestore
      final alarmId = DateTime.now().millisecondsSinceEpoch.toString();
      await _firestore.collection('alarms').doc(alarmId).set({
        'id': alarmId,
        'datetime': _selectedDateTime!.toIso8601String(),
        'imageUrl': imageUrl,
        'dosage': _dosage,
        'name': _name,
      });

      // Schedule a notification for the alarm
      _scheduleNotification(_selectedDateTime!, 'Medication Reminder', _name!, imageUrl, alarmId);

      // Fetch alarms to update the UI
      _fetchAlarms();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alarm set successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchAlarms() async {
    final snapshot = await _firestore.collection('alarms').get();
    final alarms = snapshot.docs
        .map((doc) => {
      'id': doc['id'],
      'datetime': doc['datetime'],
      'imageUrl': doc['imageUrl'],
      'dosage': doc['dosage'],
      'name': doc['name'],
    })
        .toList();

    setState(() {
      _alarms = alarms;
    });
  }

  void _scheduleNotification(DateTime alarmTime, String title, String body, String imageUrl, String alarmId) {
    final duration = alarmTime.difference(DateTime.now());
    Timer(duration, () async {
      // Schedule the alarm notification
      await _notificationsPlugin.show(
        int.parse(alarmId), // Use the alarm ID as notification ID
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'alarm_channel',
            'Alarm Notifications',
            importance: Importance.max,
            priority: Priority.high,
            styleInformation: BigPictureStyleInformation(
              FilePathAndroidBitmap(_selectedImage!.path),
              contentTitle: title,
              summaryText: body,
            ),
          ),
        ),
      );
    });
  }

  void _stopAlarm(String alarmId) {
    _notificationsPlugin.cancel(int.parse(alarmId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alarm stopped')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Alarm'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Date and Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (selectedDate != null) {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (selectedTime != null) {
                    setState(() {
                      _selectedDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    });
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedDateTime == null
                      ? 'Select Date & Time'
                      : _selectedDateTime!.toString(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                _name = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter name',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Dosage Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                _dosage = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter dosage details',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Image',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  image: _selectedImage != null
                      ? DecorationImage(
                    image: FileImage(_selectedImage!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: _selectedImage == null
                    ? const Center(child: Text('Tap to select image'))
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAlarm,
              child: const Text('Set Alarm'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Saved Alarms',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ..._alarms.map((alarm) => Card(
              child: ListTile(
                title: Text(alarm['name']),
                subtitle: Text(
                    'Time: ${alarm['datetime']}\nDosage: ${alarm['dosage']}'),
                leading: Image.network(alarm['imageUrl']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _stopAlarm(alarm['id']);
                  },
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
