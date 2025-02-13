import 'package:flutter/material.dart';
import 'alarm_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:untitled1/Colors.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final List<Map<String, dynamic>> _alarms = [];
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final Map<int, bool> _alarmActiveMap = {};

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: androidInitializationSettings);
    await _notificationsPlugin.initialize(initializationSettings);
  }

  void _addAlarm(Map<String, dynamic> alarm) {
    setState(() {
      _alarms.add(alarm);
      _alarmActiveMap[_alarms.length - 1] = false;
    });

    _scheduleRepeatingNotification(alarm, _alarms.length - 1);
  }

  Future<void> _scheduleRepeatingNotification(Map<String, dynamic> alarm, int index) async {
    final androidDetails = AndroidNotificationDetails(
      'alarm_channel_$index',
      'Medication Alarm',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: BigPictureStyleInformation(
        FilePathAndroidBitmap(alarm['imagePath']),
        contentTitle: alarm['name'],
        summaryText: 'Dosage: ${alarm['dosage']}',
      ),
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    if (_alarmActiveMap[index] == true) return;

    setState(() {
      _alarmActiveMap[index] = true;
    });

    await _notificationsPlugin.periodicallyShow(
      index,
      alarm['name'],
      'Time to take your medication',
      RepeatInterval.everyMinute,
      notificationDetails,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> _stopNotification(int index) async {
    await _notificationsPlugin.cancel(index);
    setState(() {
      _alarmActiveMap[index] = false;
    });
  }

  Future<void> _cancelAlarm(int index) async {
    await _notificationsPlugin.cancel(index);
    setState(() {
      _alarms.removeAt(index);
      _alarmActiveMap.remove(index);
    });
  }

  Future<void> _editAlarm(int index) async {
    final editedAlarm = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlarmPage(
          alarm: _alarms[index], // Pass the existing alarm data to edit
        ),
      ),
    );

    if (editedAlarm != null) {
      setState(() {
        _alarms[index] = editedAlarm; // Update the alarm with the edited data
      });
      // Optionally, cancel and reschedule the notification with updated data
      _stopNotification(index);
      _scheduleRepeatingNotification(editedAlarm, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Reminders', style: TextStyle(
          fontWeight: FontWeight.bold, color: appbar, fontSize: 25,
        )),
        centerTitle: true,
      ),
      body: _alarms.isEmpty
          ? const Center(
        child: Text(
          'No alarms yet. Click the "+" button to set one.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _alarms.length,
        itemBuilder: (context, index) {
          final alarm = _alarms[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: alarm['imageUrl'] != null
                  ? CircleAvatar(
                backgroundImage: NetworkImage(alarm['imageUrl']),
              )
                  : const Icon(Icons.alarm, size: 36, color: Colors.teal),
              title: Text(alarm['name']),
              subtitle: Text(
                'Dosage: ${alarm['dosage']}\nTime: ${alarm['datetime']}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // On/Off Switch for Alarm
                  Switch(
                    value: _alarmActiveMap[index] ?? false,
                    onChanged: (value) {
                      setState(() {
                        if (value) {
                          _scheduleRepeatingNotification(_alarms[index], index);
                        } else {
                          _stopNotification(index);
                        }
                        _alarmActiveMap[index] = value;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                  // Edit Button
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editAlarm(index), // Call the edit function
                  ),
                  // Cancel Button
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.grey),
                    onPressed: () => _cancelAlarm(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newAlarm = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AlarmPage()),
          );
          if (newAlarm != null) {
            _addAlarm(newAlarm);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
