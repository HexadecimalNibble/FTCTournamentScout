import 'package:ftc_tournament_scout/src/shared/classes/team_stats.dart';

import './classes.dart';

class Team {
  Team({
    required this.number,
    required this.name,
    required this.opr,
    CustomTeamInfo? customTeamInfo,
    TeamStats? teamStats,
    // If parameter isn't specified (is null), create empty object for parameter
  }) : customTeamInfo = customTeamInfo ?? CustomTeamInfo(),
       teamStats = teamStats ?? TeamStats();
  final int number;
  final String name;
  final double opr;
  final CustomTeamInfo customTeamInfo;
  final TeamStats teamStats;
}
