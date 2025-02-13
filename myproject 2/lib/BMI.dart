import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled1/BMITipsPage.dart';
import 'Colors.dart';

class BMI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BMICalculator(),
    );
  }
}

class BMICalculator extends StatefulWidget {
  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  bool isMale = true;
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  double bmi = 0.0;
  double bmiProgress = 0.0;

  @override
  void initState() {
    super.initState();
    heightController.text = '170';
    weightController.text = '65';
    ageController.text = '24';
  }

  String calculateBMI() {
    double height = double.parse(heightController.text) / 100;
    double weight = double.parse(weightController.text);
    double bmiResult = weight / (height * height);
    return bmiResult.toStringAsFixed(1);
  }

  String sanitizeEmail(String email) {
    return email.replaceAll(RegExp(r'[.\@]'), '_');
  }

  void showStyledDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          content: Text(
            content,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
              color: Colors.red,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BMITipsPage()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              child: Text(
                'Tips',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void updateBMI() async {
    setState(() {
      bmi = double.parse(calculateBMI());
      bmiProgress = bmi.clamp(0.0, 40.0);
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showStyledDialog(context, 'Error', 'User not logged in.');
      return;
    }

    String email = user.email!;
    String sanitizedEmail = sanitizeEmail(email);
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot snapshot = await firestore
        .collection('bmiRecords')
        .doc(sanitizedEmail)
        .collection('entries')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot previousRecord = snapshot.docs.first;
      double previousBmi = previousRecord['bmiResult'];
      double bmiDifference = bmi - previousBmi;

      if (bmiDifference != 0 && (bmi < 18.5 || bmi > 24.9)) {
        String differenceMessage;
        if (bmiDifference > 0) {
          differenceMessage = 'Your BMI is higher by ${bmiDifference.toStringAsFixed(1)} than the previous calculation. 📈';
        } else {
          differenceMessage = 'Your BMI is lower by ${bmiDifference.abs().toStringAsFixed(1)} than the previous calculation. 📉';
        }

        showStyledDialog(context, 'BMI Difference', differenceMessage);
      }
    }

    await firestore
        .collection('bmiRecords')
        .doc(sanitizedEmail)
        .collection('entries')
        .add({
      'bmiResult': bmi,
      'timestamp': FieldValue.serverTimestamp(),
      'height': double.parse(heightController.text),
      'weight': double.parse(weightController.text),
    });
  }

  String getBMIStatus(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight 😞';
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      return 'Healthy Weight 😀';
    } else if (bmi >= 25 && bmi <= 29.9) {
      return 'Overweight 😐';
    } else {
      return 'Obesity 😞';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbar,
        title: Text(
          'BMI Calculator',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isMale = true;
                        });
                      },
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: isMale ? Colors.teal.shade300 : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.male,
                              size: 80,
                              color: isMale ? Colors.white : Colors.black,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Male',
                              style: TextStyle(
                                fontSize: 18,
                                color: isMale ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isMale = false;
                        });
                      },
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: !isMale ? Colors.pink.shade400 : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.female,
                              size: 80,
                              color: !isMale ? Colors.white : Colors.black,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Female',
                              style: TextStyle(
                                fontSize: 18,
                                color: !isMale ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: heightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Height (cm)',
                      labelStyle: TextStyle(
                        color: appbar,
                        fontSize: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 25),
                  TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Weight (kg)',
                      labelStyle: TextStyle(
                        color: appbar,
                        fontSize: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 25),
                  TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      labelStyle: TextStyle(
                        color: appbar,
                        fontSize: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    updateBMI();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
                    minimumSize: MaterialStateProperty.all(Size(400, 50)),
                  ),
                  child: Text(
                    'Calculate BMI',
                    style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  Text(
                    'Your BMI: $bmi',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    getBMIStatus(bmi),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: bmi < 18.5 || bmi > 24.9 ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 230,
              width: 230,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: 40,
                    ranges: <GaugeRange>[
                      GaugeRange(
                        startValue: 0,
                        endValue: 18.5,
                        color: Colors.blue,
                        startWidth: 15,
                        endWidth: 15,
                      ),
                      GaugeRange(
                        startValue: 18.5,
                        endValue: 24.9,
                        color: Colors.green,
                        startWidth: 15,
                        endWidth: 15,
                      ),
                      GaugeRange(
                        startValue: 25,
                        endValue: 29.9,
                        color: Colors.orange,
                        startWidth: 15,
                        endWidth: 15,
                      ),
                      GaugeRange(
                        startValue: 30,
                        endValue: 40,
                        color: Colors.red,
                        startWidth: 15,
                        endWidth: 15,
                      ),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        value: bmiProgress,
                        needleLength: 0.6,
                        needleColor: Colors.black,
                      ),
                    ],
                    ticksPosition: ElementsPosition.outside,
                    labelOffset: 15,
                    axisLabelStyle: GaugeTextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    majorTickStyle: MajorTickStyle(
                      length: 10,
                      thickness: 2,
                      color: Colors.black,
                    ),
                    minorTickStyle: MinorTickStyle(
                      length: 5,
                      thickness: 1,
                      color: Colors.black,
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
