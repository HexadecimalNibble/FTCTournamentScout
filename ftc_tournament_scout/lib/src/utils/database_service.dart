import 'package:ftc_tournament_scout/src/shared/classes/classes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../shared/classes/team.dart';
import 'result.dart';

class DatabaseService {
  DatabaseService({required this.databaseFactory});

  final DatabaseFactory databaseFactory;

  // #docregion Table
  static const _kTableTeams = 'teams';
  static const _kColumnNumber = 'number';
  static const _kColumnName = 'name';
  static const _kColumnOPR = 'opr';
  static const _kColumnCustomTeamInfo = 'customTeamInfo';
  // #enddocregion Table

  Database? _database;

  bool isOpen() => _database != null;

  // #docregion Open
  Future<void> open() async {
    final path = join(await databaseFactory.getDatabasesPath(), 'app_database.db');
    print('Database path: $path');

    _database = await databaseFactory.openDatabase(
      join(await databaseFactory.getDatabasesPath(), 'app_database.db'),
      options: OpenDatabaseOptions(
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE $_kTableTeams($_kColumnNumber INTEGER PRIMARY KEY, $_kColumnName TEXT, $_kColumnOPR DOUBLE, $_kColumnCustomTeamInfo TEXT)',
          );
        },
        version: 1,
      ),
    );
  }
  // #enddocregion Open

  Future<Result<Team>> insert(Team team) async {
    try {
      await _database!.insert(_kTableTeams, {_kColumnNumber: team.number, _kColumnName: team.name, _kColumnOPR: team.opr, _kColumnCustomTeamInfo: team.customTeamInfo.toJson().toString()});
      return Result.ok(team);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  /// Function to update team already in database. Team is selected based on the team number in the supplied team.
  /// The properties of the matching team in the database are updated based on the supplied team
  Future<Result<Team>> update(Team team) async {
    try {
      await _database!.update(
        _kTableTeams,
        {_kColumnNumber: team.number, _kColumnName: team.name, _kColumnOPR: team.opr, _kColumnCustomTeamInfo: team.customTeamInfo.toJson()},
        where: '$_kColumnNumber = ?',
        whereArgs: [team.number],
      );
      return Result.ok(team);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // #docregion GetAll
  Future<Result<List<Team>>> getAll() async {
    try {
      final entries = await _database!.query(
        _kTableTeams,
        columns: [_kColumnNumber, _kColumnName, _kColumnOPR],
      );
      final list = entries
          .map(
            (element) => Team(
              number: element[_kColumnNumber] as int,
              name: element[_kColumnName] as String,
              opr: element[_kColumnOPR] as double,
              customTeamInfo: element[_kColumnCustomTeamInfo] == null ? CustomTeamInfo() : CustomTeamInfo.fromJson(element[_kColumnCustomTeamInfo] as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.ok(list);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
  // #enddocregion GetAll

  // #docregion Delete
  Future<Result<void>> delete(int teamNumber) async {
    try {
      final rowsDeleted = await _database!.delete(
        _kTableTeams,
        where: '$_kColumnNumber = ?',
        whereArgs: [teamNumber],
      );
      if (rowsDeleted == 0) {
        return Result.error(Exception('No team found with teamNumber: $teamNumber'));
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
  // #enddocregion Delete

  Future close() async {
    await _database?.close();
    _database = null;
  }
}