import 'package:calorie_tracker/features/dish/model.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

class DishRepository with ChangeNotifier {
  DishRepository({required this.box});

  final Box<Dish> box;

  void put(Dish dish) {
    box.put(dish);
    notifyListeners();
  }

  void remove(Dish dish) {
    box.remove(dish.id);
    notifyListeners();
  }
}
