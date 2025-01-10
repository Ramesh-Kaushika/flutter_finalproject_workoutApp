class MealPlan {
  final String title;
  final String description;
  final String imageUrl;
  final Map<String, List<String>> meals;

  MealPlan({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.meals,
  });
}
