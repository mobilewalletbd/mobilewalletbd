// Card Design Version Entity
// Represents a snapshot of a card design at a specific point in time

import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_design_version.freezed.dart';
part 'card_design_version.g.dart';

/// Entity representing a version snapshot of a card design
@freezed
class CardDesignVersion with _$CardDesignVersion {
  const factory CardDesignVersion({
    required String id,
    required String cardId,
    required String userId,
    required Map<String, dynamic> snapshotData,
    required DateTime createdAt,
    String? commitMessage, // Optional description of changes
  }) = _CardDesignVersion;

  factory CardDesignVersion.fromJson(Map<String, dynamic> json) =>
      _$CardDesignVersionFromJson(json);
}
