import 'package:json_annotation/json_annotation.dart';
import './classes.dart';

/// This allows the `CustomTeamInfo` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'team_stats.g.dart';

// @JsonSerializable(explicitToJson: true)
@JsonSerializable()
class TeamStats {
  TeamStats({
    this.opr = "0.0",
    this.autoOpr = "0.0",
    this.teleOpOpr = "0.0",
    this.endGameOpr = "0.0",
  });

  String opr;
  String autoOpr;
  String teleOpOpr;
  String endGameOpr;

  /// A necessary factory constructor for creating a new TeamStats instance
  /// from a map. Pass the map to the generated `_$TeamStatsFromJson()` constructor.
  /// The constructor is named after the source class, in this case, TeamStats.
  factory TeamStats.fromJson(Map<String, dynamic> json) =>
      _$TeamStatsFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$TeamStatsToJson`.
  Map<String, dynamic> toJson() => _$TeamStatsToJson(this);
}
