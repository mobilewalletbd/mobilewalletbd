import 'package:flutter/material.dart';

class CategoryFilterBar extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onSelected;

  const CategoryFilterBar({super.key, 
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    const categories = [
      'Sales & Marketing',
      'Engineering',
      'Design',
      'Finance',
      'Operations',
      'HR & Recruitment',
      'Customer Support',
      'Leadership',
      'Other',
    ];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            final isSelected = selectedCategory == null;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: const Text('All'),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) onSelected(null);
                },
                selectedColor: Colors.green,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 12,
                ),
              ),
            );
          }

          final cat = categories[index - 1];
          final isSelected = selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (selected) => onSelected(selected ? cat : null),
              selectedColor: Colors.green,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }
}

class NoResultsState extends StatelessWidget {
  final VoidCallback onClear;
  const NoResultsState({super.key, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'No teams matching your filters',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onClear,
            child: const Text(
              'Clear All Filters',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
