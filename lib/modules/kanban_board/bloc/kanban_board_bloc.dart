import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:task_tracker/core/resources/data_state.dart';
import 'package:task_tracker/modules/kanban_board/bloc/kanban_board_event.dart';
import 'package:task_tracker/modules/kanban_board/bloc/kanban_board_state.dart';
import 'package:task_tracker/modules/kanban_board/models/project_model.dart';
import 'package:task_tracker/modules/kanban_board/models/section_model.dart';
import 'package:task_tracker/modules/kanban_board/models/task_model.dart';
import 'package:task_tracker/modules/kanban_board/repository/kanban_board_repo.dart';

class KanbanBoardBloc extends Bloc<KanbanBoardEvent, KanbanBoardState> {
  KanbanBoardBloc(super.initialState) {
    on<KanbanBoardInitialEvent>(_kanbanBoardInitialEvent);
    on<KanbanBoardCreateSectionEvent>(_kanbanBoardCreateSectionEvent);
    on<KanbanBoardUpdateSectionEvent>(_kanbanBoardUpdateSectionEvent);
    on<KanbanBoardDeleteSectionEvent>(_kanbanBoardDeleteSectionEvent);
    on<KanbanBoardCreateTaskEvent>(_kanbanBoardCreateTaskEvent);
    on<KanbanBoardUpdateTaskEvent>(_kanbanBoardUpdateTaskEvent);
    on<KanbanBoardDeleteTaskEvent>(_kanbanBoardDeleteTaskEvent);
    on<KanbanBoardCloseTaskEvent>(_kanbanBoardCloseTaskEvent);
  }

  final KanbanBoardRepoInterface _repository =
      GetIt.instance<KanbanBoardRepoInterface>();
  bool isSectionLoading = true;
  bool isTaskLoading = true;
  ProjectModel? project;
  List<SectionModel> sections = [];
  List<TaskModel> allTasks = [];

  void _kanbanBoardInitialEvent(
      KanbanBoardInitialEvent event, Emitter<KanbanBoardState> emit) async {
    try {
      isSectionLoading = true;
      isTaskLoading = true;
      emit(KanbanBoardLoadingState());
      DataState<ProjectModel> response = await _repository.getProject();
      if (response is DataSuccess) {
        project = response.data!;
        await _getSectionsFromRemote();
        isSectionLoading = false;
        emit(KanbanBoardSectionUpdated());
        await _getAllTasks();
        isTaskLoading = false;
        emit(KanbanBoardTaskUpdatedState());
      } else {
        isTaskLoading = false;
        isSectionLoading = false;
        emit(KanbanBoardErrorState(
            message: "Something went wrong while loading the tasks"));
      }
    } catch (e, stack) {
      isTaskLoading = false;
      isSectionLoading = false;
      emit(KanbanBoardErrorState(
          message: "Something went wrong while loading the tasks"));
      log(e.toString(), stackTrace: stack);
    }
  }

  Future<void> _getSectionsFromRemote() async {
    try {
      DataState<List<SectionModel>> response =
          await _repository.getSections(projectId: project?.id ?? "");
      if (response is DataSuccess) {
        sections = response.data ?? [];
        if (sections.isEmpty) {
          DataState<SectionModel> sectionState = await _createSection(
            name: "TO DO",
            projectId: project!.id ?? "",
            order: 1,
          );

          throwIf(
              sectionState is DataFailed,
              sectionState.error?.message ??
                  "Something went wrong while creating section");
        }
      } else {
        throw "Something went wrong while getting the sections";
      }
    } catch (e, stack) {
      log(e.toString(), stackTrace: stack);
      rethrow;
    }
  }

  Future<DataState<List<TaskModel>>> _getAllTasks() async {
    try {
      DataState<List<TaskModel>> dataState = await _repository.getTasks();
      if (dataState is DataSuccess) {
        allTasks.clear();
        allTasks = dataState.data ?? [];
      }

      return dataState;
    } catch (e, stack) {
      log(e.toString(), stackTrace: stack);
      rethrow;
    }
  }

  Future<DataState<SectionModel>> _createSection(
      {required String name, required String projectId, int? order}) async {
    try {
      DataState<SectionModel> dataState = await _repository.createSection(
        name: name,
        projectId: projectId,
        order: order,
      );
      if (dataState is DataSuccess) {
        sections.add(dataState.data!);
      }
      return dataState;
    } catch (e, stack) {
      log(e.toString(), stackTrace: stack);
      rethrow;
    }
  }

  SectionModel? sectionFromId(String id) {
    int i = sections.indexWhere((e) => e.id == id);
    if (i != -1) {
      return sections[i];
    }
    return null;
  }

  void _kanbanBoardCreateSectionEvent(
      KanbanBoardCreateSectionEvent event, Emitter<KanbanBoardState> emit) {}

  void _kanbanBoardUpdateSectionEvent(
      KanbanBoardUpdateSectionEvent event, Emitter<KanbanBoardState> emit) {}

  void _kanbanBoardDeleteSectionEvent(
      KanbanBoardDeleteSectionEvent event, Emitter<KanbanBoardState> emit) {}

  void _kanbanBoardCreateTaskEvent(
      KanbanBoardCreateTaskEvent event, Emitter<KanbanBoardState> emit) {}

  void _kanbanBoardUpdateTaskEvent(
      KanbanBoardUpdateTaskEvent event, Emitter<KanbanBoardState> emit) {}

  void _kanbanBoardDeleteTaskEvent(
      KanbanBoardDeleteTaskEvent event, Emitter<KanbanBoardState> emit) {}

  void _kanbanBoardCloseTaskEvent(
      KanbanBoardCloseTaskEvent event, Emitter<KanbanBoardState> emit) {}
}
