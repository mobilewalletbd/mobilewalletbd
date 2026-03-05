// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Contact _$ContactFromJson(Map<String, dynamic> json) {
  return _Contact.fromJson(json);
}

/// @nodoc
mixin _$Contact {
  /// Unique contact ID (UUID)
  String get id => throw _privateConstructorUsedError;

  /// ID of the user who owns this contact
  String get ownerId => throw _privateConstructorUsedError;

  /// Full name of the contact (required)
  String get fullName => throw _privateConstructorUsedError;

  /// First name
  String? get firstName => throw _privateConstructorUsedError;

  /// Last name
  String? get lastName => throw _privateConstructorUsedError;

  /// Job title or position
  String? get jobTitle => throw _privateConstructorUsedError;

  /// Company or organization name
  String? get companyName => throw _privateConstructorUsedError;

  /// List of phone numbers
  List<String> get phoneNumbers => throw _privateConstructorUsedError;

  /// List of email addresses
  List<String> get emails => throw _privateConstructorUsedError;

  /// List of physical addresses
  List<String> get addresses => throw _privateConstructorUsedError;

  /// List of website URLs
  List<String> get websiteUrls => throw _privateConstructorUsedError;

  /// Social media links
  List<SocialLink> get socialLinks => throw _privateConstructorUsedError;

  /// Contact category (business, personal, friends, family, uncategorized)
  String get category => throw _privateConstructorUsedError;

  /// Custom tags for organization
  List<String> get tags => throw _privateConstructorUsedError;

  /// Whether this contact is marked as favorite
  bool get isFavorite => throw _privateConstructorUsedError;

  /// Additional notes about the contact
  String? get notes => throw _privateConstructorUsedError;

  /// URL to front side of business card image (Cloudinary)
  String? get frontImageUrl => throw _privateConstructorUsedError;

  /// URL to back side of business card image (Cloudinary)
  String? get backImageUrl => throw _privateConstructorUsedError;

  /// Raw OCR text extracted from front card image
  String? get frontImageOcrText => throw _privateConstructorUsedError;

  /// Raw OCR text extracted from back card image
  String? get backImageOcrText => throw _privateConstructorUsedError;

  /// Structured OCR data fields
  Map<String, dynamic>? get ocrFields => throw _privateConstructorUsedError;

  /// Timestamp of last interaction with this contact
  DateTime? get lastContactedAt => throw _privateConstructorUsedError;

  /// Number of times this contact has been contacted
  int get contactCount => throw _privateConstructorUsedError;

  /// Source of contact (manual, scan, import, nfc, qr)
  String? get source => throw _privateConstructorUsedError;

  /// Whether this contact has been verified
  bool get isVerified => throw _privateConstructorUsedError;

  /// Fraud/trust score (0.0 - 1.0)
  double get fraudScore => throw _privateConstructorUsedError;

  /// Raw profile data from auth provider or import source
  Map<String, dynamic>? get rawExtraData => throw _privateConstructorUsedError;

  /// Timestamp when contact was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Timestamp when contact was last updated
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// ID of user who created this contact (for team sharing)
  String? get createdBy => throw _privateConstructorUsedError;

  /// List of user IDs this contact is shared with
  List<String>? get sharedWith => throw _privateConstructorUsedError;

  /// List of team IDs this contact is shared with
  List<String> get sharedWithTeams => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContactCopyWith<Contact> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactCopyWith<$Res> {
  factory $ContactCopyWith(Contact value, $Res Function(Contact) then) =
      _$ContactCopyWithImpl<$Res, Contact>;
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String fullName,
      String? firstName,
      String? lastName,
      String? jobTitle,
      String? companyName,
      List<String> phoneNumbers,
      List<String> emails,
      List<String> addresses,
      List<String> websiteUrls,
      List<SocialLink> socialLinks,
      String category,
      List<String> tags,
      bool isFavorite,
      String? notes,
      String? frontImageUrl,
      String? backImageUrl,
      String? frontImageOcrText,
      String? backImageOcrText,
      Map<String, dynamic>? ocrFields,
      DateTime? lastContactedAt,
      int contactCount,
      String? source,
      bool isVerified,
      double fraudScore,
      Map<String, dynamic>? rawExtraData,
      DateTime createdAt,
      DateTime updatedAt,
      String? createdBy,
      List<String>? sharedWith,
      List<String> sharedWithTeams});
}

