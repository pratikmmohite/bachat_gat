// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_members.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupMember _$GroupMemberFromJson(Map<String, dynamic> json) => GroupMember(
      name: json['name'] as String,
      mobileNo: json['mobileNo'] as String,
      groupId: json['groupId'] as String,
      joiningDate: DateTime.parse(json['joiningDate'] as String),
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      aadharNo: json['aadharNo'] as String?,
      panNo: json['panNo'] as String?,
    )
      ..id = json['id'] as String
      ..sysCreated = DateTime.parse(json['sysCreated'] as String)
      ..sysUpdated = DateTime.parse(json['sysUpdated'] as String);

Map<String, dynamic> _$GroupMemberToJson(GroupMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sysCreated': instance.sysCreated.toIso8601String(),
      'sysUpdated': instance.sysUpdated.toIso8601String(),
      'name': instance.name,
      'mobileNo': instance.mobileNo,
      'groupId': instance.groupId,
      'joiningDate': instance.joiningDate.toIso8601String(),
      'aadharNo': instance.aadharNo,
      'panNo': instance.panNo,
      'balance': instance.balance,
    };
