import 'package:objectbox/objectbox.dart';

@Entity()
class Dish {
  Dish({
    this.id = 0,
    required this.name,
    required this.grams,
    required this.kCalories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });

  @Id()
  int id = 0;
  String name;
  int grams;
  // per 100g:
  int kCalories;
  int protein;
  int carbs;
  int fats;

  int get totalKCalories => (kCalories * grams / 100).round();

  String get macrosText {
    return 'P/C/F:'
        '${(protein * grams / 100).round()}/'
        '${(carbs * grams / 100).round()}/'
        '${(fats * grams / 100).round()}\n'
        'Calories: ${(kCalories * grams / 100).round()} (${grams}g) | $kCalories kcal/100g';
  }
}