/// @nodoc
class _$ContactCopyWithImpl<$Res, $Val extends Contact>
    implements $ContactCopyWith<$Res> {
  _$ContactCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? fullName = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? jobTitle = freezed,
    Object? companyName = freezed,
    Object? phoneNumbers = null,
    Object? emails = null,
    Object? addresses = null,
    Object? websiteUrls = null,
    Object? socialLinks = null,
    Object? category = null,
    Object? tags = null,
    Object? isFavorite = null,
    Object? notes = freezed,
    Object? frontImageUrl = freezed,
    Object? backImageUrl = freezed,
    Object? frontImageOcrText = freezed,
    Object? backImageOcrText = freezed,
    Object? ocrFields = freezed,
    Object? lastContactedAt = freezed,
    Object? contactCount = null,
    Object? source = freezed,
    Object? isVerified = null,
    Object? fraudScore = null,
    Object? rawExtraData = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
    Object? sharedWith = freezed,
    Object? sharedWithTeams = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      jobTitle: freezed == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumbers: null == phoneNumbers
          ? _value.phoneNumbers
          : phoneNumbers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      emails: null == emails
          ? _value.emails
          : emails // ignore: cast_nullable_to_non_nullable
              as List<String>,
      addresses: null == addresses
          ? _value.addresses
          : addresses // ignore: cast_nullable_to_non_nullable
              as List<String>,
      websiteUrls: null == websiteUrls
          ? _value.websiteUrls
          : websiteUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      socialLinks: null == socialLinks
          ? _value.socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as List<SocialLink>,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      frontImageUrl: freezed == frontImageUrl
          ? _value.frontImageUrl
          : frontImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      backImageUrl: freezed == backImageUrl
          ? _value.backImageUrl
          : backImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      frontImageOcrText: freezed == frontImageOcrText
          ? _value.frontImageOcrText
          : frontImageOcrText // ignore: cast_nullable_to_non_nullable
              as String?,
      backImageOcrText: freezed == backImageOcrText
          ? _value.backImageOcrText
          : backImageOcrText // ignore: cast_nullable_to_non_nullable
              as String?,
      ocrFields: freezed == ocrFields
          ? _value.ocrFields
          : ocrFields // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      lastContactedAt: freezed == lastContactedAt
          ? _value.lastContactedAt
          : lastContactedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      contactCount: null == contactCount
          ? _value.contactCount
          : contactCount // ignore: cast_nullable_to_non_nullable
              as int,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      fraudScore: null == fraudScore
          ? _value.fraudScore
          : fraudScore // ignore: cast_nullable_to_non_nullable
              as double,
      rawExtraData: freezed == rawExtraData
          ? _value.rawExtraData
          : rawExtraData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      sharedWith: freezed == sharedWith
          ? _value.sharedWith
          : sharedWith // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      sharedWithTeams: null == sharedWithTeams
          ? _value.sharedWithTeams
          : sharedWithTeams // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactImplCopyWith<$Res> implements $ContactCopyWith<$Res> {
  factory _$$ContactImplCopyWith(
          _$ContactImpl value, $Res Function(_$ContactImpl) then) =
      __$$ContactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String fullName,
      String? firstName,
      String? lastName,
      String? jobTitle,
      String? companyName,
      List<String> phoneNumbers,
      List<String> emails,
      List<String> addresses,
      List<String> websiteUrls,
      List<SocialLink> socialLinks,
      String category,
      List<String> tags,
      bool isFavorite,
      String? notes,
      String? frontImageUrl,
      String? backImageUrl,
      String? frontImageOcrText,
      String? backImageOcrText,
      Map<String, dynamic>? ocrFields,
      DateTime? lastContactedAt,
      int contactCount,
      String? source,
      bool isVerified,
      double fraudScore,
      Map<String, dynamic>? rawExtraData,
      DateTime createdAt,
      DateTime updatedAt,
      String? createdBy,
      List<String>? sharedWith,
      List<String> sharedWithTeams});
}

