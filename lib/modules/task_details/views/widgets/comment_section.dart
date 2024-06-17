import 'package:flutter/material.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Comments",
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 20),
        const _CommentWidget(),
        const SizedBox(height: 20),
        const _CommentWidget(),
        const SizedBox(height: 50),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: "Enter comment here ...",
                ),
                maxLines: 2,
                minLines: 1,
              ),
            ),
            IconButton.filled(
              onPressed: () {},
              icon: const Icon(Icons.send),
            )
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _CommentWidget extends StatelessWidget {
  const _CommentWidget();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 70,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(0),
                ),
                color: theme.colorScheme.primaryContainer,
                border: Border.all(color: theme.colorScheme.primaryFixedDim)),
            child: Text(
              "Api integration has been done. It need to test once before deployee",
              style: theme.textTheme.bodyMedium
                  ?.apply(color: theme.colorScheme.onPrimaryContainer),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "14 jun 2024  05:25 AM",
            style: theme.textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}
