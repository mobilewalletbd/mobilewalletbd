// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamExpenseImpl _$$TeamExpenseImplFromJson(Map<String, dynamic> json) =>
    _$TeamExpenseImpl(
      id: json['id'] as String,
      teamId: json['teamId'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      date: DateTime.parse(json['date'] as String),
      addedByUserId: json['addedByUserId'] as String,
      category: json['category'] as String?,
      receiptUrl: json['receiptUrl'] as String?,
    );

Map<String, dynamic> _$$TeamExpenseImplToJson(_$TeamExpenseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teamId': instance.teamId,
      'title': instance.title,
      'amount': instance.amount,
      'currency': instance.currency,
      'date': instance.date.toIso8601String(),
      'addedByUserId': instance.addedByUserId,
      'category': instance.category,
      'receiptUrl': instance.receiptUrl,
    };