/// @nodoc
class __$$ContactImplCopyWithImpl<$Res>
    extends _$ContactCopyWithImpl<$Res, _$ContactImpl>
    implements _$$ContactImplCopyWith<$Res> {
  __$$ContactImplCopyWithImpl(
      _$ContactImpl _value, $Res Function(_$ContactImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? fullName = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? jobTitle = freezed,
    Object? companyName = freezed,
    Object? phoneNumbers = null,
    Object? emails = null,
    Object? addresses = null,
    Object? websiteUrls = null,
    Object? socialLinks = null,
    Object? category = null,
    Object? tags = null,
    Object? isFavorite = null,
    Object? notes = freezed,
    Object? frontImageUrl = freezed,
    Object? backImageUrl = freezed,
    Object? frontImageOcrText = freezed,
    Object? backImageOcrText = freezed,
    Object? ocrFields = freezed,
    Object? lastContactedAt = freezed,
    Object? contactCount = null,
    Object? source = freezed,
    Object? isVerified = null,
    Object? fraudScore = null,
    Object? rawExtraData = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
    Object? sharedWith = freezed,
    Object? sharedWithTeams = null,
  }) {
    return _then(_$ContactImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      jobTitle: freezed == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumbers: null == phoneNumbers
          ? _value._phoneNumbers
          : phoneNumbers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      emails: null == emails
          ? _value._emails
          : emails // ignore: cast_nullable_to_non_nullable
              as List<String>,
      addresses: null == addresses
          ? _value._addresses
          : addresses // ignore: cast_nullable_to_non_nullable
              as List<String>,
      websiteUrls: null == websiteUrls
          ? _value._websiteUrls
          : websiteUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      socialLinks: null == socialLinks
          ? _value._socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as List<SocialLink>,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      frontImageUrl: freezed == frontImageUrl
          ? _value.frontImageUrl
          : frontImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      backImageUrl: freezed == backImageUrl
          ? _value.backImageUrl
          : backImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      frontImageOcrText: freezed == frontImageOcrText
          ? _value.frontImageOcrText
          : frontImageOcrText // ignore: cast_nullable_to_non_nullable
              as String?,
      backImageOcrText: freezed == backImageOcrText
          ? _value.backImageOcrText
          : backImageOcrText // ignore: cast_nullable_to_non_nullable
              as String?,
      ocrFields: freezed == ocrFields
          ? _value._ocrFields
          : ocrFields // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      lastContactedAt: freezed == lastContactedAt
          ? _value.lastContactedAt
          : lastContactedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      contactCount: null == contactCount
          ? _value.contactCount
          : contactCount // ignore: cast_nullable_to_non_nullable
              as int,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      fraudScore: null == fraudScore
          ? _value.fraudScore
          : fraudScore // ignore: cast_nullable_to_non_nullable
              as double,
      rawExtraData: freezed == rawExtraData
          ? _value._rawExtraData
          : rawExtraData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      sharedWith: freezed == sharedWith
          ? _value._sharedWith
          : sharedWith // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      sharedWithTeams: null == sharedWithTeams
          ? _value._sharedWithTeams
          : sharedWithTeams // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactImpl extends _Contact {
  const _$ContactImpl(
      {required this.id,
      required this.ownerId,
      required this.fullName,
      this.firstName,
      this.lastName,
      this.jobTitle,
      this.companyName,
      final List<String> phoneNumbers = const [],
      final List<String> emails = const [],
      final List<String> addresses = const [],
      final List<String> websiteUrls = const [],
      final List<SocialLink> socialLinks = const [],
      this.category = 'uncategorized',
      final List<String> tags = const [],
      this.isFavorite = false,
      this.notes,
      this.frontImageUrl,
      this.backImageUrl,
      this.frontImageOcrText,
      this.backImageOcrText,
      final Map<String, dynamic>? ocrFields,
      this.lastContactedAt,
      this.contactCount = 0,
      this.source,
      this.isVerified = false,
      this.fraudScore = 0.0,
      final Map<String, dynamic>? rawExtraData,
      required this.createdAt,
      required this.updatedAt,
      this.createdBy,
      final List<String>? sharedWith,
      final List<String> sharedWithTeams = const []})
      : _phoneNumbers = phoneNumbers,
        _emails = emails,
        _addresses = addresses,
        _websiteUrls = websiteUrls,
        _socialLinks = socialLinks,
        _tags = tags,
        _ocrFields = ocrFields,
        _rawExtraData = rawExtraData,
        _sharedWith = sharedWith,
        _sharedWithTeams = sharedWithTeams,
        super._();

  factory _$ContactImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactImplFromJson(json);

  /// Unique contact ID (UUID)
  @override
  final String id;

  /// ID of the user who owns this contact
  @override
  final String ownerId;

  /// Full name of the contact (required)
  @override
  final String fullName;

  /// First name
  @override
  final String? firstName;

  /// Last name
  @override
  final String? lastName;

  /// Job title or position
  @override
  final String? jobTitle;

  /// Company or organization name
  @override
  final String? companyName;

  /// List of phone numbers
  final List<String> _phoneNumbers;

  /// List of phone numbers
  @override
  @JsonKey()
  List<String> get phoneNumbers {
    if (_phoneNumbers is EqualUnmodifiableListView) return _phoneNumbers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_phoneNumbers);
  }

  /// List of email addresses
  final List<String> _emails;

  /// List of email addresses
  @override
  @JsonKey()
  List<String> get emails {
    if (_emails is EqualUnmodifiableListView) return _emails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_emails);
  }

  /// List of physical addresses
  final List<String> _addresses;

  /// List of physical addresses
  @override
  @JsonKey()
  List<String> get addresses {
    if (_addresses is EqualUnmodifiableListView) return _addresses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addresses);
  }

  /// List of website URLs
  final List<String> _websiteUrls;

  /// List of website URLs
  @override
  @JsonKey()
  List<String> get websiteUrls {
    if (_websiteUrls is EqualUnmodifiableListView) return _websiteUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_websiteUrls);
  }

  /// Social media links
  final List<SocialLink> _socialLinks;

  /// Social media links
  @override
  @JsonKey()
  List<SocialLink> get socialLinks {
    if (_socialLinks is EqualUnmodifiableListView) return _socialLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_socialLinks);
  }

  /// Contact category (business, personal, friends, family, uncategorized)
  @override
  @JsonKey()
  final String category;

  /// Custom tags for organization
  final List<String> _tags;

  /// Custom tags for organization
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// Whether this contact is marked as favorite
  @override
  @JsonKey()
  final bool isFavorite;

  /// Additional notes about the contact
  @override
  final String? notes;

  /// URL to front side of business card image (Cloudinary)
  @override
  final String? frontImageUrl;

  /// URL to back side of business card image (Cloudinary)
  @override
  final String? backImageUrl;

  /// Raw OCR text extracted from front card image
  @override
  final String? frontImageOcrText;

  /// Raw OCR text extracted from back card image
  @override
  final String? backImageOcrText;

  /// Structured OCR data fields
  final Map<String, dynamic>? _ocrFields;

  /// Structured OCR data fields
  @override
  Map<String, dynamic>? get ocrFields {
    final value = _ocrFields;
    if (value == null) return null;
    if (_ocrFields is EqualUnmodifiableMapView) return _ocrFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Timestamp of last interaction with this contact
  @override
  final DateTime? lastContactedAt;

  /// Number of times this contact has been contacted
  @override
  @JsonKey()
  final int contactCount;

  /// Source of contact (manual, scan, import, nfc, qr)
  @override
  final String? source;

  /// Whether this contact has been verified
  @override
  @JsonKey()
  final bool isVerified;

  /// Fraud/trust score (0.0 - 1.0)
  @override
  @JsonKey()
  final double fraudScore;

  /// Raw profile data from auth provider or import source
  final Map<String, dynamic>? _rawExtraData;

  /// Raw profile data from auth provider or import source
  @override
  Map<String, dynamic>? get rawExtraData {
    final value = _rawExtraData;
    if (value == null) return null;
    if (_rawExtraData is EqualUnmodifiableMapView) return _rawExtraData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Timestamp when contact was created
  @override
  final DateTime createdAt;

  /// Timestamp when contact was last updated
  @override
  final DateTime updatedAt;

  /// ID of user who created this contact (for team sharing)
  @override
  final String? createdBy;

  /// List of user IDs this contact is shared with
  final List<String>? _sharedWith;

  /// List of user IDs this contact is shared with
  @override
  List<String>? get sharedWith {
    final value = _sharedWith;
    if (value == null) return null;
    if (_sharedWith is EqualUnmodifiableListView) return _sharedWith;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// List of team IDs this contact is shared with
  final List<String> _sharedWithTeams;

  /// List of team IDs this contact is shared with
  @override
  @JsonKey()
  List<String> get sharedWithTeams {
    if (_sharedWithTeams is EqualUnmodifiableListView) return _sharedWithTeams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sharedWithTeams);
  }

  @override
  String toString() {
    return 'Contact(id: $id, ownerId: $ownerId, fullName: $fullName, firstName: $firstName, lastName: $lastName, jobTitle: $jobTitle, companyName: $companyName, phoneNumbers: $phoneNumbers, emails: $emails, addresses: $addresses, websiteUrls: $websiteUrls, socialLinks: $socialLinks, category: $category, tags: $tags, isFavorite: $isFavorite, notes: $notes, frontImageUrl: $frontImageUrl, backImageUrl: $backImageUrl, frontImageOcrText: $frontImageOcrText, backImageOcrText: $backImageOcrText, ocrFields: $ocrFields, lastContactedAt: $lastContactedAt, contactCount: $contactCount, source: $source, isVerified: $isVerified, fraudScore: $fraudScore, rawExtraData: $rawExtraData, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, sharedWith: $sharedWith, sharedWithTeams: $sharedWithTeams)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.jobTitle, jobTitle) ||
                other.jobTitle == jobTitle) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            const DeepCollectionEquality()
                .equals(other._phoneNumbers, _phoneNumbers) &&
            const DeepCollectionEquality().equals(other._emails, _emails) &&
            const DeepCollectionEquality()
                .equals(other._addresses, _addresses) &&
            const DeepCollectionEquality()
                .equals(other._websiteUrls, _websiteUrls) &&
            const DeepCollectionEquality()
                .equals(other._socialLinks, _socialLinks) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.frontImageUrl, frontImageUrl) ||
                other.frontImageUrl == frontImageUrl) &&
            (identical(other.backImageUrl, backImageUrl) ||
                other.backImageUrl == backImageUrl) &&
            (identical(other.frontImageOcrText, frontImageOcrText) ||
                other.frontImageOcrText == frontImageOcrText) &&
            (identical(other.backImageOcrText, backImageOcrText) ||
                other.backImageOcrText == backImageOcrText) &&
            const DeepCollectionEquality()
                .equals(other._ocrFields, _ocrFields) &&
            (identical(other.lastContactedAt, lastContactedAt) ||
                other.lastContactedAt == lastContactedAt) &&
            (identical(other.contactCount, contactCount) ||
                other.contactCount == contactCount) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.fraudScore, fraudScore) ||
                other.fraudScore == fraudScore) &&
            const DeepCollectionEquality()
                .equals(other._rawExtraData, _rawExtraData) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            const DeepCollectionEquality()
                .equals(other._sharedWith, _sharedWith) &&
            const DeepCollectionEquality()
                .equals(other._sharedWithTeams, _sharedWithTeams));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        ownerId,
        fullName,
        firstName,
        lastName,
        jobTitle,
        companyName,
        const DeepCollectionEquality().hash(_phoneNumbers),
        const DeepCollectionEquality().hash(_emails),
        const DeepCollectionEquality().hash(_addresses),
        const DeepCollectionEquality().hash(_websiteUrls),
        const DeepCollectionEquality().hash(_socialLinks),
        category,
        const DeepCollectionEquality().hash(_tags),
        isFavorite,
        notes,
        frontImageUrl,
        backImageUrl,
        frontImageOcrText,
        backImageOcrText,
        const DeepCollectionEquality().hash(_ocrFields),
        lastContactedAt,
        contactCount,
        source,
        isVerified,
        fraudScore,
        const DeepCollectionEquality().hash(_rawExtraData),
        createdAt,
        updatedAt,
        createdBy,
        const DeepCollectionEquality().hash(_sharedWith),
        const DeepCollectionEquality().hash(_sharedWithTeams)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactImplCopyWith<_$ContactImpl> get copyWith =>
      __$$ContactImplCopyWithImpl<_$ContactImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactImplToJson(
      this,
    );
  }
}

