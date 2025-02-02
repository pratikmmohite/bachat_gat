// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_loan_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberLoanFilter _$MemberLoanFilterFromJson(Map<String, dynamic> json) =>
    MemberLoanFilter(
      json['groupId'] as String,
      json['memberId'] as String,
    )..status = json['status'] as String;

Map<String, dynamic> _$MemberLoanFilterToJson(MemberLoanFilter instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'memberId': instance.memberId,
      'status': instance.status,
    };
