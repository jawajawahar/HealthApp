import 'package:flutter/material.dart';
import 'Colors.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Health Tips',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: appbar,
        iconTheme: IconThemeData(color:text),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Common Tips',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Container(
              height: 160,
              margin: const EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (context, index) {
                  List<IconData> icons = [
                    Icons.local_drink,
                    Icons.fitness_center,
                    Icons.restaurant,
                    Icons.nightlight_round,
                    Icons.mood,
                    Icons.local_drink,
                    Icons.fitness_center,
                    Icons.restaurant,
                  ];

                  List<String> tipTitles = [
                    'Stay Hydrated',
                    'Regular Exercise',
                    'Healthy Eating',
                    'Get Enough Rest',
                    'Mental Health Matters',
                    'Proper Hydration',
                    'Daily Exercise',
                    'Balanced Diet'
                  ];

                  List<String> fullInformation = [
                    'Drink at least 8 glasses of water daily to stay hydrated and maintain body function.',
                    'Engage in physical activities like jogging, swimming, or yoga at least 3 times a week.',
                    'Incorporate fruits, vegetables, and lean proteins into your meals for balanced nutrition.',
                    'Ensure you get 7-8 hours of sleep per night to help your body recover and function well.',
                    'Manage stress with meditation, hobbies, and connecting with loved ones for mental wellness.',
                    'Drink plenty of water throughout the day to support digestion, energy, and detoxification.',
                    'Exercise regularly to improve cardiovascular health, increase energy, and manage stress.',
                    'Maintain a balanced diet rich in vitamins, minerals, and proteins for optimal body function.'
                  ];

                  List<String> imageUrls = [
                    'https://www.example.com/images/hydration.jpg',
                    'https://www.example.com/images/exercise.jpg',
                    'https://www.example.com/images/healthy_eating.jpg',
                    'https://www.example.com/images/rest.jpg',
                    'https://www.example.com/images/mental_health.jpg',
                    'https://www.example.com/images/hydration.jpg',
                    'https://www.example.com/images/exercise.jpg',
                    'https://www.example.com/images/balanced_diet.jpg',
                  ];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TipDetailPage(
                            title: tipTitles[index],
                            imageUrl: imageUrls[index],
                            fullInfo: fullInformation[index],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        width: 200,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(icons[index], size: 60, color: Colors.teal),
                            const SizedBox(height: 10),
                            Text(
                              tipTitles[index],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Click to learn more!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Exercise Tips',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    _buildExpandableTip(
                      title: 'Start with Simple Exercises',
                      color: Colors.blue[50],
                      icon: Icons.fitness_center,
                      shortText: 'Begin with basic exercises like walking or light jogging.',
                      fullText:
                      'Start with low-impact exercises to build strength and stamina. Gradually increase the intensity and duration to avoid injury.',
                    ),
                    _buildExpandableTip(
                      title: 'Daily Physical Activity',
                      color: Colors.green[50],
                      icon: Icons.run_circle,
                      shortText: 'Aim for 30 minutes of physical activity daily.',
                      fullText:
                      'Try to engage in at least 30 minutes of moderate-intensity exercise every day. Activities like cycling, swimming, or brisk walking work well.',
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Nutrition Tips',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    _buildExpandableTip(
                      title: 'Eat a Balanced Diet',
                      color: Colors.orange[50],
                      icon: Icons.restaurant,
                      shortText: 'Consume a mix of proteins, carbs, and fats.',
                      fullText:
                      'Include a variety of foods in your diet, such as lean proteins, whole grains, and healthy fats. Avoid processed foods and excessive sugar.',
                    ),
                    _buildExpandableTip(
                      title: 'Hydrate After Meals',
                      color: Colors.cyan[50],
                      icon: Icons.local_drink,
                      shortText: 'Drink water after meals to aid digestion.',
                      fullText:
                      'Stay hydrated throughout the day. Drinking water after meals helps digestion and keeps the body in balance.',
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Hydration Tips',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    _buildExpandableTip(
                      title: 'Drink Water Regularly',
                      color: Colors.blue[100],
                      icon: Icons.water_drop,
                      shortText: 'Drink at least 8 glasses of water a day.',
                      fullText:
                      'Hydration is key for your body to function well. Drink water throughout the day, especially before and after exercise.',
                    ),
                    _buildExpandableTip(
                      title: 'Limit Sugary Drinks',
                      color: Colors.pink[50],
                      icon: Icons.local_cafe,
                      shortText: 'Avoid sugary drinks like sodas and energy drinks.',
                      fullText:
                      'Sugary drinks can contribute to weight gain and dehydration. Opt for water or herbal teas instead.',
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'BMI Reduction Tips',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    _buildExpandableTip(
                      title: 'Increase Physical Activity',
                      color: Colors.purple[50],
                      icon: Icons.fitness_center,
                      shortText: 'Exercise regularly to reduce BMI.',
                      fullText:
                      'Engage in both aerobic and strength-training exercises to burn calories and build muscle mass, which can help reduce BMI over time.',
                    ),
                    _buildExpandableTip(
                      title: 'Eat a Calorie Deficit Diet',
                      color: Colors.red[50],
                      icon: Icons.restaurant,
                      shortText: 'Focus on eating fewer calories than you burn.',
                      fullText:
                      'To lose weight and reduce BMI, aim to consume fewer calories than your body needs, focusing on nutrient-dense, lower-calorie foods.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableTip({
    required String title,
    required Color? color,
    required IconData icon,
    required String shortText,
    required String fullText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 15),
          leading: Icon(icon, color: Colors.teal, size: 30),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            shortText,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          children: [
            Container(
              color: color,
              padding: const EdgeInsets.all(15),
              child: Text(
                fullText,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TipDetailPage extends StatelessWidget {
  final String title;
  final String fullInfo;
  final String imageUrl;

  const TipDetailPage({
    required this.title,
    required this.fullInfo,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(imageUrl, fit: BoxFit.cover),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                fullInfo,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
