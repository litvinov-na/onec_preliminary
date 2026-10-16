import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key, required this.actionText});

  final String actionText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('$actionText?'),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
        ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: Text(actionText)),
      ],
    );
  }
}
