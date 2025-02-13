import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AlarmPage extends StatefulWidget {
  final Map<String, dynamic>? alarm;

  const AlarmPage({Key? key, this.alarm}) : super(key: key);

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final _picker = ImagePicker();
  File? _selectedImage;
  DateTime? _selectedDateTime;
  String? _dosage;
  String? _name;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.alarm != null) {
      _name = widget.alarm!['name'];
      _dosage = widget.alarm!['dosage'];
      _selectedDateTime = DateTime.parse(widget.alarm!['datetime']);
      _selectedImage = File(widget.alarm!['imagePath']);
    }
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
      String imageUrl = '';


      if (_selectedImage != null) {
        final imagePath = 'alarms/${DateTime.now().millisecondsSinceEpoch}.png';
        final ref = FirebaseStorage.instance.ref().child(imagePath);
        await ref.putFile(_selectedImage!);
        imageUrl = await ref.getDownloadURL();
      } else {

        imageUrl = widget.alarm?['imageUrl'] ?? '';
      }

      final alarm = {
        'datetime': _selectedDateTime!.toIso8601String(),
        'imagePath': _selectedImage?.path ?? widget.alarm?['imagePath'],
        'imageUrl': imageUrl,
        'dosage': _dosage,
        'name': _name,
      };

      Navigator.pop(context, alarm);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Set Alarm',
          style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        iconTheme: const IconThemeData(color: Colors.teal),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCard(
                icon: Icons.access_time_filled,
                title: 'Date & Time',
                child: _buildDateTimePicker(),
              ),
              _buildCard(
                icon: Icons.text_fields,
                title: 'Medicine Name',
                child: _buildTextField(
                  hintText: 'Enter the Medicine name',
                  initialValue: _name,
                  onChanged: (value) => _name = value,
                ),
              ),
              _buildCard(
                icon: Icons.medical_services,
                title: 'Dosage Details',
                child: _buildTextField(
                  hintText: 'Enter dosage details',
                  initialValue: _dosage,
                  onChanged: (value) => _dosage = value,
                ),
              ),
              _buildCard(
                icon: Icons.photo_camera,
                title: 'Attach Image',
                child: Column(
                  children: [
                    _buildImagePicker(),
                    if (_selectedImage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Image.file(_selectedImage!),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _saveAlarm,
                icon: const Icon(Icons.save, size: 24),
                label: const Text(
                  'Save Alarm',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.teal, size: 30),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDateTime ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );

        if (selectedDate != null) {
          final selectedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          _selectedDateTime == null
              ? 'Select Date & Time'
              : '${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year}  ${_selectedDateTime!.hour}:${_selectedDateTime!.minute}',
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    String? initialValue,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: hintText,
      ),
    );
  }

  Widget _buildImagePicker() {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image, size: 20),
          label: const Text('Choose Image'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _selectedImage == null
            ? const Text('❌ No image selected')
            : const Text('✅ Image selected'),
      ],
    );
  }
}
