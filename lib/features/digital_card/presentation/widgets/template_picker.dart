// Template Picker Widget
// Allows users to select from predefined card templates

import 'package:flutter/material.dart';
import 'package:mobile_wallet/features/digital_card/domain/entities/card_template.dart';

import '../../../../core/theme/app_colors.dart';

/// Widget for picking card templates
class TemplatePicker extends StatelessWidget {
  final List<CardTemplate> templates;
  final String selectedTemplateId;
  final Function(CardTemplate) onTemplateSelected;

  const TemplatePicker({
    super.key,
    required this.templates,
    required this.selectedTemplateId,
    required this.onTemplateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: templates.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final template = templates[index];
        final isSelected = template.id == selectedTemplateId;

        return _TemplateCard(
          template: template,
          isSelected: isSelected,
          onTap: () => onTemplateSelected(template),
        );
      },
    );
  }
}

/// Individual template card
class _TemplateCard extends StatelessWidget {
  final CardTemplate template;
  final bool isSelected;
  final VoidCallback onTap;

  const _TemplateCard({
    required this.template,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = template.primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen.withValues(alpha: 0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Template Preview
            Container(
              width: 80,
              height: 50,
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: themeColor.withValues(alpha: 0.3)),
              ),
              child: Center(
                child: _buildLayoutIcon(template.layoutStyle, themeColor),
              ),
            ),
            const SizedBox(width: 16),

            // Template Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                      color: isSelected
                          ? AppColors.primaryGreen
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    template.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Selection Indicator
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.primaryGreen),
          ],
        ),
      ),
    );
  }

  Widget _buildLayoutIcon(LayoutStyle style, Color color) {
    IconData iconData;
    switch (style) {
      case LayoutStyle.centered:
        iconData = Icons.center_focus_strong;
        break;
      case LayoutStyle.leftAligned:
        iconData = Icons.format_align_left;
        break;
      case LayoutStyle.rightAligned:
        iconData = Icons.format_align_right;
        break;
      case LayoutStyle.split:
        iconData = Icons.view_column;
        break;
      case LayoutStyle.asymmetric:
        iconData = Icons.dashboard_customize;
        break;
    }

    return Icon(iconData, color: color, size: 28);
  }
}
