// Scan Provider
// Manages state for the business card scanning flow

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:mobile_wallet/core/services/cloudinary_service.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile_wallet/features/contacts/data/repositories/contact_repository_impl.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:mobile_wallet/features/scanning/data/services/duplicate_detection_service.dart';
import 'package:mobile_wallet/features/scanning/data/services/enhanced_ocr_service.dart';
import 'package:mobile_wallet/features/scanning/data/services/image_preprocessor.dart';
import 'package:mobile_wallet/features/scanning/data/services/ocr_service.dart';
import 'package:mobile_wallet/features/scanning/domain/entities/duplicate_result.dart';
import 'package:mobile_wallet/features/scanning/domain/entities/scanned_card.dart';
import 'package:mobile_wallet/features/scanning/domain/services/ocr_field_mapper.dart';

part 'scan_provider.g.dart';

/// State for the scanning flow
class ScanState {
  /// Whether camera is initializing
  final bool isInitializing;

  /// Whether currently processing OCR
  final bool isProcessing;

  /// Whether currently saving contact
  final bool isSaving;

  /// Current card side being scanned
  final CardSide currentSide;

  /// Path to captured front image
  final String? frontImagePath;

  /// Path to captured back image
  final String? backImagePath;

  /// Scanned card with extracted data
  final ScannedCard? scannedCard;

  /// Error message if any
  final String? error;

  /// Flash mode
  final FlashMode flashMode;

  /// Whether auto-save on high-confidence scans is enabled
  final bool autoSaveEnabled;

  /// Whether the last scan was auto-saved (skip preview)
  final bool wasAutoSaved;

  /// Duplicate detection results (populated before save)
  final List<DuplicateResult> duplicateResults;

  /// Whether to recommend flash (low light)
  final bool recommendFlash;

  /// Whether batch scanning mode is active
  final bool isBatchMode;

  const ScanState({
    this.isInitializing = true,
    this.isProcessing = false,
    this.isSaving = false,
    this.currentSide = CardSide.front,
    this.frontImagePath,
    this.backImagePath,
    this.scannedCard,
    this.error,
    this.flashMode = FlashMode.auto,
    this.autoSaveEnabled = true,
    this.wasAutoSaved = false,
    this.duplicateResults = const [],
    this.recommendFlash = false,
    this.isBatchMode = false,
  });

  ScanState copyWith({
    bool? isInitializing,
    bool? isProcessing,
    bool? isSaving,
    CardSide? currentSide,
    String? frontImagePath,
    String? backImagePath,
    ScannedCard? scannedCard,
    String? error,
    FlashMode? flashMode,
    bool? autoSaveEnabled,
    bool? wasAutoSaved,
    List<DuplicateResult>? duplicateResults,
    bool? recommendFlash,
    bool? isBatchMode,
  }) {
    return ScanState(
      isInitializing: isInitializing ?? this.isInitializing,
      isProcessing: isProcessing ?? this.isProcessing,
      isSaving: isSaving ?? this.isSaving,
      currentSide: currentSide ?? this.currentSide,
      frontImagePath: frontImagePath ?? this.frontImagePath,
      backImagePath: backImagePath ?? this.backImagePath,
      scannedCard: scannedCard ?? this.scannedCard,
      error: error,
      flashMode: flashMode ?? this.flashMode,
      autoSaveEnabled: autoSaveEnabled ?? this.autoSaveEnabled,
      wasAutoSaved: wasAutoSaved ?? this.wasAutoSaved,
      duplicateResults: duplicateResults ?? this.duplicateResults,
      recommendFlash: recommendFlash ?? this.recommendFlash,
      isBatchMode: isBatchMode ?? this.isBatchMode,
    );
  }

  /// Whether front has been captured
  bool get hasFront => frontImagePath != null;

  /// Whether back has been captured
  bool get hasBack => backImagePath != null;

  /// Whether ready to process
  bool get canProcess => hasFront;

  /// Whether there are potential duplicates
  bool get hasDuplicates => duplicateResults.isNotEmpty;
}

/// Provider for managing scan state
@riverpod
class ScanNotifier extends _$ScanNotifier {
  final _uuid = const Uuid();