abstract class _Contact extends Contact {
  const factory _Contact(
      {required final String id,
      required final String ownerId,
      required final String fullName,
      final String? firstName,
      final String? lastName,
      final String? jobTitle,
      final String? companyName,
      final List<String> phoneNumbers,
      final List<String> emails,
      final List<String> addresses,
      final List<String> websiteUrls,
      final List<SocialLink> socialLinks,
      final String category,
      final List<String> tags,
      final bool isFavorite,
      final String? notes,
      final String? frontImageUrl,
      final String? backImageUrl,
      final String? frontImageOcrText,
      final String? backImageOcrText,
      final Map<String, dynamic>? ocrFields,
      final DateTime? lastContactedAt,
      final int contactCount,
      final String? source,
      final bool isVerified,
      final double fraudScore,
      final Map<String, dynamic>? rawExtraData,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? createdBy,
      final List<String>? sharedWith,
      final List<String> sharedWithTeams}) = _$ContactImpl;
  const _Contact._() : super._();

  factory _Contact.fromJson(Map<String, dynamic> json) = _$ContactImpl.fromJson;

  @override

  /// Unique contact ID (UUID)
  String get id;
  @override

  /// ID of the user who owns this contact
  String get ownerId;
  @override

  /// Full name of the contact (required)
  String get fullName;
  @override

