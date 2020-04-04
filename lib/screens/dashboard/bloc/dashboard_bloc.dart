import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/blocs/settings/settings_bloc.dart';
import 'package:timecop/models/project.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ProjectsBloc projectsBloc;
  final SettingsBloc settingsBloc;

  DashboardBloc(this.projectsBloc, this.settingsBloc);

  @override
  DashboardState get initialState {
    Project newProject = projectsBloc.getProjectByID(settingsBloc.state.defaultProjectID);
    List<int> selectedProjects = <int>[null].followedBy(projectsBloc.state.projects.map((p) => p.id)).toList();
    return DashboardState("", newProject, false, DateTime.now().subtract(Duration(days: 30)), null, selectedProjects, null);
  }

  @override
  Stream<DashboardState> mapEventToState(
    DashboardEvent event,
  ) async* {
    if(event is DescriptionChangedEvent) {
      yield DashboardState(event.description, state.newProject, false, state.filterStart, state.filterEnd, state.filterProjects, state.searchString);
    }
    else if(event is ProjectChangedEvent) {
      yield DashboardState(state.newDescription, event.project, false, state.filterStart, state.filterEnd, state.filterProjects, state.searchString);
    }
    else if(event is TimerWasStartedEvent) {
      Project newProject = projectsBloc.getProjectByID(settingsBloc.state.defaultProjectID);
      yield DashboardState("", newProject, true, state.filterStart, state.filterEnd, state.filterProjects, state.searchString);
    }
    else if(event is ResetEvent) {
      Project newProject = projectsBloc.getProjectByID(settingsBloc.state.defaultProjectID);
      yield DashboardState("", newProject, false, state.filterStart, state.filterEnd, state.filterProjects, state.searchString);
    }
    else if(event is FilterStartChangedEvent) {
      yield DashboardState(state.newDescription, state.newProject, false, event.filterStart, state.filterEnd, state.filterProjects, state.searchString);
    }
    else if(event is FilterEndChangedEvent) {
      yield DashboardState(state.newDescription, state.newProject, false, state.filterStart, event.filterEnd, state.filterProjects, state.searchString);
    }
    else if(event is FilterProjectsChangedEvent) {
      yield DashboardState(state.newDescription, state.newProject, false, state.filterStart, state.filterEnd, event.projects, state.searchString);
    }
    else if(event is SearchChangedEvent) {
      DashboardState s = DashboardState(state.newDescription, state.newProject, false, state.filterStart, state.filterEnd, state.filterProjects, event.search);
      print("search state:");
      print(s);
      yield s;
    }
  }
}
