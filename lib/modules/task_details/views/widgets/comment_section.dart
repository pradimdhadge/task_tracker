import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/common_widgets/common_shimmer.dart';
import 'package:task_tracker/modules/task_details/bloc/task_details_bloc.dart';
import 'package:task_tracker/modules/task_details/bloc/task_details_event.dart';
import 'package:task_tracker/modules/task_details/bloc/task_details_state.dart';
import 'package:task_tracker/modules/task_details/models/comment_model.dart';
import 'package:task_tracker/utils/date_formatter.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TaskDetailsBloc taskDetailsBloc = context.read<TaskDetailsBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Comments",
          style: theme.textTheme.titleLarge,
        ),
        BlocBuilder<TaskDetailsBloc, TaskDetailsState>(
          bloc: taskDetailsBloc,
          buildWhen: (previous, current) {
            if (current is TaskDetailsCommentUpdatedState) {
              return true;
            } else {
              return false;
            }
          },
          builder: (context, state) {
            if (taskDetailsBloc.isCommentLoading) {
              return const Column(
                children: [
                  SizedBox(height: 20),
                  _LoadingCommentWidget(),
                  _LoadingCommentWidget()
                ],
              );
            }
            return Column(
              children: [
                const SizedBox(height: 20),
                ...taskDetailsBloc.comments
                    .map((e) => _CommentWidget(commentModel: e)),
                const SizedBox(height: 100),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CommentWidget extends StatelessWidget {
  final CommentModel commentModel;
  const _CommentWidget({required this.commentModel});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(bottom: 20),
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
              commentModel.content ?? "",
              style: theme.textTheme.bodyMedium
                  ?.apply(color: theme.colorScheme.onPrimaryContainer),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            DateFormatterUtil.dateTimeToFormatedDateTime(commentModel.postedAt),
            style: theme.textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}

class _LoadingCommentWidget extends StatelessWidget {
  const _LoadingCommentWidget();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(bottom: 20),
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
            child: const CommonShimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerGrayBox(height: 20, width: 250),
                  SizedBox(height: 5),
                  ShimmerGrayBox(height: 20, width: 150),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          const CommonShimmer(child: ShimmerGrayBox(height: 20, width: 150)),
        ],
      ),
    );
  }
}

class CommentTextField extends StatelessWidget {
  CommentTextField({super.key});
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TaskDetailsBloc taskDetailsBloc = context.read<TaskDetailsBloc>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      color: theme.colorScheme.surfaceContainerLowest,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: textEditingController,
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
              const SizedBox(width: 5),
              BlocBuilder<TaskDetailsBloc, TaskDetailsState>(
                bloc: taskDetailsBloc,
                buildWhen: (previous, current) {
                  if (current is TaskDetailsCommentUpdatedState ||
                      current is TaskDetailsCommentAddingState) {
                    return true;
                  } else {
                    return false;
                  }
                },
                builder: (context, state) {
                  if (state is TaskDetailsCommentAddingState) {
                    return Padding(
                      padding: const EdgeInsets.all(4),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: theme.colorScheme.primary,
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    );
                  }
                  return IconButton.filled(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      taskDetailsBloc.add(TaskDetailsSendCommentEvent(
                          textEditingController.text));
                      textEditingController.value = const TextEditingValue();
                    },
                    icon: const Icon(Icons.send, size: 20),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
