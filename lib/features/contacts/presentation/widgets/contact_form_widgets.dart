import 'package:flutter/material.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';

/// Multi-value input field for phone numbers, emails, etc.
class MultiValueField extends StatefulWidget {
  final String label;
  final List<String> values;
  final ValueChanged<List<String>> onChanged;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final int maxItems;

  const MultiValueField({
    super.key,
    required this.label,
    required this.values,
    required this.onChanged,
    this.hintText = 'Add item',
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.maxItems = 5,
  });

  @override
  State<MultiValueField> createState() => _MultiValueFieldState();
}

class _MultiValueFieldState extends State<MultiValueField> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _controllers = widget.values.isEmpty
        ? [TextEditingController()]
        : widget.values.map((v) => TextEditingController(text: v)).toList();
  }

  @override
  void didUpdateWidget(MultiValueField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only re-initialize if the number of values changed externally
    // or if a list of values was provided where there was none before.
    if (widget.values.length != _controllers.length ||
        (widget.values.isNotEmpty && oldWidget.values != widget.values)) {
      // Check if current text in controllers matches external values
      final currentTexts = _controllers.map((c) => c.text).toList();
      if (!_isListsEqual(currentTexts, widget.values)) {
        _disposeControllers();
        _initControllers();
      }
    }
  }

  bool _isListsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (i < b.length && a[i] != b[i]) return false;
    }
    return true;
  }

  void _disposeControllers() {
    for (final controller in _controllers) {
      controller.dispose();
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _updateValues() {
    final values = _controllers
        .map((c) => c.text.trim())
        .where((v) => v.isNotEmpty)
        .toList();
    widget.onChanged(values);
  }

  void _addField() {
    if (_controllers.length < widget.maxItems) {
      setState(() {
        _controllers.add(TextEditingController());
      });
    }
  }

  void _removeField(int index) {
    if (_controllers.length > 1) {
      setState(() {
        _controllers[index].dispose();
        _controllers.removeAt(index);
        _updateValues();
      });
    } else {
      _controllers[0].clear();
      _updateValues();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.darkGray,
          ),
        ),
        const SizedBox(height: 8),
        ..._controllers.asMap().entries.map((entry) {
          final index = entry.key;
          final controller = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    keyboardType: widget.keyboardType,
                    onChanged: (_) => _updateValues(),
                    validator: widget.validator,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      prefixIcon: widget.prefixIcon != null
                          ? Icon(widget.prefixIcon, size: 20)
                          : null,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => _removeField(index),
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        if (_controllers.length < widget.maxItems)
          TextButton.icon(
            onPressed: _addField,
            icon: const Icon(Icons.add, size: 18),
            label: Text('Add ${widget.label.toLowerCase()}'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryGreen,
              padding: EdgeInsets.zero,
            ),
          ),
      ],
    );
  }
}

/// Category dropdown selector
class CategoryDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown({super.key, this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.darkGray,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value ?? ContactCategories.uncategorized,
          onChanged: onChanged,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.folder_outlined, size: 20),
          ),
          items: ContactCategories.all.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Row(
                children: [
                  _getCategoryIcon(category),
                  const SizedBox(width: 8),
                  Text(ContactCategories.displayName(category)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _getCategoryIcon(String category) {
    IconData icon;
    Color color;

    switch (category) {
      case ContactCategories.business:
        icon = Icons.business;
        color = AppColors.deepBlue;
        break;
      case ContactCategories.personal:
        icon = Icons.person;
        color = AppColors.primaryGreen;
        break;
      case ContactCategories.friends:
        icon = Icons.people;
        color = AppColors.skyBlue;
        break;
      case ContactCategories.family:
        icon = Icons.family_restroom;
        color = AppColors.warmGold;
        break;
      default:
        icon = Icons.folder;
        color = AppColors.mediumGray;
    }

    return Icon(icon, size: 18, color: color);
  }
}

/// Tags input chip field
class TagsInput extends StatefulWidget {
  final List<String> tags;
  final ValueChanged<List<String>> onChanged;
  final int maxTags;

  const TagsInput({
    super.key,
    required this.tags,
    required this.onChanged,
    this.maxTags = 10,
  });

  @override
  State<TagsInput> createState() => _TagsInputState();
}

class _TagsInputState extends State<TagsInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final trimmed = tag.trim().toLowerCase();
    if (trimmed.isNotEmpty &&
        !widget.tags.contains(trimmed) &&
        widget.tags.length < widget.maxTags) {
      widget.onChanged([...widget.tags, trimmed]);
      _controller.clear();
    }
  }

  void _removeTag(String tag) {
    widget.onChanged(widget.tags.where((t) => t != tag).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.darkGray,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.offWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightGray),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...widget.tags.map(
                    (tag) => Chip(
                      label: Text(tag),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => _removeTag(tag),
                      backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                      labelStyle: const TextStyle(
                        color: AppColors.primaryGreen,
                        fontSize: 12,
                      ),
                      deleteIconColor: AppColors.primaryGreen,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  if (widget.tags.length < widget.maxTags)
                    SizedBox(
                      width: 120,
                      height: 32,
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        decoration: const InputDecoration(
                          hintText: 'Add tag',
                          hintStyle: TextStyle(fontSize: 12),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 0,
                          ),
                          isDense: true,
                        ),
                        style: const TextStyle(fontSize: 12),
                        onSubmitted: _addTag,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${widget.tags.length}/${widget.maxTags} tags',
          style: const TextStyle(fontSize: 12, color: AppColors.mediumGray),
        ),
      ],
    );
  }
}

/// Contact form section header
class FormSectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;

  const FormSectionHeader({super.key, required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: AppColors.primaryGreen),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.deepBlue,
            ),
          ),
        ],
      ),
    );
  }
}

/// Standard text field with label for contact forms
class LabeledTextField extends StatefulWidget {
  final String label;
  final String? value;
  final ValueChanged<String> onChanged;
  final String? hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final int maxLines;
  final bool isRequired;

  const LabeledTextField({
    super.key,
    required this.label,
    this.value,
    required this.onChanged,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.maxLines = 1,
    this.isRequired = false,
  });

  @override
  State<LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(LabeledTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller only if the value changed externally AND it's different from current text
    // This prevents focus loss while typing
    final newValue = widget.value ?? '';
    if (newValue != oldWidget.value && newValue != _controller.text) {
      _controller.text = newValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.darkGray,
              ),
            ),
            if (widget.isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.coralAccent,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Enter ${widget.label}',
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, size: 20)
                : null,
          ),
        ),
      ],
    );
  }
}
