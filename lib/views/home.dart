import 'package:calorie_tracker/views/dishes.dart';
import 'package:calorie_tracker/views/meals.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calorie Tracker')),
      body: IndexedStack(index: _index, children: const [MealsPage(), DishesPage()]),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => setState(() => _index = value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Dishes'),
        ],
      ),
    );
  }
}