  @override
  ScanState build() {
    return const ScanState();
  }

  /// Mark camera as initialized
  void cameraReady() {
    state = state.copyWith(isInitializing: false);
  }

  /// Toggle batch scanning mode
  void toggleBatchMode() {
    state = state.copyWith(isBatchMode: !state.isBatchMode);
    print('🔄 [SCAN] Batch mode: ${state.isBatchMode ? "ON" : "OFF"}');
  }

  /// Toggle flash mode
  void toggleFlash() {
    final nextMode = switch (state.flashMode) {
      FlashMode.auto => FlashMode.always,
      FlashMode.always => FlashMode.off,
      FlashMode.off => FlashMode.auto,
      _ => FlashMode.auto,
    };
    state = state.copyWith(flashMode: nextMode);
    print('💡 [SCAN] Flash mode set to: $nextMode');
  }

  /// Set specific flash mode
  void setFlashMode(FlashMode mode) {
    state = state.copyWith(flashMode: mode, recommendFlash: false);
    print('💡 [SCAN] Flash mode explicitly set to: $mode');
  }

  /// Capture card image from camera
  Future<void> captureCard(CameraController controller) async {
    if (state.isProcessing) return;

    try {
      print(
        '📸 [SCAN] Capturing ${state.currentSide == CardSide.front ? 'FRONT' : 'BACK'} image...',
      );

      // Take picture
      final image = await controller.takePicture();
      print('📸 [SCAN] Picture taken: ${image.path}');

      // Get temp directory
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final side = state.currentSide == CardSide.front ? 'front' : 'back';
      final newPath = '${tempDir.path}/card_${side}_$timestamp.jpg';

      // Move file to temp directory
      final file = File(image.path);
      await file.copy(newPath);
      print('📁 [SCAN] File saved to: $newPath');

      if (state.currentSide == CardSide.front) {
        state = state.copyWith(
          frontImagePath: newPath,
          currentSide: CardSide.back,
        );
        print('✅ [SCAN] Front image captured. Path: ${state.frontImagePath}');
        print('👉 [SCAN] Next side: ${state.currentSide}');
      } else {
        state = state.copyWith(backImagePath: newPath);
        print('✅ [SCAN] Back image captured. Path: ${state.backImagePath}');
      }
    } catch (e) {
      print('❌ [SCAN] Capture failed: $e');
      state = state.copyWith(error: 'Failed to capture image: $e');
    }
  }

