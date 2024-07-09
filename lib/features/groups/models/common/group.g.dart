// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      name: json['name'] as String,
      sdt: DateTime.parse(json['sdt'] as String),
      edt: DateTime.parse(json['edt'] as String),
      accountOpeningDate: DateTime.parse(json['accountOpeningDate'] as String),
      address: json['address'] as String?,
      bankName: json['bankName'] as String?,
      accountNo: json['accountNo'] as String?,
      ifscCode: json['ifscCode'] as String?,
      installmentAmtPerMonth:
          (json['installmentAmtPerMonth'] as num?)?.toDouble() ?? 0,
      loanInterestPercentPerMonth:
          (json['loanInterestPercentPerMonth'] as num?)?.toDouble() ?? 0,
      lateFeePerDay: (json['lateFeePerDay'] as num?)?.toDouble() ?? 0,
    )
      ..id = json['id'] as String
      ..sysCreated = DateTime.parse(json['sysCreated'] as String)
      ..sysUpdated = DateTime.parse(json['sysUpdated'] as String);

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'sysCreated': instance.sysCreated.toIso8601String(),
      'sysUpdated': instance.sysUpdated.toIso8601String(),
      'name': instance.name,
      'sdt': instance.sdt.toIso8601String(),
      'edt': instance.edt.toIso8601String(),
      'accountOpeningDate': instance.accountOpeningDate.toIso8601String(),
      'address': instance.address,
      'bankName': instance.bankName,
      'accountNo': instance.accountNo,
      'ifscCode': instance.ifscCode,
      'installmentAmtPerMonth': instance.installmentAmtPerMonth,
      'loanInterestPercentPerMonth': instance.loanInterestPercentPerMonth,
      'lateFeePerDay': instance.lateFeePerDay,
    };
