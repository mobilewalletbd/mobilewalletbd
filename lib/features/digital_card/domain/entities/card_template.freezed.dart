// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CardTemplate _$CardTemplateFromJson(Map<String, dynamic> json) {
  return _CardTemplate.fromJson(json);
}

/// @nodoc
mixin _$CardTemplate {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  TemplateCategory get category => throw _privateConstructorUsedError;
  LayoutStyle get layoutStyle => throw _privateConstructorUsedError; // Colors
  @ColorConverter()
  Color get primaryColor => throw _privateConstructorUsedError;
  @ColorConverter()
  Color get secondaryColor => throw _privateConstructorUsedError;
  @ColorConverter()
  Color get backgroundColor => throw _privateConstructorUsedError;
  @ColorConverter()
  Color get textColor => throw _privateConstructorUsedError;
  @ColorConverter()
  Color get accentColor => throw _privateConstructorUsedError;
  @ColorListConverter()
  List<Color>? get backgroundGradient =>
      throw _privateConstructorUsedError; // Patterns
  CardPatternType get patternType => throw _privateConstructorUsedError;
  @ColorConverter()
  Color get patternColor => throw _privateConstructorUsedError;
  double get patternOpacity => throw _privateConstructorUsedError; // Typography
  String get fontFamily => throw _privateConstructorUsedError;
  double get nameFontSize => throw _privateConstructorUsedError;
  double get titleFontSize => throw _privateConstructorUsedError;
  double get bodyFontSize => throw _privateConstructorUsedError;
  @FontWeightConverter()
  FontWeight get nameFontWeight => throw _privateConstructorUsedError;
  @FontWeightConverter()
  FontWeight get titleFontWeight =>
      throw _privateConstructorUsedError; // Layout properties
  TextAlignment get nameAlignment => throw _privateConstructorUsedError;
  TextAlignment get titleAlignment => throw _privateConstructorUsedError;
  TextAlignment get contactAlignment => throw _privateConstructorUsedError;
  bool get showLogo => throw _privateConstructorUsedError;
  bool get showQrCode => throw _privateConstructorUsedError;
  bool get showSocialIcons => throw _privateConstructorUsedError;
  bool get hasBackgroundPattern =>
      throw _privateConstructorUsedError; // Deprecated in favor of patternType
// Spacing
  double get contentPadding => throw _privateConstructorUsedError;
  double get elementSpacing => throw _privateConstructorUsedError;
  double get borderRadius => throw _privateConstructorUsedError; // Preview
  String get previewImageUrl => throw _privateConstructorUsedError;
  bool get isPremium => throw _privateConstructorUsedError;
  int get popularity => throw _privateConstructorUsedError; // For sorting
// Timestamps
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CardTemplateCopyWith<CardTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardTemplateCopyWith<$Res> {
  factory $CardTemplateCopyWith(
          CardTemplate value, $Res Function(CardTemplate) then) =
      _$CardTemplateCopyWithImpl<$Res, CardTemplate>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      TemplateCategory category,
      LayoutStyle layoutStyle,
      @ColorConverter() Color primaryColor,
      @ColorConverter() Color secondaryColor,
      @ColorConverter() Color backgroundColor,
      @ColorConverter() Color textColor,
      @ColorConverter() Color accentColor,
      @ColorListConverter() List<Color>? backgroundGradient,
      CardPatternType patternType,
      @ColorConverter() Color patternColor,
      double patternOpacity,
      String fontFamily,
      double nameFontSize,
      double titleFontSize,
      double bodyFontSize,
      @FontWeightConverter() FontWeight nameFontWeight,
      @FontWeightConverter() FontWeight titleFontWeight,
      TextAlignment nameAlignment,
      TextAlignment titleAlignment,
      TextAlignment contactAlignment,
      bool showLogo,
      bool showQrCode,
      bool showSocialIcons,
      bool hasBackgroundPattern,
      double contentPadding,
      double elementSpacing,
      double borderRadius,
      String previewImageUrl,
      bool isPremium,
      int popularity,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$CardTemplateCopyWithImpl<$Res, $Val extends CardTemplate>
    implements $CardTemplateCopyWith<$Res> {
  _$CardTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? category = null,
    Object? layoutStyle = null,
    Object? primaryColor = null,
    Object? secondaryColor = null,
    Object? backgroundColor = null,
    Object? textColor = null,
    Object? accentColor = null,
    Object? backgroundGradient = freezed,
    Object? patternType = null,
    Object? patternColor = null,
    Object? patternOpacity = null,
    Object? fontFamily = null,
    Object? nameFontSize = null,
    Object? titleFontSize = null,
    Object? bodyFontSize = null,
    Object? nameFontWeight = null,
    Object? titleFontWeight = null,
    Object? nameAlignment = null,
    Object? titleAlignment = null,
    Object? contactAlignment = null,
    Object? showLogo = null,
    Object? showQrCode = null,
    Object? showSocialIcons = null,
    Object? hasBackgroundPattern = null,
    Object? contentPadding = null,
    Object? elementSpacing = null,
    Object? borderRadius = null,
    Object? previewImageUrl = null,
    Object? isPremium = null,
    Object? popularity = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as TemplateCategory,
      layoutStyle: null == layoutStyle
          ? _value.layoutStyle
          : layoutStyle // ignore: cast_nullable_to_non_nullable
              as LayoutStyle,
      primaryColor: null == primaryColor
          ? _value.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as Color,
      secondaryColor: null == secondaryColor
          ? _value.secondaryColor
          : secondaryColor // ignore: cast_nullable_to_non_nullable
              as Color,
      backgroundColor: null == backgroundColor
          ? _value.backgroundColor
          : backgroundColor // ignore: cast_nullable_to_non_nullable
              as Color,
      textColor: null == textColor
          ? _value.textColor
          : textColor // ignore: cast_nullable_to_non_nullable
              as Color,
      accentColor: null == accentColor
          ? _value.accentColor
          : accentColor // ignore: cast_nullable_to_non_nullable
              as Color,
      backgroundGradient: freezed == backgroundGradient
          ? _value.backgroundGradient
          : backgroundGradient // ignore: cast_nullable_to_non_nullable
              as List<Color>?,
      patternType: null == patternType
          ? _value.patternType
          : patternType // ignore: cast_nullable_to_non_nullable
              as CardPatternType,
      patternColor: null == patternColor
          ? _value.patternColor
          : patternColor // ignore: cast_nullable_to_non_nullable
              as Color,
      patternOpacity: null == patternOpacity
          ? _value.patternOpacity
          : patternOpacity // ignore: cast_nullable_to_non_nullable
              as double,
      fontFamily: null == fontFamily
          ? _value.fontFamily
          : fontFamily // ignore: cast_nullable_to_non_nullable
              as String,
      nameFontSize: null == nameFontSize
          ? _value.nameFontSize
          : nameFontSize // ignore: cast_nullable_to_non_nullable
              as double,
      titleFontSize: null == titleFontSize
          ? _value.titleFontSize
          : titleFontSize // ignore: cast_nullable_to_non_nullable
              as double,
      bodyFontSize: null == bodyFontSize
          ? _value.bodyFontSize
          : bodyFontSize // ignore: cast_nullable_to_non_nullable
              as double,
      nameFontWeight: null == nameFontWeight
          ? _value.nameFontWeight
          : nameFontWeight // ignore: cast_nullable_to_non_nullable
              as FontWeight,
      titleFontWeight: null == titleFontWeight
          ? _value.titleFontWeight
          : titleFontWeight // ignore: cast_nullable_to_non_nullable
              as FontWeight,
      nameAlignment: null == nameAlignment
          ? _value.nameAlignment
          : nameAlignment // ignore: cast_nullable_to_non_nullable
              as TextAlignment,
      titleAlignment: null == titleAlignment
          ? _value.titleAlignment
          : titleAlignment // ignore: cast_nullable_to_non_nullable
              as TextAlignment,
      contactAlignment: null == contactAlignment
          ? _value.contactAlignment
          : contactAlignment // ignore: cast_nullable_to_non_nullable
              as TextAlignment,
      showLogo: null == showLogo
          ? _value.showLogo
          : showLogo // ignore: cast_nullable_to_non_nullable
              as bool,
      showQrCode: null == showQrCode
          ? _value.showQrCode
          : showQrCode // ignore: cast_nullable_to_non_nullable
              as bool,
      showSocialIcons: null == showSocialIcons
          ? _value.showSocialIcons
          : showSocialIcons // ignore: cast_nullable_to_non_nullable
              as bool,
      hasBackgroundPattern: null == hasBackgroundPattern
          ? _value.hasBackgroundPattern
          : hasBackgroundPattern // ignore: cast_nullable_to_non_nullable
              as bool,
      contentPadding: null == contentPadding
          ? _value.contentPadding
          : contentPadding // ignore: cast_nullable_to_non_nullable
              as double,
      elementSpacing: null == elementSpacing
          ? _value.elementSpacing
          : elementSpacing // ignore: cast_nullable_to_non_nullable
              as double,
      borderRadius: null == borderRadius
          ? _value.borderRadius
          : borderRadius // ignore: cast_nullable_to_non_nullable
              as double,
      previewImageUrl: null == previewImageUrl
          ? _value.previewImageUrl
          : previewImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      popularity: null == popularity
          ? _value.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CardTemplateImplCopyWith<$Res>
    implements $CardTemplateCopyWith<$Res> {
  factory _$$CardTemplateImplCopyWith(
          _$CardTemplateImpl value, $Res Function(_$CardTemplateImpl) then) =
      __$$CardTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      TemplateCategory category,
      LayoutStyle layoutStyle,
      @ColorConverter() Color primaryColor,
      @ColorConverter() Color secondaryColor,
      @ColorConverter() Color backgroundColor,
      @ColorConverter() Color textColor,
      @ColorConverter() Color accentColor,
      @ColorListConverter() List<Color>? backgroundGradient,
      CardPatternType patternType,
      @ColorConverter() Color patternColor,
      double patternOpacity,
      String fontFamily,
      double nameFontSize,
      double titleFontSize,
      double bodyFontSize,
      @FontWeightConverter() FontWeight nameFontWeight,
      @FontWeightConverter() FontWeight titleFontWeight,
      TextAlignment nameAlignment,
      TextAlignment titleAlignment,
      TextAlignment contactAlignment,
      bool showLogo,
      bool showQrCode,
      bool showSocialIcons,
      bool hasBackgroundPattern,
      double contentPadding,
      double elementSpacing,
      double borderRadius,
      String previewImageUrl,
      bool isPremium,
      int popularity,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$CardTemplateImplCopyWithImpl<$Res>
    extends _$CardTemplateCopyWithImpl<$Res, _$CardTemplateImpl>
    implements _$$CardTemplateImplCopyWith<$Res> {
  __$$CardTemplateImplCopyWithImpl(
      _$CardTemplateImpl _value, $Res Function(_$CardTemplateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? category = null,
    Object? layoutStyle = null,
    Object? primaryColor = null,
    Object? secondaryColor = null,
    Object? backgroundColor = null,
    Object? textColor = null,
    Object? accentColor = null,
    Object? backgroundGradient = freezed,
    Object? patternType = null,
    Object? patternColor = null,
    Object? patternOpacity = null,
    Object? fontFamily = null,
    Object? nameFontSize = null,
    Object? titleFontSize = null,
    Object? bodyFontSize = null,
    Object? nameFontWeight = null,
    Object? titleFontWeight = null,
    Object? nameAlignment = null,
    Object? titleAlignment = null,
    Object? contactAlignment = null,
    Object? showLogo = null,
    Object? showQrCode = null,
    Object? showSocialIcons = null,
    Object? hasBackgroundPattern = null,
    Object? contentPadding = null,
    Object? elementSpacing = null,
    Object? borderRadius = null,
    Object? previewImageUrl = null,
    Object? isPremium = null,
    Object? popularity = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$CardTemplateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as TemplateCategory,
      layoutStyle: null == layoutStyle
          ? _value.layoutStyle
          : layoutStyle // ignore: cast_nullable_to_non_nullable
              as LayoutStyle,
      primaryColor: null == primaryColor
          ? _value.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as Color,
      secondaryColor: null == secondaryColor
          ? _value.secondaryColor
          : secondaryColor // ignore: cast_nullable_to_non_nullable
              as Color,
      backgroundColor: null == backgroundColor
          ? _value.backgroundColor
          : backgroundColor // ignore: cast_nullable_to_non_nullable
              as Color,
      textColor: null == textColor
          ? _value.textColor
          : textColor // ignore: cast_nullable_to_non_nullable
              as Color,
      accentColor: null == accentColor
          ? _value.accentColor
          : accentColor // ignore: cast_nullable_to_non_nullable
              as Color,
      backgroundGradient: freezed == backgroundGradient
          ? _value._backgroundGradient
          : backgroundGradient // ignore: cast_nullable_to_non_nullable
              as List<Color>?,
      patternType: null == patternType
          ? _value.patternType
          : patternType // ignore: cast_nullable_to_non_nullable
              as CardPatternType,
      patternColor: null == patternColor
          ? _value.patternColor
          : patternColor // ignore: cast_nullable_to_non_nullable
              as Color,
      patternOpacity: null == patternOpacity
          ? _value.patternOpacity
          : patternOpacity // ignore: cast_nullable_to_non_nullable
              as double,
      fontFamily: null == fontFamily
          ? _value.fontFamily
          : fontFamily // ignore: cast_nullable_to_non_nullable
              as String,
      nameFontSize: null == nameFontSize
          ? _value.nameFontSize
          : nameFontSize // ignore: cast_nullable_to_non_nullable
              as double,
      titleFontSize: null == titleFontSize
          ? _value.titleFontSize
          : titleFontSize // ignore: cast_nullable_to_non_nullable
              as double,
      bodyFontSize: null == bodyFontSize
          ? _value.bodyFontSize
          : bodyFontSize // ignore: cast_nullable_to_non_nullable
              as double,
      nameFontWeight: null == nameFontWeight
          ? _value.nameFontWeight
          : nameFontWeight // ignore: cast_nullable_to_non_nullable
              as FontWeight,
      titleFontWeight: null == titleFontWeight
          ? _value.titleFontWeight
          : titleFontWeight // ignore: cast_nullable_to_non_nullable
              as FontWeight,
      nameAlignment: null == nameAlignment
          ? _value.nameAlignment
          : nameAlignment // ignore: cast_nullable_to_non_nullable
              as TextAlignment,
      titleAlignment: null == titleAlignment
          ? _value.titleAlignment
          : titleAlignment // ignore: cast_nullable_to_non_nullable
              as TextAlignment,
      contactAlignment: null == contactAlignment
          ? _value.contactAlignment
          : contactAlignment // ignore: cast_nullable_to_non_nullable
              as TextAlignment,
      showLogo: null == showLogo
          ? _value.showLogo
          : showLogo // ignore: cast_nullable_to_non_nullable
              as bool,
      showQrCode: null == showQrCode
          ? _value.showQrCode
          : showQrCode // ignore: cast_nullable_to_non_nullable
              as bool,
      showSocialIcons: null == showSocialIcons
          ? _value.showSocialIcons
          : showSocialIcons // ignore: cast_nullable_to_non_nullable
              as bool,
      hasBackgroundPattern: null == hasBackgroundPattern
          ? _value.hasBackgroundPattern
          : hasBackgroundPattern // ignore: cast_nullable_to_non_nullable
              as bool,
      contentPadding: null == contentPadding
          ? _value.contentPadding
          : contentPadding // ignore: cast_nullable_to_non_nullable
              as double,
      elementSpacing: null == elementSpacing
          ? _value.elementSpacing
          : elementSpacing // ignore: cast_nullable_to_non_nullable
              as double,
      borderRadius: null == borderRadius
          ? _value.borderRadius
          : borderRadius // ignore: cast_nullable_to_non_nullable
              as double,
      previewImageUrl: null == previewImageUrl
          ? _value.previewImageUrl
          : previewImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      popularity: null == popularity
          ? _value.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CardTemplateImpl implements _CardTemplate {
  const _$CardTemplateImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.category,
      required this.layoutStyle,
      @ColorConverter() required this.primaryColor,
      @ColorConverter() required this.secondaryColor,
      @ColorConverter() required this.backgroundColor,
      @ColorConverter() required this.textColor,
      @ColorConverter() required this.accentColor,
      @ColorListConverter() final List<Color>? backgroundGradient,
      this.patternType = CardPatternType.none,
      @ColorConverter() this.patternColor = const Color(0x1A000000),
      this.patternOpacity = 0.05,
      required this.fontFamily,
      required this.nameFontSize,
      required this.titleFontSize,
      required this.bodyFontSize,
      @FontWeightConverter() required this.nameFontWeight,
      @FontWeightConverter() required this.titleFontWeight,
      required this.nameAlignment,
      required this.titleAlignment,
      required this.contactAlignment,
      required this.showLogo,
      required this.showQrCode,
      required this.showSocialIcons,
      this.hasBackgroundPattern = false,
      required this.contentPadding,
      required this.elementSpacing,
      required this.borderRadius,
      required this.previewImageUrl,
      required this.isPremium,
      required this.popularity,
      required this.createdAt,
      this.updatedAt})
      : _backgroundGradient = backgroundGradient;

  factory _$CardTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$CardTemplateImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final TemplateCategory category;
  @override
  final LayoutStyle layoutStyle;
// Colors
  @override
  @ColorConverter()
  final Color primaryColor;
  @override
  @ColorConverter()
  final Color secondaryColor;
  @override
  @ColorConverter()
  final Color backgroundColor;
  @override
  @ColorConverter()
  final Color textColor;
  @override
  @ColorConverter()
  final Color accentColor;
  final List<Color>? _backgroundGradient;
  @override
  @ColorListConverter()
  List<Color>? get backgroundGradient {
    final value = _backgroundGradient;
    if (value == null) return null;
    if (_backgroundGradient is EqualUnmodifiableListView)
      return _backgroundGradient;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Patterns
  @override
  @JsonKey()
  final CardPatternType patternType;
  @override
  @JsonKey()
  @ColorConverter()
  final Color patternColor;
  @override
  @JsonKey()
  final double patternOpacity;
// Typography
  @override
  final String fontFamily;
  @override
  final double nameFontSize;
  @override
  final double titleFontSize;
  @override
  final double bodyFontSize;
  @override
  @FontWeightConverter()
  final FontWeight nameFontWeight;
  @override
  @FontWeightConverter()
  final FontWeight titleFontWeight;
// Layout properties
  @override
  final TextAlignment nameAlignment;
  @override
  final TextAlignment titleAlignment;
  @override
  final TextAlignment contactAlignment;
  @override
  final bool showLogo;
  @override
  final bool showQrCode;
  @override
  final bool showSocialIcons;
  @override
  @JsonKey()
  final bool hasBackgroundPattern;
// Deprecated in favor of patternType
// Spacing
  @override
  final double contentPadding;
  @override
  final double elementSpacing;
  @override
  final double borderRadius;
// Preview
  @override
  final String previewImageUrl;
  @override
  final bool isPremium;
  @override
  final int popularity;
// For sorting
// Timestamps
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CardTemplate(id: $id, name: $name, description: $description, category: $category, layoutStyle: $layoutStyle, primaryColor: $primaryColor, secondaryColor: $secondaryColor, backgroundColor: $backgroundColor, textColor: $textColor, accentColor: $accentColor, backgroundGradient: $backgroundGradient, patternType: $patternType, patternColor: $patternColor, patternOpacity: $patternOpacity, fontFamily: $fontFamily, nameFontSize: $nameFontSize, titleFontSize: $titleFontSize, bodyFontSize: $bodyFontSize, nameFontWeight: $nameFontWeight, titleFontWeight: $titleFontWeight, nameAlignment: $nameAlignment, titleAlignment: $titleAlignment, contactAlignment: $contactAlignment, showLogo: $showLogo, showQrCode: $showQrCode, showSocialIcons: $showSocialIcons, hasBackgroundPattern: $hasBackgroundPattern, contentPadding: $contentPadding, elementSpacing: $elementSpacing, borderRadius: $borderRadius, previewImageUrl: $previewImageUrl, isPremium: $isPremium, popularity: $popularity, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CardTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.layoutStyle, layoutStyle) ||
                other.layoutStyle == layoutStyle) &&
            (identical(other.primaryColor, primaryColor) ||
                other.primaryColor == primaryColor) &&
            (identical(other.secondaryColor, secondaryColor) ||
                other.secondaryColor == secondaryColor) &&
            (identical(other.backgroundColor, backgroundColor) ||
                other.backgroundColor == backgroundColor) &&
            (identical(other.textColor, textColor) ||
                other.textColor == textColor) &&
            (identical(other.accentColor, accentColor) ||
                other.accentColor == accentColor) &&
            const DeepCollectionEquality()
                .equals(other._backgroundGradient, _backgroundGradient) &&
            (identical(other.patternType, patternType) ||
                other.patternType == patternType) &&
            (identical(other.patternColor, patternColor) ||
                other.patternColor == patternColor) &&
            (identical(other.patternOpacity, patternOpacity) ||
                other.patternOpacity == patternOpacity) &&
            (identical(other.fontFamily, fontFamily) ||
                other.fontFamily == fontFamily) &&
            (identical(other.nameFontSize, nameFontSize) ||
                other.nameFontSize == nameFontSize) &&
            (identical(other.titleFontSize, titleFontSize) ||
                other.titleFontSize == titleFontSize) &&
            (identical(other.bodyFontSize, bodyFontSize) ||
                other.bodyFontSize == bodyFontSize) &&
            (identical(other.nameFontWeight, nameFontWeight) ||
                other.nameFontWeight == nameFontWeight) &&
            (identical(other.titleFontWeight, titleFontWeight) ||
                other.titleFontWeight == titleFontWeight) &&
            (identical(other.nameAlignment, nameAlignment) ||
                other.nameAlignment == nameAlignment) &&
            (identical(other.titleAlignment, titleAlignment) ||
                other.titleAlignment == titleAlignment) &&
            (identical(other.contactAlignment, contactAlignment) ||
                other.contactAlignment == contactAlignment) &&
            (identical(other.showLogo, showLogo) ||
                other.showLogo == showLogo) &&
            (identical(other.showQrCode, showQrCode) ||
                other.showQrCode == showQrCode) &&
            (identical(other.showSocialIcons, showSocialIcons) ||
                other.showSocialIcons == showSocialIcons) &&
            (identical(other.hasBackgroundPattern, hasBackgroundPattern) ||
                other.hasBackgroundPattern == hasBackgroundPattern) &&
            (identical(other.contentPadding, contentPadding) ||
                other.contentPadding == contentPadding) &&
            (identical(other.elementSpacing, elementSpacing) ||
                other.elementSpacing == elementSpacing) &&
            (identical(other.borderRadius, borderRadius) ||
                other.borderRadius == borderRadius) &&
            (identical(other.previewImageUrl, previewImageUrl) ||
                other.previewImageUrl == previewImageUrl) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.popularity, popularity) ||
                other.popularity == popularity) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        description,
        category,
        layoutStyle,
        primaryColor,
        secondaryColor,
        backgroundColor,
        textColor,
        accentColor,
        const DeepCollectionEquality().hash(_backgroundGradient),
        patternType,
        patternColor,
        patternOpacity,
        fontFamily,
        nameFontSize,
        titleFontSize,
        bodyFontSize,
        nameFontWeight,
        titleFontWeight,
        nameAlignment,
        titleAlignment,
        contactAlignment,
        showLogo,
        showQrCode,
        showSocialIcons,
        hasBackgroundPattern,
        contentPadding,
        elementSpacing,
        borderRadius,
        previewImageUrl,
        isPremium,
        popularity,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CardTemplateImplCopyWith<_$CardTemplateImpl> get copyWith =>
      __$$CardTemplateImplCopyWithImpl<_$CardTemplateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CardTemplateImplToJson(
      this,
    );
  }
}

abstract class _CardTemplate implements CardTemplate {
  const factory _CardTemplate(
      {required final String id,
      required final String name,
      required final String description,
      required final TemplateCategory category,
      required final LayoutStyle layoutStyle,
      @ColorConverter() required final Color primaryColor,
      @ColorConverter() required final Color secondaryColor,
      @ColorConverter() required final Color backgroundColor,
      @ColorConverter() required final Color textColor,
      @ColorConverter() required final Color accentColor,
      @ColorListConverter() final List<Color>? backgroundGradient,
      final CardPatternType patternType,
      @ColorConverter() final Color patternColor,
      final double patternOpacity,
      required final String fontFamily,
      required final double nameFontSize,
      required final double titleFontSize,
      required final double bodyFontSize,
      @FontWeightConverter() required final FontWeight nameFontWeight,
      @FontWeightConverter() required final FontWeight titleFontWeight,
      required final TextAlignment nameAlignment,
      required final TextAlignment titleAlignment,
      required final TextAlignment contactAlignment,
      required final bool showLogo,
      required final bool showQrCode,
      required final bool showSocialIcons,
      final bool hasBackgroundPattern,
      required final double contentPadding,
      required final double elementSpacing,
      required final double borderRadius,
      required final String previewImageUrl,
      required final bool isPremium,
      required final int popularity,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$CardTemplateImpl;

  factory _CardTemplate.fromJson(Map<String, dynamic> json) =
      _$CardTemplateImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  TemplateCategory get category;
  @override
  LayoutStyle get layoutStyle;
  @override // Colors
  @ColorConverter()
  Color get primaryColor;
  @override
  @ColorConverter()
  Color get secondaryColor;
  @override
  @ColorConverter()
  Color get backgroundColor;
  @override
  @ColorConverter()
  Color get textColor;
  @override
  @ColorConverter()
  Color get accentColor;
  @override
  @ColorListConverter()
  List<Color>? get backgroundGradient;
  @override // Patterns
  CardPatternType get patternType;
  @override
  @ColorConverter()
  Color get patternColor;
  @override
  double get patternOpacity;
  @override // Typography
  String get fontFamily;
  @override
  double get nameFontSize;
  @override
  double get titleFontSize;
  @override
  double get bodyFontSize;
  @override
  @FontWeightConverter()
  FontWeight get nameFontWeight;
  @override
  @FontWeightConverter()
  FontWeight get titleFontWeight;
  @override // Layout properties
  TextAlignment get nameAlignment;
  @override
  TextAlignment get titleAlignment;
  @override
  TextAlignment get contactAlignment;
  @override
  bool get showLogo;
  @override
  bool get showQrCode;
  @override
  bool get showSocialIcons;
  @override
  bool get hasBackgroundPattern;
  @override // Deprecated in favor of patternType
// Spacing
  double get contentPadding;
  @override
  double get elementSpacing;
  @override
  double get borderRadius;
  @override // Preview
  String get previewImageUrl;
  @override
  bool get isPremium;
  @override
  int get popularity;
  @override // For sorting
// Timestamps
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$CardTemplateImplCopyWith<_$CardTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
