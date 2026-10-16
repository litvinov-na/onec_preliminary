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
  int _weekDayIndex = 0;

  @override
  Widget build(BuildContext context) {
    final mealRepo = context.watch<MealRepository>();
    final byWeek = mealRepo.byWeek(_date);
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final oneSeventh = constraints.maxWidth / 7;
              return BarChart(
                BarChartData(
                  barGroups: byWeek
                      .map((meals) => BarChartGroupData(x: meals.fold(0, (acc, meal) => acc + meal.kCalories)))
                      .toList(),
                  barTouchData: BarTouchData(
                    touchCallback: (event, response) {
                      if (response == null) return;
                      setState(() => _weekDayIndex = response.touchLocation.dx ~/ oneSeventh);
                    },
                  ),
                ),
              );
            },
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
        Expanded(
          child: ListView.builder(
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
