// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_team_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomTeamInfo _$CustomTeamInfoFromJson(Map<String, dynamic> json) =>
    CustomTeamInfo(
      generalNotes: json['generalNotes'] as String? ?? "",
      leftAuto: json['leftAuto'] as String? ?? "",
      leftAutoNotes: json['leftAutoNotes'] as String? ?? "",
      rightAuto: json['rightAuto'] as String? ?? "",
      rightAutoNotes: json['rightAutoNotes'] as String? ?? "",
      ascentLevel: json['ascentLevel'] as String? ?? "",
    );

Map<String, dynamic> _$CustomTeamInfoToJson(CustomTeamInfo instance) =>
    <String, dynamic>{
      'generalNotes': instance.generalNotes,
      'leftAuto': instance.leftAuto,
      'leftAutoNotes': instance.leftAutoNotes,
      'rightAuto': instance.rightAuto,
      'rightAutoNotes': instance.rightAutoNotes,
      'ascentLevel': instance.ascentLevel,
    };
