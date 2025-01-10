import 'package:flutter/material.dart';

class BMICalculatorPage extends StatefulWidget {
  const BMICalculatorPage({super.key});

  @override
  _BMICalculatorPageState createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _mealController = TextEditingController();
  final TextEditingController _exerciseController = TextEditingController();
  bool _isMetric = true;
  String _bmiResult = "";
  String _healthTips = "";
  List<String> _meals = [];
  List<String> _exercises = [];
  Color _resultColor = Colors.black;

  void calculateBMI() {
    final double weight = double.tryParse(_weightController.text) ?? 0.0;
    final double height = double.tryParse(_heightController.text) ?? 0.0;
    final int age = int.tryParse(_ageController.text) ?? 0;

    if (weight <= 0 || height <= 0 || age <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter valid weight, height, and age.")),
      );
      return;
    }

    double bmi;
    if (_isMetric) {
      bmi = weight / (height * height);
    } else {
      bmi = (weight / (height * height)) * 703;
    }

    String category;
    String tips;
    Color color;
    List<String> meals = [];
    List<String> exercises = [];

    if (bmi < 18.5) {
      category = "Underweight";
      color = Colors.blue;
      tips = "Focus on nutrient-dense foods and light exercises.";
      meals = ["Milk and eggs", "Avocado toast", "Nuts and seeds"];
      exercises = ["Light yoga", "Walking", "Stretching"];
    } else if (bmi >= 18.5 && bmi < 24.9) {
      category = "Normal";
      color = Colors.green;
      tips = "Maintain a balanced diet and regular exercise.";
      meals = ["Grilled chicken", "Salad with olive oil", "Smoothies"];
      exercises = ["Cycling", "Jogging", "Swimming"];
    } else if (bmi >= 25 && bmi < 29.9) {
      category = "Overweight";
      color = Colors.orange;
      tips = "Adopt a low-carb diet and engage in high-intensity workouts.";
      meals = ["Grilled fish", "Steamed vegetables", "Quinoa bowls"];
      exercises = ["HIIT", "Strength training", "Brisk walking"];
    } else {
      category = "Obese";
      color = Colors.red;
      tips = "Focus on low-calorie meals and low-impact exercises.";
      meals = ["Green smoothies", "Steamed broccoli", "Lentil soup"];
      exercises = ["Gentle stretching", "Walking", "Light resistance training"];
    }

    setState(() {
      _bmiResult = "Your BMI is ${bmi.toStringAsFixed(1)} ($category)";
      _healthTips = tips;
      _meals = meals;
      _exercises = exercises;
      _resultColor = color;
    });
  }

  void addCustomMeal() {
    if (_mealController.text.isNotEmpty) {
      setState(() {
        _meals.add(_mealController.text);
      });
      _mealController.clear();
    }
  }

  void addCustomExercise() {
    if (_exerciseController.text.isNotEmpty) {
      setState(() {
        _exercises.add(_exerciseController.text);
      });
      _exerciseController.clear();
    }
  }

  void navigateToList(String title, List<String> items) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListPage(title: title, items: items),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI Analizer"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _isMetric ? "Weight (kg)" : "Weight (lbs)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _isMetric ? "Height (m)" : "Height (inches)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Age (years)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: calculateBMI,
                child: Text("Analyse"),
              ),
            ),
            SizedBox(height: 16),
            if (_bmiResult.isNotEmpty)
              Card(
                color: _resultColor.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _bmiResult,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _resultColor),
                  ),
                ),
              ),
            if (_healthTips.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Health Tips:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(_healthTips, style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            if (_meals.isNotEmpty && _exercises.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => navigateToList("Nutrition Plan", _meals),
                      child: Text("View Nutrition Plan"),
                    ),
                    ElevatedButton(
                      onPressed: () => navigateToList("Exercise Plan", _exercises),
                      child: Text("View Exercise Plan"),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _mealController,
                      decoration: InputDecoration(
                        labelText: "Add custom meal",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: addCustomMeal,
                      child: Text("Add Meal"),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _exerciseController,
                      decoration: InputDecoration(
                        labelText: "Add custom exercise",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: addCustomExercise,
                      child: Text("Add Exercise"),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _mealController.dispose();
    _exerciseController.dispose();
    super.dispose();
  }
}

class ListPage extends StatelessWidget {
  final String title;
  final List<String> items;

  const ListPage({required this.title, required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text(items[index]),
            ),
          );
        },
      ),
    );
  }
}
