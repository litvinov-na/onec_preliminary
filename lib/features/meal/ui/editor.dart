import 'package:calorie_tracker/features/dish/model.dart';
import 'package:calorie_tracker/features/dish/repository.dart';
import 'package:calorie_tracker/features/meal/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';
import 'package:provider/provider.dart';

class MealEditor extends StatefulWidget {
  const MealEditor({super.key, required this.meal, required this.onCancel, required this.onSave});

  final Meal? meal;
  final void Function() onCancel;
  final void Function(Meal) onSave;

  static Future<Meal?> dialog({required BuildContext context, required Meal? meal}) {
    return showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: MealEditor(meal: meal, onCancel: Navigator.of(context).pop, onSave: Navigator.of(context).pop),
      ),
    );
  }

  @override
  State<MealEditor> createState() => _MealEditorState();
}

class _MealEditorState extends State<MealEditor> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController = .new(text: widget.meal?.name);
  late final List<Dish> _pickedDishes = widget.meal?.dishes.toList() ?? [];
  late DateTime _date = widget.meal?.date ?? DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dishRepo = context.read<DishRepository>();
    final dishes = dishRepo.box.getAll();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 8.0,
          children: [
            TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
            ),
            ListTile(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => _date = picked);
                }
              },
              title: Text('Date: ${DateFormat.yMMMd().format(_date)}'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dishes.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(dishes[index].name),
                    value: _pickedDishes.contains(dishes[index]),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          _pickedDishes.add(dishes[index]);
                        } else {
                          _pickedDishes.remove(dishes[index]);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(onPressed: widget.onCancel, child: const Text('Cancel')),
                FilledButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    final dish = Meal(
                      id: widget.meal?.id ?? 0,
                      name: _nameController.text,
                      date: _date,
                      dishes: ToMany<Dish>(items: _pickedDishes),
                    );
                    widget.onSave(dish);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
