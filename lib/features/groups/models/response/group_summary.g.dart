// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupSummary _$GroupSummaryFromJson(Map<String, dynamic> json) => GroupSummary()
  ..groupId = json['groupId'] as String
  ..trxPeriod = json['trxPeriod'] as String
  ..trxType = json['trxType'] as String
  ..totalCr = (json['totalCr'] as num).toDouble()
  ..totalDr = (json['totalDr'] as num).toDouble();

Map<String, dynamic> _$GroupSummaryToJson(GroupSummary instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'trxPeriod': instance.trxPeriod,
      'trxType': instance.trxType,
      'totalCr': instance.totalCr,
      'totalDr': instance.totalDr,
    };
