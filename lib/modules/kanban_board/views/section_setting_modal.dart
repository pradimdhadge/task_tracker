import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_tracker/common_widgets/input_field.dart';
import 'package:task_tracker/modules/kanban_board/bloc/kanban_board_bloc.dart';
import 'package:task_tracker/modules/kanban_board/bloc/kanban_board_event.dart';
import 'package:task_tracker/modules/kanban_board/models/section_model.dart';
import 'package:task_tracker/modules/task_details/views/delete_task_modal.dart';

import '../bloc/kanban_board_state.dart';

class SectionSettingModal {
  static show({
    required BuildContext context,
    required SectionModel section,
    required KanbanBoardBloc kanbanBoardBloc,
  }) {
    showDialog(
      context: context,
      builder: (context) => _SectionSettingModalView(
        section: section,
        kanbanBoardBloc: kanbanBoardBloc,
      ),
    );
  }
}

class _SectionSettingModalView extends StatelessWidget {
  final SectionModel section;
  final KanbanBoardBloc kanbanBoardBloc;
  const _SectionSettingModalView(
      {required this.section, required this.kanbanBoardBloc});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return BlocListener<KanbanBoardBloc, KanbanBoardState>(
      bloc: kanbanBoardBloc,
      listener: (context, state) {
        if (state is KanbanBoardSectionUpdatedState) {
          context.pop();
        }
      },
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            constraints: const BoxConstraints(maxWidth: 320),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Section Setting",
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 30),
                _SectionTextField(
                  sectionName: section.name ?? "",
                  onSave: (value) {
                    kanbanBoardBloc.add(KanbanBoardUpdateSectionEvent(
                        sectionId: section.id ?? "", sectionName: value));
                  },
                ),
                const SizedBox(height: 30),
                Divider(
                  height: 0,
                  color: theme.colorScheme.outlineVariant,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FilledButton.icon(
                      onPressed: () async {
                        bool res = await DeleteTaskModal.show(
                                context: context,
                                title: "Are you sure?",
                                body:
                                    "This will delete all ${section.name} task permanently. You can not undo this action.") ??
                            false;
                        if (res) {
                          kanbanBoardBloc.add(
                              KanbanBoardDeleteSectionEvent(section.id ?? ""));
                        }
                      },
                      label: const Text("Delete Section"),
                      icon: const Icon(Icons.delete),
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(theme.colorScheme.error),
                      ),
                    ),
                    const SizedBox(width: 15),
                    OutlinedButton(
                      onPressed: () => context.pop(),
                      child: const Text("Back"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTextField extends StatefulWidget {
  final void Function(String value) onSave;
  final String sectionName;

  const _SectionTextField({required this.onSave, required this.sectionName});

  @override
  State<_SectionTextField> createState() => _SectionTextFieldState();
}

class _SectionTextFieldState extends State<_SectionTextField> {
  TextEditingController? textEditingController;
  bool showSaveButton = false;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: widget.sectionName);
    textEditingController?.addListener(() {
      if (textEditingController!.text != widget.sectionName &&
          textEditingController!.text.isNotEmpty) {
        showSaveButton = true;
      } else {
        showSaveButton = false;
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: "Section Name",
          controller: textEditingController,
        ),
        const SizedBox(height: 10),
        if (showSaveButton)
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 30,
              child: FilledButton(
                onPressed: () => widget.onSave(textEditingController!.text),
                child: const Text("Save"),
              ),
            ),
          )
        else
          const SizedBox(height: 30),
      ],
    );
  }
}
