import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/modules/themes/bloc/theme_bloc.dart';
import 'package:task_tracker/modules/themes/bloc/theme_event.dart';
import 'package:task_tracker/modules/themes/constants/color_constants.dart';

class ThemeModalBottomSheet {
  static show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) => const _ThemeModalBottomSheetView(),
    );
  }
}

class _ThemeModalBottomSheetView extends StatelessWidget {
  const _ThemeModalBottomSheetView();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ThemeBloc themeBloc = context.read<ThemeBloc>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Theme Setting",
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 30),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
            itemCount: ColorConstants.colors.length,
            itemBuilder: (context, index) {
              return ThemeColorBox(
                color: ColorConstants.colors[index],
                onTap: () => themeBloc.add(
                  ChangeThemeEvent(color: ColorConstants.colors[index]),
                ),
              );
            },
          ),
          const Divider(height: 80),
          Text(
            "Mode",
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              ThemeColorBox(
                color: Colors.black,
                onTap: () => themeBloc.add(
                  ChangeThemeEvent(brightness: Brightness.dark),
                ),
                child: const Icon(
                  Icons.dark_mode,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 20),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: () => themeBloc.add(
                    ChangeThemeEvent(brightness: Brightness.light),
                  ),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: const Icon(
                      Icons.light_mode,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ThemeColorBox extends StatelessWidget {
  final Color color;
  final Function() onTap;
  final Widget? child;
  const ThemeColorBox(
      {required this.color, required this.onTap, this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 50,
          width: 50,
          child: child,
        ),
      ),
    );
  }
}
