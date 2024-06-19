import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_tracker/modules/kanban_board/bloc/kanban_board_event.dart';

import '../../../common_widgets/input_field.dart';
import '../bloc/kanban_board_bloc.dart';
import '../bloc/kanban_board_state.dart';

class CreateSectionModal {
  static show(
      {required BuildContext context,
      required KanbanBoardBloc kanbanBoardBloc}) {
    showDialog(
      context: context,
      builder: (context) => _CreateSectionModalView(
        kanbanBoardBloc: kanbanBoardBloc,
      ),
    );
  }
}

class _CreateSectionModalView extends StatefulWidget {
  final KanbanBoardBloc kanbanBoardBloc;

  const _CreateSectionModalView({required this.kanbanBoardBloc});

  @override
  State<_CreateSectionModalView> createState() =>
      _CreateSectionModalViewState();
}

class _CreateSectionModalViewState extends State<_CreateSectionModalView> {
  final TextEditingController textEditingController = TextEditingController();
  bool showAddButton = false;

  @override
  void initState() {
    textEditingController.addListener(() {
      setState(() {
        if (textEditingController.text.isEmpty) {
          showAddButton = false;
        } else {
          showAddButton = true;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: BlocListener<KanbanBoardBloc, KanbanBoardState>(
        bloc: widget.kanbanBoardBloc,
        listener: (context, state) {
          if (state is KanbanBoardSectionUpdatedState) {
            context.pop();
          }
        },
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
                  "Add Section",
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  label: "Section Name",
                  controller: textEditingController,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => context.pop(),
                      child: const Text("Back"),
                    ),
                    const SizedBox(width: 15),
                    FilledButton(
                      onPressed: showAddButton
                          ? () => widget.kanbanBoardBloc
                                  .add(KanbanBoardCreateSectionEvent(
                                sectionName: textEditingController.text,
                              ))
                          : null,
                      child: const Text("Add"),
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
