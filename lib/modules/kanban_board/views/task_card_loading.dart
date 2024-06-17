import 'package:flutter/material.dart';
import 'package:task_tracker/common_widgets/common_shimmer.dart';

class TaskCardLoading extends StatelessWidget {
  const TaskCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: theme.colorScheme.primaryContainer.withOpacity(0.5),
          )
        ],
      ),
      child: const CommonShimmer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerGrayBox(height: 22, width: 200),
            SizedBox(height: 10),
            ShimmerGrayBox(height: 15, width: 270),
            SizedBox(height: 5),
            ShimmerGrayBox(height: 15, width: 150),
            SizedBox(height: 10),
            Row(
              children: [
                ShimmerGrayBox(height: 15, width: 100),
                SizedBox(width: 15),
                ShimmerGrayBox(height: 15, width: 100),
              ],
            )
          ],
        ),
      ),
    );
  }
}
