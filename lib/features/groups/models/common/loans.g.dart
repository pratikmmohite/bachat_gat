// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loans.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoansList _$LoansListFromJson(Map<String, dynamic> json) => LoansList(
      id: json['id'] as String,
      memberId: json['memberId'] as String,
      groupId: json['groupId'] as String,
      loanAmount: (json['loanAmount'] as num).toDouble(),
      interestPercentage: (json['interestPercentage'] as num).toDouble(),
      paidLoanAmount: (json['paidLoanAmount'] as num).toDouble(),
      paidInterestAmount: (json['paidInterestAmount'] as num).toDouble(),
      status: json['status'] as String,
      addedBy: json['addedBy'] as String,
      note: json['note'] as String? ?? "",
      loanDate: json['loanDate'] == null
          ? null
          : DateTime.parse(json['loanDate'] as String),
      sysCreated: json['sysCreated'] == null
          ? null
          : DateTime.parse(json['sysCreated'] as String),
      sysUpdated: json['sysUpdated'] == null
          ? null
          : DateTime.parse(json['sysUpdated'] as String),
    );

Map<String, dynamic> _$LoansListToJson(LoansList instance) => <String, dynamic>{
      'id': instance.id,
      'memberId': instance.memberId,
      'groupId': instance.groupId,
      'loanAmount': instance.loanAmount,
      'interestPercentage': instance.interestPercentage,
      'paidLoanAmount': instance.paidLoanAmount,
      'paidInterestAmount': instance.paidInterestAmount,
      'note': instance.note,
      'status': instance.status,
      'addedBy': instance.addedBy,
      'loanDate': instance.loanDate.toIso8601String(),
      'sysCreated': instance.sysCreated.toIso8601String(),
      'sysUpdated': instance.sysUpdated.toIso8601String(),
    };
