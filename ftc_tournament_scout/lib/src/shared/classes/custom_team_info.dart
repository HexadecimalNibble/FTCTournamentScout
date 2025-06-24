import 'package:json_annotation/json_annotation.dart';
import './classes.dart';

/// This allows the `CustomTeamInfo` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'custom_team_info.g.dart';

// @JsonSerializable(explicitToJson: true)
@JsonSerializable()
class CustomTeamInfo {
  CustomTeamInfo({
    this.generalNotes = "",
    this.leftAuto = "",
    this.leftAutoNotes = "",
  });

  String generalNotes;
  String leftAuto;
  String leftAutoNotes;

  /// A necessary factory constructor for creating a new CustomTeamInfo instance
  /// from a map. Pass the map to the generated `_$CustomTeamInfoFromJson()` constructor.
  /// The constructor is named after the source class, in this case, CustomTeamInfo.
  factory CustomTeamInfo.fromJson(Map<String, dynamic> json) =>
      _$CustomTeamInfoFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$CustomTeamInfoToJson`.
  Map<String, dynamic> toJson() => _$CustomTeamInfoToJson(this);
}
