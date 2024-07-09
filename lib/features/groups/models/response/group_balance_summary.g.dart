// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_balance_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupBalanceSummary _$GroupBalanceSummaryFromJson(Map<String, dynamic> json) =>
    GroupBalanceSummary(
      previousRemaining: (json['previousRemaining'] as num).toDouble(),
      paidLoan: (json['paidLoan'] as num).toDouble(),
      deposit: (json['deposit'] as num).toDouble(),
      shares: (json['shares'] as num).toDouble(),
      loanInterest: (json['loanInterest'] as num).toDouble(),
      penalty: (json['penalty'] as num).toDouble(),
      otherDeposit: (json['otherDeposit'] as num).toDouble(),
      expenditures: (json['expenditures'] as num).toDouble(),
      givenLoan: (json['givenLoan'] as num).toDouble(),
      remainingLoan: (json['remainingLoan'] as num).toDouble(),
    );

Map<String, dynamic> _$GroupBalanceSummaryToJson(
        GroupBalanceSummary instance) =>
    <String, dynamic>{
      'previousRemaining': instance.previousRemaining,
      'paidLoan': instance.paidLoan,
      'deposit': instance.deposit,
      'shares': instance.shares,
      'loanInterest': instance.loanInterest,
      'penalty': instance.penalty,
      'otherDeposit': instance.otherDeposit,
      'expenditures': instance.expenditures,
      'givenLoan': instance.givenLoan,
      'remainingLoan': instance.remainingLoan,
    };
