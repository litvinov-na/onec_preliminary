import 'package:calorie_tracker/features/dish/model.dart';
import 'package:flutter/material.dart';

class DishEditor extends StatefulWidget {
  const DishEditor({super.key, required this.dish, required this.onCancel, required this.onSave});

  final Dish? dish;
  final void Function() onCancel;
  final void Function(Dish) onSave;

  static Future<Dish?> dialog({required BuildContext context, required Dish? dish}) {
    return showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: DishEditor(dish: dish, onCancel: Navigator.of(context).pop, onSave: Navigator.of(context).pop),
      ),
    );
  }

  @override
  State<DishEditor> createState() => _DishEditorState();
}

class _DishEditorState extends State<DishEditor> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController = .new(text: widget.dish?.name);
  late final TextEditingController _gramsController = .new(text: widget.dish?.grams.toString());
  late final TextEditingController _caloriesController = .new(text: widget.dish?.kCalories.toString());
  late final TextEditingController _proteinController = .new(text: widget.dish?.protein.toString());
  late final TextEditingController _carbsController = .new(text: widget.dish?.carbs.toString());
  late final TextEditingController _fatsController = .new(text: widget.dish?.fats.toString());

  @override
  void dispose() {
    _nameController.dispose();
    _gramsController.dispose();
    _caloriesController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    _proteinController.dispose();
    super.dispose();
  }

  Widget _intField({required TextEditingController controller, required String label}) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (int.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: TextInputType.number,
    );
  }

  @override
  Widget build(BuildContext context) {
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
            _intField(controller: _gramsController, label: 'Grams'),
            _intField(controller: _caloriesController, label: 'KCalories (per 100g)'),
            _intField(controller: _proteinController, label: 'Protein (per 100g)'),
            _intField(controller: _carbsController, label: 'Carbs (per 100g)'),
            _intField(controller: _fatsController, label: 'Fats (per 100g)'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(onPressed: widget.onCancel, child: const Text('Cancel')),
                FilledButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    final dish = Dish(
                      id: widget.dish?.id ?? 0,
                      name: _nameController.text,
                      grams: int.parse(_gramsController.text),
                      kCalories: int.parse(_caloriesController.text),
                      carbs: int.parse(_carbsController.text),
                      fats: int.parse(_fatsController.text),
                      protein: int.parse(_proteinController.text),
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
