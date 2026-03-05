// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TeamExpense _$TeamExpenseFromJson(Map<String, dynamic> json) {
  return _TeamExpense.fromJson(json);
}

/// @nodoc
mixin _$TeamExpense {
  String get id => throw _privateConstructorUsedError;
  String get teamId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get addedByUserId =>
      throw _privateConstructorUsedError; // userId of the member who added it
  String? get category => throw _privateConstructorUsedError;
  String? get receiptUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TeamExpenseCopyWith<TeamExpense> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamExpenseCopyWith<$Res> {
  factory $TeamExpenseCopyWith(
          TeamExpense value, $Res Function(TeamExpense) then) =
      _$TeamExpenseCopyWithImpl<$Res, TeamExpense>;
  @useResult
  $Res call(
      {String id,
      String teamId,
      String title,
      double amount,
      String currency,
      DateTime date,
      String addedByUserId,
      String? category,
      String? receiptUrl});
}

/// @nodoc
class _$TeamExpenseCopyWithImpl<$Res, $Val extends TeamExpense>
    implements $TeamExpenseCopyWith<$Res> {
  _$TeamExpenseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teamId = null,
    Object? title = null,
    Object? amount = null,
    Object? currency = null,
    Object? date = null,
    Object? addedByUserId = null,
    Object? category = freezed,
    Object? receiptUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: null == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      addedByUserId: null == addedByUserId
          ? _value.addedByUserId
          : addedByUserId // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptUrl: freezed == receiptUrl
          ? _value.receiptUrl
          : receiptUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeamExpenseImplCopyWith<$Res>
    implements $TeamExpenseCopyWith<$Res> {
  factory _$$TeamExpenseImplCopyWith(
          _$TeamExpenseImpl value, $Res Function(_$TeamExpenseImpl) then) =
      __$$TeamExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String teamId,
      String title,
      double amount,
      String currency,
      DateTime date,
      String addedByUserId,
      String? category,
      String? receiptUrl});
}

/// @nodoc
class __$$TeamExpenseImplCopyWithImpl<$Res>
    extends _$TeamExpenseCopyWithImpl<$Res, _$TeamExpenseImpl>
    implements _$$TeamExpenseImplCopyWith<$Res> {
  __$$TeamExpenseImplCopyWithImpl(
      _$TeamExpenseImpl _value, $Res Function(_$TeamExpenseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teamId = null,
    Object? title = null,
    Object? amount = null,
    Object? currency = null,
    Object? date = null,
    Object? addedByUserId = null,
    Object? category = freezed,
    Object? receiptUrl = freezed,
  }) {
    return _then(_$TeamExpenseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: null == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      addedByUserId: null == addedByUserId
          ? _value.addedByUserId
          : addedByUserId // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptUrl: freezed == receiptUrl
          ? _value.receiptUrl
          : receiptUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamExpenseImpl implements _TeamExpense {
  const _$TeamExpenseImpl(
      {required this.id,
      required this.teamId,
      required this.title,
      required this.amount,
      required this.currency,
      required this.date,
      required this.addedByUserId,
      this.category,
      this.receiptUrl});

  factory _$TeamExpenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamExpenseImplFromJson(json);

  @override
  final String id;
  @override
  final String teamId;
  @override
  final String title;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final DateTime date;
  @override
  final String addedByUserId;
// userId of the member who added it
  @override
  final String? category;
  @override
  final String? receiptUrl;

  @override
  String toString() {
    return 'TeamExpense(id: $id, teamId: $teamId, title: $title, amount: $amount, currency: $currency, date: $date, addedByUserId: $addedByUserId, category: $category, receiptUrl: $receiptUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamExpenseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.addedByUserId, addedByUserId) ||
                other.addedByUserId == addedByUserId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.receiptUrl, receiptUrl) ||
                other.receiptUrl == receiptUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, teamId, title, amount,
      currency, date, addedByUserId, category, receiptUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamExpenseImplCopyWith<_$TeamExpenseImpl> get copyWith =>
      __$$TeamExpenseImplCopyWithImpl<_$TeamExpenseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamExpenseImplToJson(
      this,
    );
  }
}

abstract class _TeamExpense implements TeamExpense {
  const factory _TeamExpense(
      {required final String id,
      required final String teamId,
      required final String title,
      required final double amount,
      required final String currency,
      required final DateTime date,
      required final String addedByUserId,
      final String? category,
      final String? receiptUrl}) = _$TeamExpenseImpl;

  factory _TeamExpense.fromJson(Map<String, dynamic> json) =
      _$TeamExpenseImpl.fromJson;

  @override
  String get id;
  @override
  String get teamId;
  @override
  String get title;
  @override
  double get amount;
  @override
  String get currency;
  @override
  DateTime get date;
  @override
  String get addedByUserId;
  @override // userId of the member who added it
  String? get category;
  @override
  String? get receiptUrl;
  @override
  @JsonKey(ignore: true)
  _$$TeamExpenseImplCopyWith<_$TeamExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
