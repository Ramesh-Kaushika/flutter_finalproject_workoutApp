import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyGymApp());
}

class MyGymApp extends StatelessWidget {
  const MyGymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InputPage(),
    );
  }
}

// Page 1: Input Age, Weight, and Height
class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  bool isNextEnabled = false;

  void checkIfNextEnabled() {
    setState(() {
      isNextEnabled = ageController.text.isNotEmpty &&
          weightController.text.isNotEmpty &&
          heightController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    ageController.addListener(checkIfNextEnabled);
    weightController.addListener(checkIfNextEnabled);
    heightController.addListener(checkIfNextEnabled);
  }

  @override
  void dispose() {
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Step 1: Enter Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: "Enter your age"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: weightController,
              decoration:
                  const InputDecoration(labelText: "Enter your weight (kg)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: heightController,
              decoration:
                  const InputDecoration(labelText: "Enter your height (cm)"),
              keyboardType: TextInputType.number,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: isNextEnabled
                  ? () {
                      double? weight = double.tryParse(weightController.text);
                      double? height = double.tryParse(heightController.text);
                      double bmi = weight! / ((height! / 100) * (height / 100));
                      String bmiCategory = '';
                      if (bmi < 18.5) {
                        bmiCategory = "Underweight";
                      } else if (bmi >= 18.5 && bmi < 24.9) {
                        bmiCategory = "Normal weight";
                      } else if (bmi >= 25 && bmi < 29.9) {
                        bmiCategory = "Overweight";
                      } else {
                        bmiCategory = "Obesity";
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BMIPage(
                            bmi: bmi,
                            bmiCategory: bmiCategory,
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}

// Page 2: Show BMI Details
class BMIPage extends StatelessWidget {
  final double bmi;
  final String bmiCategory;

  const BMIPage({super.key, required this.bmi, required this.bmiCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Step 2: BMI Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your BMI: ${bmi.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Category: $bmiCategory",
              style: const TextStyle(fontSize: 16, color: Colors.blue),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GoalPage()),
                );
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}

// Page 3: Input Weight Loss Goal and Age Gap
class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  final TextEditingController goalController = TextEditingController();
  String? selectedAgeRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Goal and Age Gap")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: goalController,
              decoration: const InputDecoration(
                  labelText: "Enter your weight loss goal (kg)"),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: selectedAgeRange,
              hint: const Text("Select Age Range"),
              items: ['18-25', '26-35', '36-45'].map((range) {
                return DropdownMenuItem(value: range, child: Text(range));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedAgeRange = value;
                });
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Back"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SchedulePage(
                          selectedAgeRange: selectedAgeRange,
                        ),
                      ),
                    );
                  },
                  child: const Text("Next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SchedulePage extends StatelessWidget {
  final String? selectedAgeRange;

  const SchedulePage({super.key, this.selectedAgeRange});

  List<Map<String, String>> getScheduleWithVideos() {
    if (selectedAgeRange == '18-25') {
      return [
        {
          "title": "Push-ups",
          "description": "Strengthens arms and chest muscles. 30 * 3",
          "videoUrl": "lib/assets/videos/How_to_Do_PUSH_UPS.mp4",
        },
        {
          "title": "Squats",
          "description": "Targets leg muscles and improves balance. 30 * 3",
          "videoUrl": "lib/assets/videos/How_to_Do_SQUATS.mp4",
        },
        {
          "title": "Sit-ups",
          "description": "Helps tone and strengthen abdominal muscles. 30 * 3",
          "videoUrl": "lib/assets/videos/How_to_Do_SIT_UPS_(1).mp4",
        },
        {
          "title": "Dynamic-Chest",
          "description":
              "multiple muscles in the chest, shoulders, and upper back.30 * 3",
          "videoUrl": "lib/assets/videos/How_to_Do_DYNAMIC_CHEST.mp4",
        },
        {
          "title": "Standing Bicycle Crunches",
          "description":
              "Standing crunches are a full-body exercise that activates muscles in your upper and lower body, including your core, glutes, and abdominal muscles. 30 * 3",
          "videoUrl":
              "lib/assets/videos/How_to_Do_STANDING_BICYCLE_CRUNCHES.mp4",
        },
      ];
    } else if (selectedAgeRange == '26-35') {
      return [
        {
          "title": "Side Crunches",
          "description":
              "Side crunches, also known as oblique crunches, are an effective exercise that targets the abdominal and oblique muscles. 30 * 3",
          "videoUrl": "lib/assets/videos/How_to_Do_SIDE_CRUNCHES_(1).mp4",
        },
        {
          "title": "Russian Twist",
          "description":
              "Russian twists work many muscles in your core, including your obliques, rectus abdominis, and transverse abdominis. 30 * 3",
          "videoUrl": "lib/assets/videos/How_to_Do_RUSSIAN_TWIST.mp4",
        },
        {
          "title": "Leg Raises",
          "description":
              "Leg raises are effective for targeting the obliques and upper and lower rectus abdominis muscles. 30 * 3",
          "videoUrl": "lib/assets/videos/How_to_Do_LEG_RAISES.mp4",
        },
        {
          "title": "Jumping Jacks",
          "description":
              "Jumping jacks are a full-body exercise that work many muscles, including the calves, glutes, hamstrings, quadriceps, core, and arms. 30 * 3",
          "videoUrl": "lib/assets/videos/How_to_Do_JUMPING_JACKS.mp4",
        },
        {
          "title": "High Stepping",
          "description":
              "High stepping exercises strengthen the calf muscles, Achilles tendons, and toes. 30 * 3",
          "videoUrl": "lib/assets/videos/How_to_Do_HIGH_STEPPING.mp4",
        },
      ];
    } else if (selectedAgeRange == '36-45') {
      return [
        {
          "title": "Heel Touch",
          "description":
              "Heel touches work many muscles in your core, including your obliques, rectus abdominis, and transverse abdominis. 30 * 3",
          "videoUrl": "lib/assets/videos/How_to_Do_HEEL_TOUCH.mp4",
        },
        {
          "title": "Flutter Kicks",
          "description":
              "ower abs and hip flexors, as well as engaging your quad muscles. 30 * 3",
          "videoUrl": "lib/assets/videos/How_to_Do_FLUTTER_KICKS_(1).mp4",
        },
        {
          "title": "Cobra Stretch",
          "description":
              "Strengthens the spine and many muscles in the back of the body including spinal extensors, gluteus maximus, and hamstrings. 30 * 3",
          "videoUrl": "lib/assets/videos/How_to_Do_COBRA_STRETCH.mp4",
        },
        {
          "title": "Abdominal Crunches",
          "description":
              "Abdominal crunches primarily target the rectus abdominis muscle. 30 * 3",
          "videoUrl": "lib/assets/videos/How_to_Do_ABDOMINAL_CRUNCHES.mp4",
        },
      ];
    } else {
      return [
        {
          "title": "Custom Schedule",
          "description": "Define your exercises!",
          // "videoUrl": ""
        },
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> exercises = getScheduleWithVideos();

    return Scaffold(
      appBar: AppBar(title: const Text(" Your Schedule")),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return ExerciseCard(
            title: exercises[index]["title"]!,
            description: exercises[index]["description"]!,
            videoUrl: exercises[index]["videoUrl"]!,
          );
        },
      ),
    );
  }
}

class ExerciseCard extends StatefulWidget {
  final String title;
  final String description;
  final String videoUrl;

  const ExerciseCard({
    super.key,
    required this.title,
    required this.description,
    required this.videoUrl,
  });

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl.isNotEmpty) {
      _controller = VideoPlayerController.asset(widget.videoUrl)
        ..initialize().then((_) {
          setState(() {}); // Update UI after video is initialized
        }).catchError((error) {
          print("Video loading error: $error");
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(widget.description),
            SizedBox(height: 16),
            if (widget.videoUrl.isNotEmpty && _controller != null)
              _controller!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    )
                  : Center(child: CircularProgressIndicator()),
            SizedBox(height: 16),
            if (widget.videoUrl.isNotEmpty && _controller != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _controller!.play();
                    },
                    child: Text("Play"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _controller!.pause();
                    },
                    child: Text("Pause"),
                  ),
                ],
              ),
            if (widget.videoUrl.isEmpty)
              Text(
                "Video not available for this exercise.",
                style:
                    TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
    );
  }
}
