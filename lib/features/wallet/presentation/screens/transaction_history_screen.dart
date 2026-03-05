import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile_wallet/core/theme/app_colors.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends ConsumerState<TransactionHistoryScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: const Text(
          'Transaction History',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.black),
            onPressed: _showFilterOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(child: _buildTransactionList()),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All'),
            const SizedBox(width: 8),
            _buildFilterChip('Sent'),
            const SizedBox(width: 8),
            _buildFilterChip('Received'),
            const SizedBox(width: 8),
            _buildFilterChip('Top Up'),
            const SizedBox(width: 8),
            _buildFilterChip('Bills'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
      backgroundColor: AppColors.offWhite,
      selectedColor: AppColors.primaryGreen.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primaryGreen : AppColors.black,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      checkmarkColor: AppColors.primaryGreen,
      side: BorderSide(
        color: isSelected ? AppColors.primaryGreen : AppColors.lightGray,
      ),
    );
  }

  Widget _buildTransactionList() {
    // Mock data - replace with actual data from repository
    final transactions = _getMockTransactions();

    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: AppColors.lightGray,
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.mediumGray,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your transaction history will appear here',
              style: TextStyle(fontSize: 14, color: AppColors.mediumGray),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final type = transaction['type'] as String;
    final isSent = type == 'sent' || type == 'bill';
    final icon = _getTransactionIcon(type);
    final color = isSent ? AppColors.error : AppColors.primaryGreen;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          radius: 24,
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          transaction['title'] as String,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              transaction['date'] as String,
              style: TextStyle(color: AppColors.mediumGray, fontSize: 12),
            ),
            if (transaction['reference'] != null) ...[
              const SizedBox(height: 2),
              Text(
                'Ref: ${transaction['reference']}',
                style: TextStyle(color: AppColors.lightGray, fontSize: 11),
              ),
            ],
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isSent ? '-' : '+'}\$${transaction['amount']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isSent ? AppColors.error : AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(transaction['status']).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                transaction['status'] as String,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(transaction['status']),
                ),
              ),
            ),
          ],
        ),
        onTap: () => _showTransactionDetails(transaction),
      ),
    );
  }

  IconData _getTransactionIcon(String type) {
    switch (type) {
      case 'received':
        return Icons.arrow_downward;
      case 'sent':
        return Icons.arrow_upward;
      case 'topup':
        return Icons.add_circle_outline;
      case 'bill':
        return Icons.receipt;
      default:
        return Icons.swap_horiz;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return AppColors.primaryGreen;
      case 'Pending':
        return Colors.orange;
      case 'Failed':
        return AppColors.error;
      default:
        return AppColors.mediumGray;
    }
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildFilterOption('Date Range'),
            _buildFilterOption('Amount Range'),
            _buildFilterOption('Transaction Type'),
            _buildFilterOption('Status'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label) {
    return ListTile(
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Implement filter logic
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$label filter coming soon')));
      },
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Transaction Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Amount', '\$${transaction['amount']}'),
              _buildDetailRow('Type', transaction['type'] as String),
              _buildDetailRow('Status', transaction['status'] as String),
              _buildDetailRow('Date', transaction['date'] as String),
              if (transaction['reference'] != null)
                _buildDetailRow(
                  'Reference',
                  transaction['reference'] as String,
                ),
              _buildDetailRow('Description', transaction['title'] as String),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Download receipt
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Receipt download coming soon'),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.primaryGreen),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Download Receipt'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: AppColors.mediumGray, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMockTransactions() {
    // Mock data - replace with actual repository data
    return [
      {
        'title': 'Grocery Store',
        'type': 'sent',
        'amount': '45.50',
        'date': 'Today, 10:30 AM',
        'status': 'Completed',
        'reference': 'TXN001234567',
      },
      {
        'title': 'Salary Payment',
        'type': 'received',
        'amount': '2500.00',
        'date': 'Yesterday, 9:00 AM',
        'status': 'Completed',
        'reference': 'TXN001234566',
      },
      {
        'title': 'Transfer to Alice',
        'type': 'sent',
        'amount': '100.00',
        'date': 'Feb 15, 2:45 PM',
        'status': 'Completed',
        'reference': 'TXN001234565',
      },
      {
        'title': 'Wallet Top Up',
        'type': 'topup',
        'amount': '500.00',
        'date': 'Feb 14, 11:20 AM',
        'status': 'Completed',
        'reference': 'TXN001234564',
      },
      {
        'title': 'Electricity Bill',
        'type': 'bill',
        'amount': '75.80',
        'date': 'Feb 13, 4:15 PM',
        'status': 'Completed',
        'reference': 'TXN001234563',
      },
      {
        'title': 'Transfer from Bob',
        'type': 'received',
        'amount': '50.00',
        'date': 'Feb 12, 8:30 AM',
        'status': 'Pending',
        'reference': 'TXN001234562',
      },
    ];
  }
}
