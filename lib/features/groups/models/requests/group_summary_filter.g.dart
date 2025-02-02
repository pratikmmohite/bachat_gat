// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_summary_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupSummaryFilter _$GroupSummaryFilterFromJson(Map<String, dynamic> json) =>
    GroupSummaryFilter(
      json['groupId'] as String? ?? "",
    )
      ..edt = DateTime.parse(json['edt'] as String)
      ..sdt = DateTime.parse(json['sdt'] as String)
      ..dateMode = json['dateMode'] as String
      ..type = json['type'] as String;

Map<String, dynamic> _$GroupSummaryFilterToJson(GroupSummaryFilter instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'edt': instance.edt.toIso8601String(),
      'sdt': instance.sdt.toIso8601String(),
      'dateMode': instance.dateMode,
      'type': instance.type,
    };
