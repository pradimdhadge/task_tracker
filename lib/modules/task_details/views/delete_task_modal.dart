import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeleteTaskModal {
  DeleteTaskModal._();

  static Future<bool?> show(
      {required BuildContext context,
      required String title,
      required String body}) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _DeleteTaskModalView(title: title, body: body),
    );
  }
}

class _DeleteTaskModalView extends StatelessWidget {
  final String title;
  final String body;
  const _DeleteTaskModalView({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AlertDialog(
      icon: Icon(
        Icons.warning_rounded,
        size: 50,
        color: theme.colorScheme.error,
      ),
      title: Text(title),
      content: Text(body),
      actions: [
        OutlinedButton(
          onPressed: () => context.pop(false),
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () => context.pop(true),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(theme.colorScheme.error),
          ),
          child: const Text("Delete"),
        ),
      ],
    );
  }
}
