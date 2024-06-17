import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final List<TextInputFormatter>? inputFormater;
  final TextEditingController? controller;
  final String label;
  final void Function(String value)? onSubmited;
  final void Function(String value)? onChanged;
  final bool obSecureText;
  final bool enabled;
  final String errorText;
  final TextInputType? keyBoardType;
  final int? minLines;
  final int? maxLines;

  const CustomTextField({
    required this.label,
    this.inputFormater,
    this.controller,
    this.obSecureText = false,
    this.onSubmited,
    this.onChanged,
    this.enabled = true,
    this.errorText = "",
    this.keyBoardType,
    this.minLines,
    this.maxLines = 1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:
                enabled ? theme.colorScheme.surface : theme.colorScheme.outline,
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 5, bottom: 0),
              labelText: label,
            ),
            onChanged: onChanged,
            cursorColor: theme.colorScheme.secondary,
            inputFormatters: inputFormater,
            obscureText: obSecureText,
            onSubmitted: onSubmited,
            enabled: enabled,
            keyboardType: keyBoardType,
            minLines: minLines,
            maxLines: maxLines,
          ),
        ),
        errorText != "" ? const SizedBox(height: 5) : Container(),
        errorText != ""
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error, size: 11),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      errorText,
                      style: theme.textTheme.bodySmall?.apply(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
