import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_expense.freezed.dart';
part 'team_expense.g.dart';

@freezed
class TeamExpense with _$TeamExpense {
  const factory TeamExpense({
    required String id,
    required String teamId,
    required String title,
    required double amount,
    required String currency,
    required DateTime date,
    required String addedByUserId, // userId of the member who added it
    String? category,
    String? receiptUrl,
  }) = _TeamExpense;

  factory TeamExpense.fromJson(Map<String, dynamic> json) =>
      _$TeamExpenseFromJson(json);
}
