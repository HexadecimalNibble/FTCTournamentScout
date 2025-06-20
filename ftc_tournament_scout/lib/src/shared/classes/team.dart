import './classes.dart';

class Team {
  Team({
    required this.number,
    required this.name,
    required this.opr,
    CustomTeamInfo? customTeamInfo,
  }) : customTeamInfo = customTeamInfo ?? CustomTeamInfo(); // If customTeamInfo isn't specified (is null), create empty CustomTeamInfo object.

  final int number;
  final String name;
  final double opr;
  final CustomTeamInfo customTeamInfo;
}
