import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team_expense.dart';
import 'package:mobile_wallet/features/collaboration/presentation/providers/team_provider.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:uuid/uuid.dart';

class AddTeamExpenseDialog extends ConsumerStatefulWidget {
  final String teamId;

  const AddTeamExpenseDialog({super.key, required this.teamId});

  @override
  ConsumerState<AddTeamExpenseDialog> createState() =>
      _AddTeamExpenseDialogState();
}

class _AddTeamExpenseDialogState extends ConsumerState<AddTeamExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Other';

  final List<String> _categories = [
    'Software',
    'Travel',
    'Office',
    'Meals',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider);
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error: User not found.')));
      return;
    }

    final amountStr = _amountController.text.trim();
    final amount = double.tryParse(amountStr);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid positive amount.')),
      );
      return;
    }

    final expense = TeamExpense(
      id: const Uuid().v4(),
      teamId: widget.teamId,
      addedByUserId: user.id,
      title: _titleController.text.trim(),
      amount: amount,
      currency: 'USD',
      date: DateTime.now(),
      category: _selectedCategory,
    );

    try {
      await ref
          .read(teamNotifierProvider.notifier)
          .addTeamExpense(widget.teamId, expense);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense added successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to add expense: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(teamNotifierProvider).isLoading;

    return AlertDialog(
      title: const Text('Add Expense'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g. Figma Subscription',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Required';
                  if (double.tryParse(val) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) =>
                    setState(() => _selectedCategory = val ?? 'Other'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.tonal(
          onPressed: isLoading ? null : _submit,
          style: FilledButton.styleFrom(backgroundColor: Colors.green.shade100),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(
                  'Add Expense',
                  style: TextStyle(color: Colors.green),
                ),
        ),
      ],
    );
  }
}
