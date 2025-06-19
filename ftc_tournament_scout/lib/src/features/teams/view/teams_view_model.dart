import 'package:flutter/foundation.dart';

import '../../../shared/classes/team.dart';
import '../../../shared/providers/team.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class TeamsViewModel extends ChangeNotifier {
  TeamsViewModel({required TeamProvider teamProvider})
    : _teamProvider = teamProvider {
    load = Command0<void>(_load)..execute();
    add = Command1<void, Team>(_add);
    delete = Command1<void, int>(_delete);
  }

  final TeamProvider _teamProvider;

  /// Load Todo items from repository.
  late Command0<void> load;

  /// Add a new Todo item.
  late Command1<void, Team> add;

  /// Delete a Todo item by its id.
  late Command1<void, int> delete;

  // #docregion TodoListViewModel
  List<Team> _teams = [];

  List<Team> get teams => _teams;

  Future<Result<void>> _load() async {
    try {
      final result = await _teamProvider.getTeams();
      switch (result) {
        case Ok<List<Team>>():
          _teams = result.value;
          return Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }
  // #enddocregion TodoListViewModel

  // #docregion Add
  Future<Result<void>> _add(Team team) async {
    try {
      final result = await _teamProvider.addTeam(team);
      switch (result) {
        case Ok<Team>():
          _teams.add(result.value);
          return Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }
  // #enddocregion Add

  // #docregion Delete
  Future<Result<void>> _delete(int teamNumber) async {
    try {
      final result = await _teamProvider.deleteTeam(teamNumber);
      switch (result) {
        case Ok<void>():
          _teams.removeWhere((team) => team.number == teamNumber);
          return Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }

  // #enddocregion Delete
}