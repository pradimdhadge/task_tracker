import 'package:flutter/material.dart';

class DropdownListWidget extends StatelessWidget {
  final String title;
  final List<String> items;
  final String? selectedItem;
  final void Function(String? value) onChanged;
  const DropdownListWidget({
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(10),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return DropdownButtonFormField(
          borderRadius: BorderRadius.circular(20),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  enabled: e != selectedItem,
                  child: _DropDownTile(
                    isSelected: selectedItem == e,
                    title: e,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          value: selectedItem,
          selectedItemBuilder: (context) {
            return items
                .map(
                  (e) => SizedBox(
                    width: constraints.maxWidth - 25,
                    child: Text(
                      e,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList();
          },
          decoration: InputDecoration(
            labelText: title,
            border: InputBorder.none,
          ),
        );
      }),
    );
  }
}

class _DropDownTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  const _DropDownTile(
      {required this.title, required this.isSelected, super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Container(
          color: isSelected ? theme.colorScheme.surface : null,
          height: 60,
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked_outlined
                    : Icons.radio_button_off_outlined,
                color: isSelected ? theme.colorScheme.primary : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        const Divider(height: 0),
      ],
    );
  }
}
