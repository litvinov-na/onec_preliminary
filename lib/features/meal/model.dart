import 'package:calorie_tracker/features/dish/model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Meal {
  Meal({this.id = 0, required this.name, required this.date, required this.dishes});

  @Id()
  int id;
  String name;
  @Property(type: PropertyType.dateUtc)
  DateTime date;
  ToMany<Dish> dishes;

  int get kCalories => dishes.fold(0, (acc, dish) => acc + dish.totalKCalories);

  @override
  bool operator ==(Object other) => other.runtimeType == runtimeType && other is Meal && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
