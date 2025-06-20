// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';
import 'package:collection/collection.dart';

import '../classes/classes.dart';
import '../../utils/database_service.dart';
import '../../utils/result.dart';

class TeamProvider {
  TeamProvider({required DatabaseService database}) : _database = database;

  final DatabaseService _database;

  Future<Result<List<Team>>> getTeams() async {
    if (!_database.isOpen()) {
      await _database.open();
    }
    return _database.getAll();
  }

  Future<Result<Team>> addTeam(Team team) async {
    if (!_database.isOpen()) {
      await _database.open();
    }
    return _database.insert(team);
  }

  Future<Result<Team>> updateTeam(Team team) async {
    if (!_database.isOpen()) {
      await _database.open();
    }
    return _database.update(team);
  }

  Future<Result<void>> deleteTeam(int teamNumber) async {
    if (!_database.isOpen()) {
      await _database.open();
    }
    return _database.delete(teamNumber);
  }
}
