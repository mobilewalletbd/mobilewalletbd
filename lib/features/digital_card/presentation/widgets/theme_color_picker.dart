// Theme Color Picker Widget
// Allows users to select theme colors for their digital card

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Widget for picking theme colors
class ThemeColorPicker extends StatelessWidget {
  final String selectedColor;
  final Function(String) onColorSelected;

  const ThemeColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  // Predefined color palette
  static const List<String> _colorPalette = [
    '#0BBF7D', // Primary Green
    '#1A1F36', // Deep Blue
    '#4DABF7', // Sky Blue
    '#FFC107', // Warm Gold
    '#FF4D4F', // Coral
    '#9C27B0', // Purple
    '#FF9800', // Orange
    '#E91E63', // Pink
    '#795548', // Brown
    '#607D8B', // Blue Grey
    '#212121', // Black
    '#FFFFFF', // White
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _colorPalette.map((color) {
        final isSelected = color.toLowerCase() == selectedColor.toLowerCase();
        return _ColorOption(
          color: color,
          isSelected: isSelected,
          onTap: () => onColorSelected(color),
        );
      }).toList(),
    );
  }
}

/// Individual color option
class _ColorOption extends StatelessWidget {
  final String color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorOption({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorValue = _hexToColor(color);
    final isWhite = color.toUpperCase() == '#FFFFFF';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: colorValue,
          shape: BoxShape.circle,
          border: Border.all(
            color: isWhite ? AppColors.lightGray : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: colorValue.withValues(alpha: 0.4),
                blurRadius: 8,
                spreadRadius: 2,
              ),
          ],
        ),
        child: isSelected
            ? Icon(
                Icons.check,
                color: _isDarkColor(colorValue) ? Colors.white : Colors.black,
              )
            : null,
      ),
    );
  }

  bool _isDarkColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance < 0.5;
  }
}

/// Convert hex color string to Color
Color _hexToColor(String hex) {
  final buffer = StringBuffer();
  if (hex.length == 6 || hex.length == 7) buffer.write('ff');
  buffer.write(hex.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
