// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupMemberDetails _$GroupMemberDetailsFromJson(Map<String, dynamic> json) =>
    GroupMemberDetails()
      ..name = json['name'] as String
      ..groupId = json['groupId'] as String
      ..memberId = json['memberId'] as String
      ..balance = (json['balance'] as num).toDouble()
      ..paidShareAmount = (json['paidShareAmount'] as num).toDouble()
      ..paidLoanAmount = (json['paidLoanAmount'] as num).toDouble()
      ..paidLateFee = (json['paidLateFee'] as num).toDouble()
      ..pendingLoanAmount = (json['pendingLoanAmount'] as num).toDouble()
      ..paidLoanInterestAmount =
          (json['paidLoanInterestAmount'] as num).toDouble()
      ..lendLoan = (json['lendLoan'] as num).toDouble()
      ..paidOtherAmount = (json['paidOtherAmount'] as num).toDouble();

Map<String, dynamic> _$GroupMemberDetailsToJson(GroupMemberDetails instance) =>
    <String, dynamic>{
      'name': instance.name,
      'groupId': instance.groupId,
      'memberId': instance.memberId,
      'balance': instance.balance,
      'paidShareAmount': instance.paidShareAmount,
      'paidLoanAmount': instance.paidLoanAmount,
      'paidLateFee': instance.paidLateFee,
      'pendingLoanAmount': instance.pendingLoanAmount,
      'paidLoanInterestAmount': instance.paidLoanInterestAmount,
      'lendLoan': instance.lendLoan,
      'paidOtherAmount': instance.paidOtherAmount,
    };