  /// First name
  String? get firstName;
  @override

  /// Last name
  String? get lastName;
  @override

  /// Job title or position
  String? get jobTitle;
  @override

  /// Company or organization name
  String? get companyName;
  @override

  /// List of phone numbers
  List<String> get phoneNumbers;
  @override

  /// List of email addresses
  List<String> get emails;
  @override

  /// List of physical addresses
  List<String> get addresses;
  @override

  /// List of website URLs
  List<String> get websiteUrls;
  @override

  /// Social media links
  List<SocialLink> get socialLinks;
  @override

  /// Contact category (business, personal, friends, family, uncategorized)
  String get category;
  @override

  /// Custom tags for organization
  List<String> get tags;
  @override

  /// Whether this contact is marked as favorite
  bool get isFavorite;
  @override

  /// Additional notes about the contact
  String? get notes;
  @override

  /// URL to front side of business card image (Cloudinary)
  String? get frontImageUrl;
  @override

  /// URL to back side of business card image (Cloudinary)
  String? get backImageUrl;
  @override

  /// Raw OCR text extracted from front card image
  String? get frontImageOcrText;
  @override

  /// Raw OCR text extracted from back card image
  String? get backImageOcrText;
  @override

  /// Structured OCR data fields
  Map<String, dynamic>? get ocrFields;
  @override

