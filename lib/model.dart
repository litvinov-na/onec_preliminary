import 'package:objectbox/objectbox.dart';

@Entity()
class Dish({
  @Id() required var int id,
  required var String name,
  required var int calories,
  required var int carbs,
  required var int fats,
  required var int protein,
});

@Entity()
class Meal({@Id() required var int id, required var DateTime time, required var List<Dish> dishes});
