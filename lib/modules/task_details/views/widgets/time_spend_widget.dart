import 'package:flutter/material.dart';

class TimeSpendWidget extends StatelessWidget {
  const TimeSpendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Time Spend",
          style: theme.textTheme.titleMedium?.apply(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "00h : 00m : 00s",
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _TimerActionButton(
              icon: Icons.play_circle_fill_rounded,
              action: "Start",
              iconColor: theme.colorScheme.onPrimaryContainer,
              bgColor: theme.colorScheme.primaryContainer,
              onTap: () {},
            ),
            const SizedBox(width: 20),
            // _TimerActionButton(
            //   icon: Icons.pause_circle_filled_rounded,
            //   action: "Pause",
            //   iconColor: const Color(0xFF988001),
            //   bgColor: const Color(0xFFFFF9D8),
            //   onTap: () {},
            // ),
            _TimerActionButton(
              icon: Icons.check_circle_rounded,
              action: "Mark As Completed",
              iconColor: const Color(0xFF0D5D00),
              bgColor: const Color(0xFFDDFFDE),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _TimerActionButton extends StatelessWidget {
  final String action;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final void Function() onTap;
  const _TimerActionButton({
    required this.action,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: 40,
      padding: const EdgeInsets.only(left: 10, right: 20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 25,
            color: iconColor,
          ),
          const SizedBox(width: 5),
          Text(
            action,
            style: theme.textTheme.labelLarge?.apply(
              color: iconColor,
            ),
          )
        ],
      ),
    );
  }
}
