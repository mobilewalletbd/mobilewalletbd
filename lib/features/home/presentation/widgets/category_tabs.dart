// Category Tabs Widget
// Horizontal scrollable tabs for filtering contacts by category

import 'package:flutter/material.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';

/// Category tabs widget
/// Allows filtering contacts by category
class CategoryTabs extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final Map<String, int>? categoryCounts;

  const CategoryTabs({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.categoryCounts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          final count = categoryCounts?[category];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onCategorySelected(category),
              child: _buildCategoryChip(
                label: category,
                isSelected: isSelected,
                count: count,
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build category chip
  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    int? count,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryGreen : AppColors.offWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppColors.white : AppColors.darkGray,
            ),
          ),
          if (count != null && count > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.white.withValues(alpha: 0.3)
                    : AppColors.lightGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.white : AppColors.darkGray,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
