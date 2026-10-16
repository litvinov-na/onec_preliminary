import 'package:calorie_tracker/features/meal/model.dart';
import 'package:calorie_tracker/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

class MealRepository with ChangeNotifier {
  MealRepository({required this.box});

  final Box<Meal> box;

  List<List<Meal>> byWeek(DateTime date) {
    final result = <List<Meal>>[];
    final weekStart = date.weekStart;
    for (int i = 0; i < 7; ++i) {
      final dayStart = weekStart.add(Duration(days: i));
      final dayEnd = dayStart.add(Duration(days: 1));
      result.add(
        box
            .getAll()
            .where(
              (meal) =>
                  meal.date.isAtSameMomentAs(dayStart) || (meal.date.isAfter(dayStart) && meal.date.isBefore(dayEnd)),
            )
            .toList(),
      );
    }
    return result;
  }

  void put(Meal meal) {
    box.put(meal);
    notifyListeners();
  }

  void remove(Meal meal) {
    box.remove(meal.id);
    notifyListeners();
  }
}
