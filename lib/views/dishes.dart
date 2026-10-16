import 'package:calorie_tracker/features/dish/repository.dart';
import 'package:calorie_tracker/features/dish/ui/editor.dart';
import 'package:calorie_tracker/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DishesPage extends StatelessWidget {
  const DishesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dishRepo = context.watch<DishRepository>();
    if (dishRepo.box.isEmpty()) {
      return Column(
        spacing: 8.0,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text('No dishes yet')),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              onPressed: () async {
                final newDish = await DishEditor.dialog(context: context, dish: null);
                if (newDish != null) dishRepo.put(newDish);
              },
              child: Text('Add new dish'),
            ),
          ),
        ],
      );
    }

    final dishes = dishRepo.box.getAll();
    return ListView.builder(
      itemCount: dishes.length + 1,
      itemBuilder: (context, index) {
        if (index == dishes.length) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              onPressed: () async {
                final newDish = await DishEditor.dialog(context: context, dish: null);
                if (newDish != null) dishRepo.put(newDish);
              },
              child: Text('Add new dish'),
            ),
          );
        }

        final dish = dishes[index];
        return ListTile(
          isThreeLine: true,
          onLongPress: () async {
            final shouldDelete = await showDialog(
              context: context,
              builder: (context) => ConfirmationDialog(actionText: 'Delete'),
            );
            if (shouldDelete == true) dishRepo.remove(dish);
          },
          title: Text(dish.name),
          subtitle: Text(dish.macrosText),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final editedDish = await DishEditor.dialog(context: context, dish: dish);
              if (editedDish == null) return;
              dishRepo.put(editedDish);
            },
          ),
        );
      },
    );
  }
}
