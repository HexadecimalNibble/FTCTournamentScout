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
    update = Command1<void, Team>(_update);
    delete = Command1<void, int>(_delete);
  }

  final TeamProvider _teamProvider;

  /// Load Teams from database.
  late Command0<void> load;

  /// Add a new Team.
  late Command1<void, Team> add;

  /// Updates a Team.
  late Command1<void, Team> update;

  /// Delete a Team by its team number.
  late Command1<void, int> delete;

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

  Future<Result<void>> _update(Team team) async {
    try {
      final result = await _teamProvider.updateTeam(team);
      switch (result) {
        case Ok<Team>():
          // Update team in _teams list
          _teams[_teams.indexWhere((team) => team.number == result.value.number)] = result.value;
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