// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_transaction_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberTransactionDetails _$MemberTransactionDetailsFromJson(
        Map<String, dynamic> json) =>
    MemberTransactionDetails(
      memberId: json['memberId'] as String?,
      trxPeriod: json['trxPeriod'] as String?,
      paidShares: (json['paidShares'] as num?)?.toDouble(),
      loanTaken: (json['loanTaken'] as num?)?.toDouble(),
      paidInterest: (json['paidInterest'] as num?)?.toDouble(),
      paidLoan: (json['paidLoan'] as num?)?.toDouble(),
      remainingLoan: (json['remainingLoan'] as num?)?.toDouble(),
      paidLateFee: (json['paidLateFee'] as num?)?.toDouble(),
      paidOtherAmount: (json['paidOtherAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MemberTransactionDetailsToJson(
        MemberTransactionDetails instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'trxPeriod': instance.trxPeriod,
      'paidShares': instance.paidShares,
      'loanTaken': instance.loanTaken,
      'paidInterest': instance.paidInterest,
      'paidLoan': instance.paidLoan,
      'remainingLoan': instance.remainingLoan,
      'paidLateFee': instance.paidLateFee,
      'paidOtherAmount': instance.paidOtherAmount,
    };
