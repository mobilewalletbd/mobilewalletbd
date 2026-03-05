import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:mobile_wallet/features/scanning/presentation/providers/scan_history_provider.dart';

class ScanHistoryScreen extends ConsumerStatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  ConsumerState<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends ConsumerState<ScanHistoryScreen> {
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    final scansAsync = ref.watch(scanHistoryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Scan History',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _showDateRangePicker,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          if (_startDate != null && _endDate != null) _buildDateFilterBar(),
          Expanded(
            child: scansAsync.when(
              data: (scans) {
                final filteredScans = _filterScans(scans);
                if (filteredScans.isEmpty) {
                  return _buildEmptyState();
                }
                return ListView.separated(
                  itemCount: filteredScans.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final scan = filteredScans[index];
                    return _buildScanTile(scan);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error loading scan history: $err'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search names, companies, or phones...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
      ),
    );
  }

  Widget _buildDateFilterBar() {
    final format = DateFormat('MMM d, yyyy');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.blue.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Showing: ${format.format(_startDate!)} - ${format.format(_endDate!)}',
              style: TextStyle(color: Colors.blue.shade800, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20, color: Colors.blue),
            onPressed: () {
              setState(() {
                _startDate = null;
                _endDate = null;
              });
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.document_scanner_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No scans found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cards you scan will appear here.',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildScanTile(Contact scan) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          image: scan.frontImageUrl != null && scan.frontImageUrl!.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(scan.frontImageUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: scan.frontImageUrl == null || scan.frontImageUrl!.isEmpty
            ? const Icon(Icons.business_center, color: Colors.grey)
            : null,
      ),
      title: Text(
        scan.fullName.isNotEmpty ? scan.fullName : 'Unknown Name',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (scan.companyName != null && scan.companyName!.isNotEmpty)
            Text(
              scan.companyName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          if (scan.primaryPhone != null)
            Text(scan.primaryPhone!, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            DateFormat('MMM d, yyyy • h:mm a').format(scan.createdAt),
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
          ),
        ],
      ),
      onTap: () {
        context.pushNamed('contactDetails', pathParameters: {'id': scan.id});
      },
    );
  }

  List<Contact> _filterScans(List<Contact> scans) {
    return scans.where((scan) {
      // 1. Text Search Filter
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        matchesSearch =
            scan.fullName.toLowerCase().contains(q) ||
            (scan.companyName?.toLowerCase().contains(q) ?? false) ||
            (scan.primaryPhone?.contains(q) ?? false);
      }

      // 2. Date Range Filter
      bool matchesDate = true;
      if (_startDate != null && _endDate != null) {
        // Just checking if created on or after start, and on or before end
        matchesDate =
            scan.createdAt.isAfter(
              _startDate!.subtract(const Duration(days: 1)),
            ) &&
            scan.createdAt.isBefore(_endDate!.add(const Duration(days: 1)));
      }

      return matchesSearch && matchesDate;
    }).toList();
  }

  Future<void> _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primaryGreen),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }
}
