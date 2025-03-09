// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Loan _$LoanFromJson(Map<String, dynamic> json) => Loan(
      memberId: json['memberId'] as String,
      groupId: json['groupId'] as String,
      loanAmount: (json['loanAmount'] as num).toDouble(),
      interestPercentage: (json['interestPercentage'] as num).toDouble(),
      paidLoanAmount: (json['paidLoanAmount'] as num).toDouble(),
      paidInterestAmount: (json['paidInterestAmount'] as num).toDouble(),
      note: json['note'] as String,
      status: json['status'] as String,
      loanDate: DateTime.parse(json['loanDate'] as String),
      addedBy: json['addedBy'] as String,
    )
      ..sysCreated = DateTime.parse(json['sysCreated'] as String)
      ..sysUpdated = DateTime.parse(json['sysUpdated'] as String)
      ..id = json['id'] as String
      ..lastPaymentDate = json['lastPaymentDate'] as String?;

Map<String, dynamic> _$LoanToJson(Loan instance) => <String, dynamic>{
      'sysCreated': instance.sysCreated.toIso8601String(),
      'sysUpdated': instance.sysUpdated.toIso8601String(),
      'id': instance.id,
      'memberId': instance.memberId,
      'groupId': instance.groupId,
      'loanAmount': instance.loanAmount,
      'interestPercentage': instance.interestPercentage,
      'status': instance.status,
      'addedBy': instance.addedBy,
      'loanDate': instance.loanDate.toIso8601String(),
      'note': instance.note,
      'paidLoanAmount': instance.paidLoanAmount,
      'paidInterestAmount': instance.paidInterestAmount,
      'lastPaymentDate': instance.lastPaymentDate,
    };
