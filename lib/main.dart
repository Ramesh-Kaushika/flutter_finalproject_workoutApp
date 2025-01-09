import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const WorkoutApp());
}

class WorkoutApp extends StatelessWidget {
  const WorkoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WorkoutDashboard(),
      routes: {
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

class WorkoutDashboard extends StatefulWidget {
  const WorkoutDashboard({super.key});

  @override
  _WorkoutDashboardState createState() => _WorkoutDashboardState();
}

class _WorkoutDashboardState extends State<WorkoutDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workout App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: "Dashboard"),
            Tab(icon: Icon(Icons.timer), text: "Stopwatch"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(context),
          const StopwatchTab(),
        ],
      ),
    );
  }

  Widget _buildDashboardTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Back,",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "John Doe",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 30,
                backgroundImage:
                    AssetImage('assets/profile.jpg'), // Add a profile image
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Statistics Section
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatistic("Calories", "560", "kcal"),
                  _buildStatistic("Steps", "7,800", "steps"),
                  _buildStatistic("Workouts", "12", "sessions"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Workout Categories
          const Text(
            "Workout Categories",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildCategoryCard("Cardio", Icons.directions_run, Colors.blue),
              _buildCategoryCard(
                  "Strength", Icons.fitness_center, Colors.orange),
              _buildCategoryCard(
                  "Yoga", Icons.self_improvement, Colors.green),
              _buildCategoryCard("HIIT", Icons.timer, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatistic(String title, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          "$title ($unit)",
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class StopwatchTab extends StatefulWidget {
  const StopwatchTab({super.key});

  @override
  _StopwatchTabState createState() => _StopwatchTabState();
}

class _StopwatchTabState extends State<StopwatchTab> {
  late Stopwatch _stopwatch;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_stopwatch.isRunning) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatTime(_stopwatch.elapsedMilliseconds);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formattedTime,
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_stopwatch.isRunning) {
                    _stopwatch.stop();
                  } else {
                    _stopwatch.start();
                  }
                  setState(() {});
                },
                child: Text(_stopwatch.isRunning ? "Pause" : "Start"),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  _stopwatch.reset();
                  setState(() {});
                },
                child: const Text("Reset"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(int milliseconds) {
    int seconds = (milliseconds / 1000).truncate();
    int minutes = (seconds / 60).truncate();
    seconds = seconds % 60;
    int millis = (milliseconds % 1000) ~/ 10;

    return "${_twoDigits(minutes)}:${_twoDigits(seconds)}.${_twoDigits(millis)}";
  }

  String _twoDigits(int n) => n.toString().padLeft(2, "0");
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log Out"),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Log Out"),
                    content: const Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text("Log Out"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
