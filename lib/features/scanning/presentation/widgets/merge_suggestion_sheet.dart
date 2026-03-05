// Merge Suggestion Sheet
// Shows a comparison between a new scanned contact and a potential duplicate,
// allowing the user to choose which fields to keep and how to resolve.

import 'package:flutter/material.dart';

import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:mobile_wallet/features/scanning/domain/entities/duplicate_result.dart';

/// The user's decision after reviewing a merge suggestion.
enum MergeAction {
  /// Merge selected fields into the existing contact
  merge,

  /// Keep both contacts separately
  keepBoth,

  /// Cancel saving entirely
  skip,
}

/// Result returned by the MergeSuggestionSheet.
class MergeDecision {
  final MergeAction action;

  /// Per-field selections: fieldName → 'new' | 'existing'
  final Map<String, String> fieldSelections;

  const MergeDecision({required this.action, this.fieldSelections = const {}});
}

/// A bottom sheet that presents a side-by-side comparison of a new contact
/// and a potential duplicate, letting the user pick per-field values.
class MergeSuggestionSheet extends StatefulWidget {
  final DuplicateResult duplicateResult;
  final Contact newContact;

  const MergeSuggestionSheet({
    super.key,
    required this.duplicateResult,
    required this.newContact,
  });

  /// Show the merge suggestion sheet and return the user's decision.
  static Future<MergeDecision?> show(
    BuildContext context, {
    required DuplicateResult duplicateResult,
    required Contact newContact,
  }) {
    return showModalBottomSheet<MergeDecision>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MergeSuggestionSheet(
        duplicateResult: duplicateResult,
        newContact: newContact,
      ),
    );
  }

  @override
  State<MergeSuggestionSheet> createState() => _MergeSuggestionSheetState();
}

class _MergeSuggestionSheetState extends State<MergeSuggestionSheet> {
  /// Track which source the user picked for each field.
  /// Key = field label, Value = 'new' or 'existing'
  late final Map<String, String> _selections;

  Contact get _existing => widget.duplicateResult.matchingContact;
  Contact get _new => widget.newContact;

  @override
  void initState() {
    super.initState();
    // Default: prefer the new scanned values
    _selections = {};
    for (final row in _buildFieldRows()) {
      _selections[row.label] = 'new';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final score = widget.duplicateResult.overallScore;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.50,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Column(
                  children: [
                    Icon(
                      Icons.people_outline_rounded,
                      size: 36,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Possible Duplicate Found',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'This contact looks ${(score * 100).toStringAsFixed(0)}% '
                      'similar to "${_existing.fullName}"',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // Confidence chip
                    _buildConfidenceChip(score, colorScheme),
                  ],
                ),
              ),

              const Divider(),

              // Column labels
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text(
                        'Field',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'New (Scanned)',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Existing',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Field comparison list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  itemCount: _buildFieldRows().length,
                  itemBuilder: (context, index) {
                    final row = _buildFieldRows()[index];
                    return _buildComparisonRow(row, colorScheme);
                  },
                ),
              ),

              const Divider(height: 1),

              // Action buttons
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      // Skip
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(
                            context,
                            const MergeDecision(action: MergeAction.skip),
                          ),
                          icon: const Icon(Icons.close_rounded, size: 18),
                          label: const Text('Skip'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Keep Both
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(
                            context,
                            const MergeDecision(action: MergeAction.keepBoth),
                          ),
                          icon: const Icon(Icons.people_rounded, size: 18),
                          label: const Text('Keep Both'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Merge
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => Navigator.pop(
                            context,
                            MergeDecision(
                              action: MergeAction.merge,
                              fieldSelections: Map.from(_selections),
                            ),
                          ),
                          icon: const Icon(Icons.merge_rounded, size: 18),
                          label: const Text('Merge'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConfidenceChip(double score, ColorScheme colorScheme) {
    Color chipColor;
    if (score >= 0.80) {
      chipColor = Colors.red;
    } else if (score >= 0.60) {
      chipColor = Colors.orange;
    } else {
      chipColor = Colors.grey;
    }

    return Chip(
      avatar: Icon(Icons.info_outline, size: 16, color: chipColor),
      label: Text(
        widget.duplicateResult.confidenceLabel,
        style: TextStyle(
          color: chipColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      backgroundColor: chipColor.withValues(alpha: 0.1),
      side: BorderSide(color: chipColor.withValues(alpha: 0.3)),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildComparisonRow(_FieldRow row, ColorScheme colorScheme) {
    final selected = _selections[row.label] ?? 'new';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Field label
            Expanded(
              flex: 2,
              child: Text(
                row.label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
            // New value (scanned)
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () => setState(() => _selections[row.label] = 'new'),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selected == 'new'
                          ? colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                    color: selected == 'new'
                        ? colorScheme.primary.withValues(alpha: 0.08)
                        : null,
                  ),
                  child: Text(
                    row.newValue.isEmpty ? '—' : row.newValue,
                    style: TextStyle(
                      fontSize: 12,
                      color: row.newValue.isEmpty
                          ? colorScheme.onSurfaceVariant
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            // Existing value
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () =>
                    setState(() => _selections[row.label] = 'existing'),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selected == 'existing'
                          ? colorScheme.secondary
                          : Colors.transparent,
                      width: 2,
                    ),
                    color: selected == 'existing'
                        ? colorScheme.secondary.withValues(alpha: 0.08)
                        : null,
                  ),
                  child: Text(
                    row.existingValue.isEmpty ? '—' : row.existingValue,
                    style: TextStyle(
                      fontSize: 12,
                      color: row.existingValue.isEmpty
                          ? colorScheme.onSurfaceVariant
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the list of field rows for comparison.
  List<_FieldRow> _buildFieldRows() {
    return [
      _FieldRow(
        label: 'Name',
        newValue: _new.fullName,
        existingValue: _existing.fullName,
      ),
      _FieldRow(
        label: 'Job Title',
        newValue: _new.jobTitle ?? '',
        existingValue: _existing.jobTitle ?? '',
      ),
      _FieldRow(
        label: 'Company',
        newValue: _new.companyName ?? '',
        existingValue: _existing.companyName ?? '',
      ),
      _FieldRow(
        label: 'Phone',
        newValue: _new.phoneNumbers.join(', '),
        existingValue: _existing.phoneNumbers.join(', '),
      ),
      _FieldRow(
        label: 'Email',
        newValue: _new.emails.join(', '),
        existingValue: _existing.emails.join(', '),
      ),
      _FieldRow(
        label: 'Address',
        newValue: _new.addresses.join(', '),
        existingValue: _existing.addresses.join(', '),
      ),
      _FieldRow(
        label: 'Website',
        newValue: _new.websiteUrls.join(', '),
        existingValue: _existing.websiteUrls.join(', '),
      ),
    ];
  }
}

/// Internal helper to represent one row in the comparison table.
class _FieldRow {
  final String label;
  final String newValue;
  final String existingValue;

  const _FieldRow({
    required this.label,
    required this.newValue,
    required this.existingValue,
  });
}
