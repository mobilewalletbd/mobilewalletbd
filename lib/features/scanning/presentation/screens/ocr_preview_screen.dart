// OCR Preview Screen
// Shows extracted fields from business card scan with editing capability

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:mobile_wallet/features/scanning/domain/entities/scanned_card.dart';
import 'package:mobile_wallet/features/scanning/presentation/providers/scan_provider.dart';
import 'package:mobile_wallet/features/scanning/data/services/enhanced_ocr_service.dart';
import 'package:mobile_wallet/features/scanning/presentation/widgets/alignment_guide.dart';
import 'package:mobile_wallet/features/scanning/presentation/widgets/merge_suggestion_sheet.dart';

/// Screen for previewing and editing OCR extracted fields
class OcrPreviewScreen extends ConsumerStatefulWidget {
  const OcrPreviewScreen({super.key});

  @override
  ConsumerState<OcrPreviewScreen> createState() => _OcrPreviewScreenState();
}

class _OcrPreviewScreenState extends ConsumerState<OcrPreviewScreen> {
  final Map<String, TextEditingController> _controllers = {};
  bool _isEditing = false;

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initControllers(List<ExtractedField> fields) {
    for (final field in fields) {
      final key = '${field.fieldType}_${field.value}';
      if (!_controllers.containsKey(key)) {
        _controllers[key] = TextEditingController(text: field.value);
      }
    }
  }