  /// Process image picked from gallery
  Future<void> processGalleryImage(String path) async {
    if (state.isProcessing) return;

    try {
      // Get temp directory
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final side = state.currentSide == CardSide.front ? 'front' : 'back';
      final newPath = '${tempDir.path}/card_gallery_${side}_$timestamp.jpg';

      // Copy file to temp directory
      final file = File(path);
      await file.copy(newPath);

      if (state.currentSide == CardSide.front) {
        state = state.copyWith(
          frontImagePath: newPath,
          currentSide: CardSide.back,
        );
      } else {
        state = state.copyWith(backImagePath: newPath);
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to process gallery image: $e');
    }
  }

  /// Skip back side scanning
  void skipBack() {
    state = state.copyWith(currentSide: CardSide.back);
  }

  /// Process captured images with OCR
  ///
  /// Uses [EnhancedOcrService] for confidence scoring, QR/barcode detection,
  /// and auto-save capability. Falls back to basic [OcrService] on failure.
  Future<void> processImages() async {
    if (!state.canProcess || state.isProcessing) {
      print(
        '⚠️ [OCR] Cannot process: canProcess=${state.canProcess}, isProcessing=${state.isProcessing}',
      );
      return;
    }

    print('🔍 [OCR] Starting OCR processing...');
    print('📁 [OCR] Current State Front path: ${state.frontImagePath}');
    print('📁 [OCR] Current State Back path: ${state.backImagePath}');

    state = state.copyWith(
      isProcessing: true,
      error: null,
      wasAutoSaved: false,
      duplicateResults: [],
    );

    try {
      final enhancedOcr = ref.read(enhancedOcrServiceProvider);
      final fieldMapper = ref.read(ocrFieldMapperProvider);
      final basicOcr = ref.read(ocrServiceProvider);
      final imagePreprocessor = ref.read(imagePreprocessorProvider);

      String? frontOcrText;
      String? backOcrText;
      final allFields = <ExtractedField>[];
      bool shouldAutoSave = false;

      // Process front image
      if (state.frontImagePath != null) {
        print('🔍 [OCR] Processing front image...');
        final frontFile = File(state.frontImagePath!);

        if (!frontFile.existsSync()) {
          throw Exception(
            'Front image file not found: ${state.frontImagePath}',
          );
        }

        // Check image quality
        print('📊 [Quality] Checking image quality...');
        final qualityScore = await imagePreprocessor.getQualityScore(frontFile);
        print('📊 [Quality] Score: $qualityScore/100');

        if (qualityScore < 50) {
          final isBlurry = await imagePreprocessor.isImageBlurry(frontFile);
          final lightLevel = await imagePreprocessor.estimateLightLevel(
            frontFile,
          );

          print(
            '⚠️ [Quality] Low quality detected - Blur: $isBlurry, Light: $lightLevel',
          );

          if (lightLevel < 50) {
            state = state.copyWith(recommendFlash: true);
          }
        }

        // Check for Inverted Colors (Section 33.2)
        File finalFrontFile = frontFile;
        bool isInverted = await imagePreprocessor.isInvertedColor(frontFile);
        if (isInverted) {
          print('🌓 [OCR] Dark card detected, attempting color inversion...');
          finalFrontFile = await imagePreprocessor.invertColors(frontFile);
        }

        // Try enhanced OCR first
        try {
          print('🔍 [OCR] Attempting enhanced OCR on front...');
          final enhancedResult = await enhancedOcr.extractTextEnhanced(
            finalFrontFile,
          );
          if (enhancedResult.success) {
            frontOcrText = enhancedResult.rawText;
            shouldAutoSave = enhancedResult.shouldAutoSave;
            print(
              '📝 [OCR] Extracted text length: ${frontOcrText.length ?? 0}',
            );

            // Analytics: Success (Section 22)
            print(
              '📊 [Analytics] Front Scan Success: Quality: $qualityScore, Length: ${frontOcrText.length}',
            );

            // Use basic OCR result for field mapping (enhanced gives raw text)
            final basicResult = await basicOcr.extractText(finalFrontFile);
            if (basicResult.success) {
              final fields = fieldMapper.mapOcrToFields(basicResult);
              allFields.addAll(fields);
              print('📋 [OCR] Mapped ${fields.length} fields from front');
            }
          } else {
            print('⚠️ [OCR] Enhanced OCR returned unsuccessful');
          }
        } catch (enhancedError) {
          print(
            '⚠️ [OCR] Enhanced OCR failed: $enhancedError. Falling back to basic OCR...',
          );
          // Fallback to basic OCR
          final frontResult = await basicOcr.extractText(finalFrontFile);
          if (frontResult.success) {
            frontOcrText = frontResult.rawText;
            final fields = fieldMapper.mapOcrToFields(frontResult);
            allFields.addAll(fields);
            print(
              '✅ [OCR] Basic OCR success. Extracted ${fields.length} fields from front',
            );
          } else {
            print('❌ [OCR] Basic OCR also failed for front image');
            // Analytics: Failure (Section 22)
            print(
              '📊 [Analytics] Front Scan Failure: Enhanced and Basic both failed',
            );
          }
        }
      }

      // Process back image
      if (state.backImagePath != null) {
        print('🔍 [OCR] Processing back image...');
        final backFile = File(state.backImagePath!);

        if (!backFile.existsSync()) {
          print('⚠️ [OCR] Back image file not found: ${state.backImagePath}');
        } else {
          final backResult = await basicOcr.extractText(backFile);
          if (backResult.success) {
            backOcrText = backResult.rawText;
            // Add fields from back that don't duplicate front
            final backFields = fieldMapper.mapOcrToFields(backResult);
            int addedCount = 0;
            for (final field in backFields) {
              if (!allFields.any(
                (f) =>
                    f.fieldType == field.fieldType &&
                    f.value.toLowerCase() == field.value.toLowerCase(),
              )) {
                allFields.add(field);
                addedCount++;
              }
            }
            print(
              '✅ [OCR] Extracted ${backFields.length} fields from back ($addedCount unique)',
            );
          } else {
            print('❌ [OCR] Back image OCR failed');
          }
        }
      }

      // Calculate overall confidence
      double overallConfidence = 0.0;
      if (allFields.isNotEmpty) {
        overallConfidence =
            allFields.map((f) => f.confidence).reduce((a, b) => a + b) /
            allFields.length;
      }

      print('📊 [OCR] Total fields extracted: ${allFields.length}');
      print(
        '📊 [OCR] Overall confidence: ${(overallConfidence * 100).toStringAsFixed(1)}%',
      );

      // Default language if enhanced OCR wasn't used
      String detectedLanguage = 'Unknown';

      // Extract from the enhanced result if available
      try {
        final enhancedResult = await enhancedOcr.extractTextEnhanced(
          File(state.frontImagePath ?? state.backImagePath ?? ''),
        );
        detectedLanguage = enhancedResult.detectedLanguage;
      } catch (e) {
        // ignore
      }

      final scannedCard = ScannedCard(
        frontImagePath: state.frontImagePath,
        backImagePath: state.backImagePath,
        frontOcrText: frontOcrText,
        backOcrText: backOcrText,
        extractedFields: allFields,
        overallConfidence: overallConfidence,
        detectedLanguage: detectedLanguage,
        scannedAt: DateTime.now(),
      );

      state = state.copyWith(isProcessing: false, scannedCard: scannedCard);
      print('✅ [OCR] Processing complete. ScannedCard created.');

      // Auto-save if confidence is high enough and feature is enabled
      if (shouldAutoSave && state.autoSaveEnabled && allFields.isNotEmpty) {
        print('💾 [OCR] Auto-save triggered (high confidence)');
        final saved = await saveAsContact();
        if (saved != null) {
          state = state.copyWith(wasAutoSaved: true);
          print('✅ [OCR] Auto-save successful');
        } else {
          print('❌ [OCR] Auto-save failed');
        }
      }
    } catch (e, stackTrace) {
      print('❌ [OCR] Processing failed with exception: $e');
      print('Stack trace: $stackTrace');
      state = state.copyWith(
        isProcessing: false,
        error: 'OCR processing failed: $e',
      );
    }
  }

  /// Update an extracted field
  void updateField(String fieldType, String newValue) {
    if (state.scannedCard == null) return;

    final updatedFields = state.scannedCard!.extractedFields.map((field) {
      if (field.fieldType == fieldType) {
        return field.copyWith(value: newValue, isEdited: true, confidence: 1.0);
      }
      return field;
    }).toList();

    state = state.copyWith(
      scannedCard: state.scannedCard!.copyWith(extractedFields: updatedFields),
    );
  }

  /// Add a new field manually
  void addField(String fieldType, String value) {
    if (state.scannedCard == null) return;

    final newField = ExtractedField(
      fieldType: fieldType,
      value: value,
      confidence: 1.0,
      isEdited: true,
    );

    final updatedFields = [...state.scannedCard!.extractedFields, newField];

    state = state.copyWith(
      scannedCard: state.scannedCard!.copyWith(extractedFields: updatedFields),
    );
  }

  /// Remove a field
  void removeField(String fieldType, String value) {
    if (state.scannedCard == null) return;

    final updatedFields = state.scannedCard!.extractedFields
        .where((f) => !(f.fieldType == fieldType && f.value == value))
        .toList();

    state = state.copyWith(
      scannedCard: state.scannedCard!.copyWith(extractedFields: updatedFields),
    );
  }

  /// Save scanned card as contact with Cloudinary image upload
  Future<Contact?> saveAsContact() async {
    if (state.scannedCard == null) {
      print('❌ [SAVE] No scanned card to save');
      return null;
    }

    print('💾 [SAVE] Starting save process...');
    state = state.copyWith(isSaving: true, error: null);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        print('❌ [SAVE] User not authenticated');
        state = state.copyWith(
          isSaving: false,
          error: 'User not authenticated. Please sign in and try again.',
        );
        return null;
      }
      print('👤 [SAVE] User authenticated: ${user.id}');

      final scanned = state.scannedCard!;
      final now = DateTime.now();
      print('📋 [SAVE] Contact name: ${scanned.name ?? "Unknown"}');
      print('📋 [SAVE] Extracted fields: ${scanned.extractedFields.length}');

      // Upload images to Cloudinary
      String? frontImageUrl;
      String? backImageUrl;
      String? frontThumbnailUrl;
      String? backThumbnailUrl;

      if (state.frontImagePath != null) {
        print('📸 [SAVE] Uploading front image to Cloudinary...');
        final cloudinaryService = ref.read(cloudinaryServiceProvider);
        final uploadResult = await cloudinaryService.uploadImage(
          filePath: state.frontImagePath!,
          folder: 'card-images',
          generateThumbnail: true,
        );

        if (uploadResult.success) {
          frontImageUrl = uploadResult.secureUrl;
          frontThumbnailUrl = uploadResult.thumbnailUrl;
          print('✅ [SAVE] Front image uploaded: $frontImageUrl');
        } else {
          // Log error but continue - we can save without images
          print(
            '⚠️ [SAVE] Front image upload failed: ${uploadResult.errorMessage}',
          );
        }
      }

      if (state.backImagePath != null) {
        print('📸 [SAVE] Uploading back image to Cloudinary...');
        final cloudinaryService = ref.read(cloudinaryServiceProvider);
        final uploadResult = await cloudinaryService.uploadImage(
          filePath: state.backImagePath!,
          folder: 'card-images',
          generateThumbnail: true,
        );

        if (uploadResult.success) {
          backImageUrl = uploadResult.secureUrl;
          backThumbnailUrl = uploadResult.thumbnailUrl;
          print('✅ [SAVE] Back image uploaded: $backImageUrl');
        } else {
          print(
            '⚠️ [SAVE] Back image upload failed: ${uploadResult.errorMessage}',
          );
        }
      }

      // Build contact from scanned data
      print('🔨 [SAVE] Building Contact entity...');
      final contact = Contact(
        id: _uuid.v4(),
        ownerId: user.id,
        fullName: scanned.name ?? 'Unknown',
        jobTitle: scanned.jobTitle,
        companyName: scanned.company,
        phoneNumbers: scanned.phoneNumbers,
        emails: scanned.emails,
        addresses: scanned.addresses,
        websiteUrls: scanned.websites,
        source: ContactSources.scan,
        category: ContactCategories.business,
        frontImageUrl: frontImageUrl,
        backImageUrl: backImageUrl,
        frontImageOcrText: scanned.frontOcrText,
        backImageOcrText: scanned.backOcrText,
        ocrFields: {
          'extractedFields': scanned.extractedFields
              .map(
                (f) => {
                  'type': f.fieldType,
                  'value': f.value,
                  'confidence': f.confidence,
                },
              )
              .toList(),
          'overallConfidence': scanned.overallConfidence,
          'frontThumbnailUrl': frontThumbnailUrl,
          'backThumbnailUrl': backThumbnailUrl,
        },
        createdAt: now,
        updatedAt: now,
      );
      print('📦 [SAVE] Contact entity created: ${contact.id}');

      // Save to repository
      print('💾 [SAVE] Saving to repository (Firestore + Isar)...');
      final repository = ref.read(contactRepositoryProvider);
      final savedContact = await repository.createContact(contact);
      print('✅ [SAVE] Contact saved successfully: ${savedContact.id}');

      state = state.copyWith(isSaving: false);
      return savedContact;
    } catch (e, stackTrace) {
      print('❌ [SAVE] Save failed with exception: $e');
      print('Stack trace: $stackTrace');
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to save contact: $e',
      );
      return null;
    }
  }

  /// Toggle auto-save preference
  void toggleAutoSave() {
    state = state.copyWith(autoSaveEnabled: !state.autoSaveEnabled);
  }

  /// Run advanced duplicate detection against existing contacts.
  /// Updates state.duplicateResults and returns the list.
  Future<List<DuplicateResult>> runDuplicateCheck(Contact newContact) async {
    try {
      final repository = ref.read(contactRepositoryProvider);
      final existingContacts = await repository.getContacts(newContact.ownerId);
      final detector = ref.read(duplicateDetectionServiceProvider);

      final results = detector.findDuplicates(newContact, existingContacts);
      state = state.copyWith(duplicateResults: results);
      return results;
    } catch (e) {
      // Duplicate check is non-critical — return empty
      return [];
    }
  }

  /// Merge fields from [newContact] into [existingContact] based on
  /// the user's per-field selections from the merge UI.
  /// [fieldSelections] maps field labels to 'new' or 'existing'.
  Future<Contact?> mergeContacts(
    Contact existingContact,
    Contact newContact,
    Map<String, String> fieldSelections,
  ) async {
    try {
      state = state.copyWith(isSaving: true, error: null);

      String pick(String label, String newVal, String existingVal) =>
          fieldSelections[label] == 'new' ? newVal : existingVal;

      List<String> pickList(
        String label,
        List<String> newList,
        List<String> existingList,
      ) => fieldSelections[label] == 'new' ? newList : existingList;

      final merged = existingContact.copyWith(
        fullName: pick('Name', newContact.fullName, existingContact.fullName),
        jobTitle:
            pick(
              'Job Title',
              newContact.jobTitle ?? '',
              existingContact.jobTitle ?? '',
            ).isEmpty
            ? null
            : pick(
                'Job Title',
                newContact.jobTitle ?? '',
                existingContact.jobTitle ?? '',
              ),
        companyName:
            pick(
              'Company',
              newContact.companyName ?? '',
              existingContact.companyName ?? '',
            ).isEmpty
            ? null
            : pick(
                'Company',
                newContact.companyName ?? '',
                existingContact.companyName ?? '',
              ),
        phoneNumbers: pickList(
          'Phone',
          newContact.phoneNumbers,
          existingContact.phoneNumbers,
        ),
        emails: pickList('Email', newContact.emails, existingContact.emails),
        addresses: pickList(
          'Address',
          newContact.addresses,
          existingContact.addresses,
        ),
        websiteUrls: pickList(
          'Website',
          newContact.websiteUrls,
          existingContact.websiteUrls,
        ),
        frontImageUrl:
            newContact.frontImageUrl ?? existingContact.frontImageUrl,
        backImageUrl: newContact.backImageUrl ?? existingContact.backImageUrl,
        updatedAt: DateTime.now(),
      );

      final repository = ref.read(contactRepositoryProvider);
      final saved = await repository.updateContact(merged);

      state = state.copyWith(isSaving: false);
      return saved;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to merge contacts: $e',
      );
      return null;
    }
  }

  /// Reset scan state for new scan
  void reset() {
    // Clean up temporary files
    if (state.frontImagePath != null) {
      try {
        File(state.frontImagePath!).deleteSync();
      } catch (_) {}
    }
    if (state.backImagePath != null) {
      try {
        File(state.backImagePath!).deleteSync();
      } catch (_) {}
    }

    state = const ScanState();
  }

  /// Run advanced duplicate detection on the current scanned card.
  /// Returns a list of [DuplicateResult] (empty if none found).
  Future<List<DuplicateResult>> checkDuplicateBeforeSave() async {
    if (state.scannedCard == null) return [];

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return [];

      final scanned = state.scannedCard!;

      // Build temporary contact for duplicate checking
      final tempContact = Contact(
        id: '',
        ownerId: user.id,
        fullName: scanned.name ?? 'Unknown',
        jobTitle: scanned.jobTitle,
        companyName: scanned.company,
        phoneNumbers: scanned.phoneNumbers,
        emails: scanned.emails,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return await runDuplicateCheck(tempContact);
    } catch (e) {
      return [];
    }
  }
}

/// Provider for available cameras
@riverpod
Future<List<CameraDescription>> cameraList(CameraListRef ref) async {
  return await availableCameras();
}
