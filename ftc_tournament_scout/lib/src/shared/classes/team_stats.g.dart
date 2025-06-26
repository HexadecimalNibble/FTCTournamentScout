// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamStats _$TeamStatsFromJson(Map<String, dynamic> json) => TeamStats(
  opr: json['opr'] as String? ?? "0.0",
  autoOpr: json['autoOpr'] as String? ?? "0.0",
  teleOpOpr: json['teleOpOpr'] as String? ?? "0.0",
  endGameOpr: json['endGameOpr'] as String? ?? "0.0",
);

Map<String, dynamic> _$TeamStatsToJson(TeamStats instance) => <String, dynamic>{
  'opr': instance.opr,
  'autoOpr': instance.autoOpr,
  'teleOpOpr': instance.teleOpOpr,
  'endGameOpr': instance.endGameOpr,
};
