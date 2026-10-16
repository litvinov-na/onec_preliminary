import 'package:calorie_tracker/features/dish/repository.dart';
import 'package:calorie_tracker/features/meal/repository.dart';
import 'package:calorie_tracker/features/meal/ui/editor.dart';
import 'package:calorie_tracker/utils/date.dart';
import 'package:calorie_tracker/widgets/dialog.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MealsPage extends StatefulWidget {
  const MealsPage({super.key});

  @override
  State<MealsPage> createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  DateTime _date = DateTime.now().weekStart;
  final PageController _pageController = PageController(initialPage: DateTime.now().weekday - 1);
  
  int get _weekDayIndex => _pageController.hasClients ? _pageController.page!.round() : DateTime.now().weekday - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dish's macros may change
    context.watch<DishRepository>();
    final mealRepo = context.watch<MealRepository>();
    final byWeek = mealRepo.byWeek(_date);
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              barGroups: byWeek.indexed.map((item) {
                final kCalories = item.$2.fold(0, (acc, meal) => acc + meal.kCalories);
                return BarChartGroupData(
                  x: item.$1,
                  barRods: [
                    BarChartRodData(
                      toY: kCalories.toDouble(),
                      label: BarChartRodLabel(text: '$kCalories'),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => setState(() => _date = _date.subtract(const Duration(days: 7))),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '${DateFormat.MMMd().format(_date)} - ${DateFormat.MMMd().format(_date.add(const Duration(days: 6)))}',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => setState(() => _date = _date.add(const Duration(days: 7))),
            ),
          ],
        ),
        Text(DateFormat.MMMd().format(_date.add(Duration(days: _weekDayIndex)))),
        Expanded(
          child: PageView.builder(
            onPageChanged: (value) => setState(() {}),
            itemCount: byWeek.length,
            itemBuilder: (context, index) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: byWeek[_weekDayIndex].length,
                itemBuilder: (context, index) {
                  final meal = byWeek[_weekDayIndex][index];
                  return ListTile(
                    onLongPress: () async {
                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) => ConfirmationDialog(actionText: 'Delete'),
                      );
                      if (shouldDelete == true) {
                        mealRepo.remove(meal);
                      }
                    },
                    title: Text(meal.name),
                    subtitle: Text('${meal.kCalories} kcal'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final editedMeal = await MealEditor.dialog(context: context, meal: meal);
                        if (editedMeal == null) return;
                        mealRepo.put(editedMeal);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FilledButton(
            onPressed: () async {
              final newMeal = await MealEditor.dialog(context: context, meal: null);
              if (newMeal != null) mealRepo.put(newMeal);
            },
            child: Text('Add new meal'),
          ),
        ),
      ],
    );
  }
}
