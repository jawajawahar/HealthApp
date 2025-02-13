import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/Colors.dart';
import 'package:untitled1/BMI.dart';
import 'package:untitled1/echanneling.dart';
import 'package:untitled1/econtact.dart';
import 'package:untitled1/healthtips.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Other extends StatefulWidget {
  const Other({super.key});

  @override
  State<Other> createState() => _OtherState();
}

class _OtherState extends State<Other> {
  Timer? _emojiTimer;
  bool _showEmojis = true;

  @override
  void initState() {
    super.initState();
    _checkEmojiVisibility();
    _startEmojiTimer();
  }

  @override
  void dispose() {
    _emojiTimer?.cancel();
    super.dispose();
  }

  void _startEmojiTimer() {
    _emojiTimer = Timer.periodic(Duration(minutes: 10), (timer) {
      _checkEmojiVisibility();
    });
  }

  Future<void> _checkEmojiVisibility() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? lastClickedTimestamp = prefs.getInt('emojiClickedTimestamp');
    if (lastClickedTimestamp == null ||
        DateTime.now()
            .difference(DateTime.fromMillisecondsSinceEpoch(lastClickedTimestamp))
            .inMinutes >= 2) {

      setState(() {
        _showEmojis = true;
      });
    } else {
      setState(() {
        _showEmojis = false;
      });
    }
  }

  Future<void> _onEmojiClicked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('emojiClickedTimestamp', DateTime.now().millisecondsSinceEpoch);

    setState(() {
      _showEmojis = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Other Services',
          style: TextStyle(fontWeight: FontWeight.bold, color: appname, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 10),
        child: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildServiceCard(
                  context,
                  Icons.calculate,
                  'BMI Calculator',
                  BMICalculator(),
                ),
                SizedBox(width: 30),
                buildServiceCard(
                  context,
                  Icons.event_note_rounded,
                  'Health Tips',
                  TipsPage(),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildServiceCard(
                  context,
                  Icons.ring_volume,
                  'Emergency',
                  EmergencyContactPage(),
                ),
                SizedBox(width: 30),
                buildServiceCard(
                  context,
                  Icons.medical_services_rounded,
                  'e-Channeling',
                  EChannelingPage(),
                ),
              ],
            ),
            SizedBox(height: 40,),

            if (_showEmojis)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "How are you feeling today?",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 15),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 15,
                      children: [
                        buildFeelingEmoji("😊", "Happy", Colors.yellow, "You're feeling great!", "https://media.giphy.com/media/26n6WjGiHLPfUw5Is/giphy.gif"),
                        buildFeelingEmoji("😞", "Sad", Colors.blue, "You're feeling down.", "https://media.giphy.com/media/3o6fI9DIfLLk7AizkE/giphy.gif"),
                        buildFeelingEmoji("😐", "Neutral", Colors.grey, "You're feeling neutral.", "https://media.giphy.com/media/9wYy6kk8Zhzpi/giphy.gif"),
                        buildFeelingEmoji("😡", "Angry", Colors.red, "You're feeling angry!", "https://media.giphy.com/media/10a2i46zOHDQbm/giphy.gif"),
                        buildFeelingEmoji("😴", "Sleepy", Colors.purple, "You're feeling sleepy.", "https://media.giphy.com/media/3o7btYyfW3Sjb7VGHu/giphy.gif"),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildFeelingEmoji(String emoji, String feelingName, Color color, String description, String gifUrl) {
    return GestureDetector(
      onTap: () {
        _onEmojiClicked();
        _showFeelingDialog(feelingName, color, emoji, description, gifUrl);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emoji,
            style: TextStyle(fontSize: 40, color: color),
          ),
          SizedBox(height: 8),
          Text(
            feelingName,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }


  Future<void> _showFeelingDialog(String feelingName, Color color, String emoji, String description, String gifUrl) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            child: Container(
              color: color,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: gifUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 30),
                  Text(
                    feelingName,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    description,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget buildServiceCard(BuildContext context, IconData icon, String label, Widget targetPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.grey[200],
        ),
        height: MediaQuery.of(context).size.height / 5.5,
        width: MediaQuery.of(context).size.width / 2 - 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
              color: appbar,
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
