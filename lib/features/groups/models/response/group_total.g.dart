// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_total.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupTotal _$GroupTotalFromJson(Map<String, dynamic> json) => GroupTotal()
  ..balance = (json['balance'] as num).toDouble()
  ..totalSaving = (json['totalSaving'] as num).toDouble()
  ..memberCount = (json['memberCount'] as num).toDouble()
  ..perMemberShare = (json['perMemberShare'] as num).toDouble();

Map<String, dynamic> _$GroupTotalToJson(GroupTotal instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'totalSaving': instance.totalSaving,
      'memberCount': instance.memberCount,
      'perMemberShare': instance.perMemberShare,
    };