  Future<void> _saveContact() async {
    final notifier = ref.read(scanNotifierProvider.notifier);

    print('💾 [PREVIEW] Save contact button pressed');

    // Run duplicate check first
    final duplicates = await notifier.checkDuplicateBeforeSave();

    if (duplicates.isNotEmpty && mounted) {
      final bestMatch = duplicates.first;
      // Build a temporary Contact from the scanned data for comparison
      final scanned = ref.read(scanNotifierProvider).scannedCard!;
      final tempNewContact = Contact(
        id: '',
        ownerId: '',
        fullName: scanned.name ?? 'Unknown',
        jobTitle: scanned.jobTitle,
        companyName: scanned.company,
        phoneNumbers: scanned.phoneNumbers,
        emails: scanned.emails,
        addresses: scanned.addresses,
        websiteUrls: scanned.websites,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final decision = await MergeSuggestionSheet.show(
        context,
        duplicateResult: bestMatch,
        newContact: tempNewContact,
      );

      if (!mounted) return;

      if (decision == null || decision.action == MergeAction.skip) {
        return; // User cancelled
      }

      if (decision.action == MergeAction.merge) {
        // Merge into existing contact
        final merged = await notifier.mergeContacts(
          bestMatch.matchingContact,
          tempNewContact,
          decision.fieldSelections,
        );
        if (merged != null && mounted) {
          notifier.reset();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Contact merged successfully'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.go('/contacts/${merged.id}');
        } else if (mounted) {
          // Show error if merge failed
          final error = ref.read(scanNotifierProvider).error;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error ?? 'Failed to merge contact'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      // MergeAction.keepBoth — fall through to save as new contact
    }

    // Save as new contact
    final contact = await notifier.saveAsContact();

    if (contact != null && mounted) {
      notifier.reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact saved successfully!'),
          backgroundColor: AppColors.primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.go('/contacts/${contact.id}');
    } else if (mounted) {
      // Show error message from state
      final error = ref.read(scanNotifierProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Failed to save contact. Please try again.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _scanAgain() {
    ref.read(scanNotifierProvider.notifier).reset();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanNotifierProvider);
    final scannedCard = scanState.scannedCard;

    if (scannedCard == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Preview')),
        body: const Center(child: Text('No scan data available')),
      );
    }

    // Handle auto-save: show snackbar and navigate back
    if (scanState.wasAutoSaved) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('High-confidence scan auto-saved!'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
          ref.read(scanNotifierProvider.notifier).reset();
          context.pop();
        }
      });
    }

    // Initialize controllers with current fields
    _initControllers(scannedCard.extractedFields);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
        ),
        title: const Text(
          'Review Scan',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() => _isEditing = !_isEditing),
            child: Text(
              _isEditing ? 'Done' : 'Edit',
              style: const TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card thumbnails
                  _buildCardThumbnails(scannedCard),
                  const SizedBox(height: 24),

                  // Overall confidence
                  _buildConfidenceOverview(scannedCard),
                  const SizedBox(height: 24),

                  // Extracted fields
                  _buildExtractedFields(scannedCard),
                ],
              ),
            ),
          ),

          // Bottom actions
          _buildBottomActions(scanState),
        ],
      ),
    );
  }

  Widget _buildCardThumbnails(ScannedCard card) {
    print('🖼️ [PREVIEW] Building thumbnails. Front: ${card.frontImagePath}');
    print('🖼️ [PREVIEW] Building thumbnails. Back: ${card.backImagePath}');

    return Row(
      children: [
        if (card.frontImagePath != null)
          Expanded(child: _buildThumbnail(card.frontImagePath!, 'Front')),
        if (card.frontImagePath != null && card.backImagePath != null)
          const SizedBox(width: 12),
        if (card.backImagePath != null)
          Expanded(child: _buildThumbnail(card.backImagePath!, 'Back')),
        if (card.backImagePath == null && card.frontImagePath != null)
          const Spacer(),
      ],
    );
  }

  Widget _buildThumbnail(String imagePath, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.darkGray,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.lightGray),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.offWhite,
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: AppColors.mediumGray,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfidenceOverview(ScannedCard card) {
    final confidencePercent = (card.overallConfidence * 100).toInt();
    final hasLowConfidence = card.hasLowConfidenceFields;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasLowConfidence
            ? AppColors.warmGold.withValues(alpha: 0.1)
            : AppColors.primaryGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ConfidenceIndicator(confidence: card.overallConfidence, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Confidence: $confidencePercent%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                // Show language detection hint
                if (ref.read(scanNotifierProvider).scannedCard != null)
                  Text(
                    'Language: ${ref.read(enhancedOcrServiceProvider).extractTextEnhanced(File('dummy')).then((_) {}).toString()}', // Dummy
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                if (hasLowConfidence)
                  const Text(
                    'Some fields may need review',
                    style: TextStyle(fontSize: 12, color: AppColors.darkGray),
                  ),
              ],
            ),
          ),
          Text(
            '${card.extractedFields.length} fields',
            style: const TextStyle(fontSize: 12, color: AppColors.mediumGray),
          ),
        ],
      ),
    );
  }

  Widget _buildExtractedFields(ScannedCard card) {
    // Group fields by type
    final groupedFields = <String, List<ExtractedField>>{};
    for (final field in card.extractedFields) {
      groupedFields.putIfAbsent(field.fieldType, () => []).add(field);
    }

    // Define field type order
    const fieldOrder = [
      ExtractedFieldType.name,
      ExtractedFieldType.jobTitle,
      ExtractedFieldType.company,
      ExtractedFieldType.phone,
      ExtractedFieldType.email,
      ExtractedFieldType.address,
      ExtractedFieldType.website,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Extracted Information',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 16),
        ...fieldOrder
            .where((type) => groupedFields.containsKey(type))
            .map((type) => _buildFieldGroup(type, groupedFields[type]!)),
        if (card.extractedFields.isEmpty) _buildNoFieldsPlaceholder(),
      ],
    );
  }

  Widget _buildFieldGroup(String fieldType, List<ExtractedField> fields) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field type header
        Row(
          children: [
            Icon(_getFieldIcon(fieldType), size: 16, color: AppColors.darkGray),
            const SizedBox(width: 8),
            Text(
              ExtractedFieldType.displayName(fieldType),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.darkGray,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Field values
        ...fields.map((field) => _buildFieldItem(field)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFieldItem(ExtractedField field) {
    final key = '${field.fieldType}_${field.value}';
    final controller = _controllers[key];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(8),
        border: field.isLowConfidence
            ? Border.all(color: AppColors.warmGold.withValues(alpha: 0.5))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: _isEditing && controller != null
                ? TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                    onChanged: (value) {
                      ref
                          .read(scanNotifierProvider.notifier)
                          .updateField(field.fieldType, value);
                    },
                  )
                : Text(
                    field.value,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.black,
                      fontStyle: field.isEdited
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          ConfidenceIndicator(confidence: field.confidence),
          if (_isEditing) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                ref
                    .read(scanNotifierProvider.notifier)
                    .removeField(field.fieldType, field.value);
                _controllers.remove(key);
              },
              child: const Icon(
                Icons.close,
                size: 18,
                color: AppColors.coralAccent,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNoFieldsPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off, size: 48, color: AppColors.mediumGray),
          SizedBox(height: 12),
          Text(
            'No text could be extracted',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.darkGray,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Try scanning again with better lighting',
            style: TextStyle(fontSize: 12, color: AppColors.mediumGray),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(ScanState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error message
            if (state.error != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.coralAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 16,
                      color: AppColors.coralAccent,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.error!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.coralAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Action buttons
            Row(
              children: [
                // Scan again button
                Expanded(
                  child: OutlinedButton(
                    onPressed: state.isSaving ? null : _scanAgain,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.primaryGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Scan Again',
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Save button
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed:
                        state.isSaving ||
                            state.scannedCard?.extractedFields.isEmpty == true
                        ? null
                        : _saveContact,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: state.isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Save Contact',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFieldIcon(String fieldType) {
    switch (fieldType) {
      case ExtractedFieldType.name:
        return Icons.person;
      case ExtractedFieldType.jobTitle:
        return Icons.work;
      case ExtractedFieldType.company:
        return Icons.business;
      case ExtractedFieldType.phone:
        return Icons.phone;
      case ExtractedFieldType.email:
        return Icons.email;
      case ExtractedFieldType.address:
        return Icons.location_on;
      case ExtractedFieldType.website:
        return Icons.language;
      default:
        return Icons.text_fields;
    }
  }
}