  /// Timestamp of last interaction with this contact
  DateTime? get lastContactedAt;
  @override

  /// Number of times this contact has been contacted
  int get contactCount;
  @override

  /// Source of contact (manual, scan, import, nfc, qr)
  String? get source;
  @override

  /// Whether this contact has been verified
  bool get isVerified;
  @override

  /// Fraud/trust score (0.0 - 1.0)
  double get fraudScore;
  @override

  /// Raw profile data from auth provider or import source
  Map<String, dynamic>? get rawExtraData;
  @override

  /// Timestamp when contact was created
  DateTime get createdAt;
  @override

  /// Timestamp when contact was last updated
  DateTime get updatedAt;
  @override

  /// ID of user who created this contact (for team sharing)
  String? get createdBy;
  @override

  /// List of user IDs this contact is shared with
  List<String>? get sharedWith;
  @override

  /// List of team IDs this contact is shared with
  List<String> get sharedWithTeams;
  @override
  @JsonKey(ignore: true)
  _$$ContactImplCopyWith<_$ContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocialLink _$SocialLinkFromJson(Map<String, dynamic> json) {
  return _SocialLink.fromJson(json);
}

/// @nodoc
mixin _$SocialLink {
  /// Platform name (linkedin, twitter, facebook, instagram, etc.)
  String get platform => throw _privateConstructorUsedError;

  /// Full URL to the profile
  String get url => throw _privateConstructorUsedError;

  /// Username/handle on the platform
  String? get handle => throw _privateConstructorUsedError;

  /// Platform-specific ID
  String? get platformId => throw _privateConstructorUsedError;

  /// Whether this link is publicly visible
  bool get isPublic => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SocialLinkCopyWith<SocialLink> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialLinkCopyWith<$Res> {
  factory $SocialLinkCopyWith(
          SocialLink value, $Res Function(SocialLink) then) =
      _$SocialLinkCopyWithImpl<$Res, SocialLink>;
  @useResult
  $Res call(
      {String platform,
      String url,
      String? handle,
      String? platformId,
      bool isPublic});
}

/// @nodoc
class _$SocialLinkCopyWithImpl<$Res, $Val extends SocialLink>
    implements $SocialLinkCopyWith<$Res> {
  _$SocialLinkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platform = null,
    Object? url = null,
    Object? handle = freezed,
    Object? platformId = freezed,
    Object? isPublic = null,
  }) {
    return _then(_value.copyWith(
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      handle: freezed == handle
          ? _value.handle
          : handle // ignore: cast_nullable_to_non_nullable
              as String?,
      platformId: freezed == platformId
          ? _value.platformId
          : platformId // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialLinkImplCopyWith<$Res>
    implements $SocialLinkCopyWith<$Res> {
  factory _$$SocialLinkImplCopyWith(
          _$SocialLinkImpl value, $Res Function(_$SocialLinkImpl) then) =
      __$$SocialLinkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String platform,
      String url,
      String? handle,
      String? platformId,
      bool isPublic});
}

/// @nodoc
class __$$SocialLinkImplCopyWithImpl<$Res>
    extends _$SocialLinkCopyWithImpl<$Res, _$SocialLinkImpl>
    implements _$$SocialLinkImplCopyWith<$Res> {
  __$$SocialLinkImplCopyWithImpl(
      _$SocialLinkImpl _value, $Res Function(_$SocialLinkImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platform = null,
    Object? url = null,
    Object? handle = freezed,
    Object? platformId = freezed,
    Object? isPublic = null,
  }) {
    return _then(_$SocialLinkImpl(
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      handle: freezed == handle
          ? _value.handle
          : handle // ignore: cast_nullable_to_non_nullable
              as String?,
      platformId: freezed == platformId
          ? _value.platformId
          : platformId // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialLinkImpl implements _SocialLink {
  const _$SocialLinkImpl(
      {required this.platform,
      required this.url,
      this.handle,
      this.platformId,
      this.isPublic = true});

  factory _$SocialLinkImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialLinkImplFromJson(json);

  /// Platform name (linkedin, twitter, facebook, instagram, etc.)
  @override
  final String platform;

  /// Full URL to the profile
  @override
  final String url;

  /// Username/handle on the platform
  @override
  final String? handle;

  /// Platform-specific ID
  @override
  final String? platformId;

  /// Whether this link is publicly visible
  @override
  @JsonKey()
  final bool isPublic;

  @override
  String toString() {
    return 'SocialLink(platform: $platform, url: $url, handle: $handle, platformId: $platformId, isPublic: $isPublic)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialLinkImpl &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.handle, handle) || other.handle == handle) &&
            (identical(other.platformId, platformId) ||
                other.platformId == platformId) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, platform, url, handle, platformId, isPublic);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialLinkImplCopyWith<_$SocialLinkImpl> get copyWith =>
      __$$SocialLinkImplCopyWithImpl<_$SocialLinkImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialLinkImplToJson(
      this,
    );
  }
}

abstract class _SocialLink implements SocialLink {
  const factory _SocialLink(
      {required final String platform,
      required final String url,
      final String? handle,
      final String? platformId,
      final bool isPublic}) = _$SocialLinkImpl;

  factory _SocialLink.fromJson(Map<String, dynamic> json) =
      _$SocialLinkImpl.fromJson;

  @override

  /// Platform name (linkedin, twitter, facebook, instagram, etc.)
  String get platform;
  @override

  /// Full URL to the profile
  String get url;
  @override

  /// Username/handle on the platform
  String? get handle;
  @override

  /// Platform-specific ID
  String? get platformId;
  @override

  /// Whether this link is publicly visible
  bool get isPublic;
  @override
  @JsonKey(ignore: true)
  _$$SocialLinkImplCopyWith<_$SocialLinkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
