import 'dart:developer';

import 'package:flutter/material.dart';
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
    on<KanbanBoardOnPageChangeEvent>(_kanbanBoardOnPageChangeEvent);
  }

  final KanbanBoardRepoInterface _repository =
      GetIt.instance<KanbanBoardRepoInterface>();
  bool isSectionLoading = true;
  bool isTaskLoading = true;
  ProjectModel? project;
  List<SectionModel> sections = [];
  List<TaskModel> allTasks = [];
  int activeSectionIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  List<SectionModel> get activeSections {
    if (sections.length == 1) return [];
    return sections.sublist(1, sections.length);
  }

  List<TaskModel> getFilteredTasks(int sectionIndex) {
    if (sectionIndex == 0) return allTasks;
    return allTasks
        .where((task) => task.sectionId == sections[sectionIndex].id)
        .toList();
  }

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
        sections.insert(0, SectionModel(name: "All"));
        emit(KanbanBoardSectionUpdatedState());
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

  void _kanbanBoardOnPageChangeEvent(
      KanbanBoardOnPageChangeEvent event, Emitter<KanbanBoardState> emit) {
    activeSectionIndex = event.pageIndex;
    emit(KanbanBoardSectionUpdatedState());
  }

  void _kanbanBoardCreateSectionEvent(KanbanBoardCreateSectionEvent event,
      Emitter<KanbanBoardState> emit) async {
    try {
      emit(KanbanBoardLoaderState(true));
      DataState<SectionModel> dataState = await _createSection(
          name: event.sectionName, projectId: project?.id ?? "");
      emit(KanbanBoardLoaderState(false));
      if (dataState is DataSuccess) {
        emit(KanbanBoardSectionUpdatedState());
        emit(KanbanBoardTaskUpdatedState());
      } else {
        emit(KanbanBoardErrorState(message: "Something went wrong"));
      }
    } catch (e, stack) {
      log(e.toString(), stackTrace: stack);
      emit(KanbanBoardErrorState(message: "Something went wrong"));
    }
  }

  void _kanbanBoardUpdateSectionEvent(KanbanBoardUpdateSectionEvent event,
      Emitter<KanbanBoardState> emit) async {
    try {
      emit(KanbanBoardLoaderState(true));
      DataState<SectionModel> dataState = await _repository.updateSection(
        name: event.sectionName,
        sectionId: event.sectionId,
      );
      emit(KanbanBoardLoaderState(false));

      if (dataState is DataSuccess) {
        int i = sections.indexWhere((section) => section.id == event.sectionId);
        if (i != -1) {
          sections.removeAt(i);
          sections.insert(i, dataState.data!);
          emit(KanbanBoardSectionUpdatedState());
        }
      } else {
        emit(KanbanBoardErrorState(message: "Something went wrong"));
      }
    } catch (e, stack) {
      log(e.toString(), stackTrace: stack);
      emit(KanbanBoardErrorState(message: "Something went wrong"));
    }
  }

  void _kanbanBoardDeleteSectionEvent(KanbanBoardDeleteSectionEvent event,
      Emitter<KanbanBoardState> emit) async {
    try {
      emit(KanbanBoardLoaderState(true));
      DataState<bool> dataState = await _repository.deleteSection(
        sectionId: event.sectionId,
      );
      emit(KanbanBoardLoaderState(false));
      if (dataState is DataSuccess) {
        sections.removeWhere((section) => section.id == event.sectionId);
        allTasks.removeWhere((element) => element.sectionId == event.sectionId);
        emit(KanbanBoardSectionUpdatedState());
        emit(KanbanBoardTaskUpdatedState());
        pageController.jumpToPage(0);
      } else {
        emit(KanbanBoardErrorState(message: "Something went wrong"));
      }
    } catch (e, stack) {
      log(e.toString(), stackTrace: stack);
      emit(KanbanBoardErrorState(message: "Something went wrong"));
    }
  }

  void _kanbanBoardCreateTaskEvent(
      KanbanBoardCreateTaskEvent event, Emitter<KanbanBoardState> emit) {
    allTasks.add(event.newTask);
    emit(KanbanBoardTaskUpdatedState());
    if (event.newTask.sectionId == sections[activeSectionIndex].id &&
        event.newTask.sectionId != null) {}
  }

  void _kanbanBoardUpdateTaskEvent(
      KanbanBoardUpdateTaskEvent event, Emitter<KanbanBoardState> emit) {
    if (event.updatedData == event.currentTask) return;
    if (event.updatedData == null) {
      allTasks.removeWhere((e) => e.id == event.currentTask.id);
    } else if (event.updatedData is TaskModel) {
      if (event.updatedData != event.currentTask) {
        allTasks.removeWhere((e) => e.id == event.currentTask.id);
        allTasks.add(event.updatedData);
      }
    }

    emit(KanbanBoardTaskUpdatedState());
  }

  void _kanbanBoardDeleteTaskEvent(
      KanbanBoardDeleteTaskEvent event, Emitter<KanbanBoardState> emit) {}

  void _kanbanBoardCloseTaskEvent(
      KanbanBoardCloseTaskEvent event, Emitter<KanbanBoardState> emit) {}
}
