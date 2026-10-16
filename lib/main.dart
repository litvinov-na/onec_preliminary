import 'package:calorie_tracker/features/dish/model.dart';
import 'package:calorie_tracker/features/dish/repository.dart';
import 'package:calorie_tracker/features/meal/model.dart';
import 'package:calorie_tracker/features/meal/repository.dart';
import 'package:calorie_tracker/objectbox.g.dart';
import 'package:calorie_tracker/views/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _storeFuture = openStore();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _storeFuture,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }
        final store = asyncSnapshot.data!;
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => DishRepository(box: store.box<Dish>())),
            ChangeNotifierProvider(create: (context) => MealRepository(box: store.box<Meal>())),
          ],
          child: const MaterialApp(home: HomeScreen()),
        );
      },
    );
  }
}
