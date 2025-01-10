import 'package:flutter/material.dart';
import '../dataModel/meal_plan_data.dart';
import '../dataModel/model.dart';

class MealPlanDetail extends StatefulWidget {
  final MealPlan mealPlan;

  MealPlanDetail({required this.mealPlan});

  @override
  _MealPlanDetailState createState() => _MealPlanDetailState();
}

class _MealPlanDetailState extends State<MealPlanDetail> {
  String selectedMealType = 'Breakfast';

  @override
  Widget build(BuildContext context) {
    final meals = widget.mealPlan.meals[selectedMealType] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mealPlan.title,
          style: const TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red[900]!, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['Breakfast', 'Lunch', 'Dinner'].map((mealType) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedMealType == mealType
                          ? Colors.white
                          : Colors.red[700],
                      foregroundColor: selectedMealType == mealType
                          ? Colors.black
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadowColor: Colors.redAccent,
                      elevation: 8,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedMealType = mealType;
                      });
                    },
                    child: Text(
                      mealType,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Meal Description
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.mealPlan.description,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red[800]!, Colors.black],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.fastfood,
                            color: Colors.white,
                            size: 30,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              meals[index],
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
