// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_transaction_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberTransactionSummary _$MemberTransactionSummaryFromJson(
        Map<String, dynamic> json) =>
    MemberTransactionSummary(
      name: json['name'] as String,
      totalSharesDeposit: (json['totalSharesDeposit'] as num).toDouble(),
      totalLoanInterest: (json['totalLoanInterest'] as num).toDouble(),
      totalPenalty: (json['totalPenalty'] as num).toDouble(),
      otherDeposit: (json['otherDeposit'] as num).toDouble(),
      loanTakenTillDate: (json['loanTakenTillDate'] as num).toDouble(),
      loanReturn: (json['loanReturn'] as num).toDouble(),
      sharesGivenByGroup: (json['sharesGivenByGroup'] as num).toDouble(),
    )
      ..id = json['id'] as String
      ..sysCreated = DateTime.parse(json['sysCreated'] as String)
      ..sysUpdated = DateTime.parse(json['sysUpdated'] as String);

Map<String, dynamic> _$MemberTransactionSummaryToJson(
        MemberTransactionSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sysCreated': instance.sysCreated.toIso8601String(),
      'sysUpdated': instance.sysUpdated.toIso8601String(),
      'name': instance.name,
      'totalSharesDeposit': instance.totalSharesDeposit,
      'totalLoanInterest': instance.totalLoanInterest,
      'totalPenalty': instance.totalPenalty,
      'otherDeposit': instance.otherDeposit,
      'loanTakenTillDate': instance.loanTakenTillDate,
      'loanReturn': instance.loanReturn,
      'sharesGivenByGroup': instance.sharesGivenByGroup,
    };
