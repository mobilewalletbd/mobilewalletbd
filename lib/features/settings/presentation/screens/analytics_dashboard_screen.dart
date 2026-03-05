import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/contacts/presentation/providers/contact_provider.dart';
import 'package:mobile_wallet/features/digital_card/presentation/providers/card_design_provider.dart';
import 'package:mobile_wallet/features/scanning/presentation/providers/scan_history_provider.dart';

class AnalyticsDashboardScreen extends ConsumerStatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  ConsumerState<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState
    extends ConsumerState<AnalyticsDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final contactsAsync = ref.watch(contactsNotifierProvider);
    final selectedDesignAsync = ref.watch(watchUserCardDesignProvider);
    final scanHistoryAsync = ref.watch(scanHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: const Text('Analytics & Usage'),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Lifetime Stats',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Total Contacts',
                    value: contactsAsync.when(
                      data: (contacts) => contacts.length.toString(),
                      loading: () => '...',
                      error: (_, __) => '!',
                    ),
                    icon: Icons.people,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: 'Cards Scanned',
                    value: scanHistoryAsync.when(
                      data: (scans) => scans.length.toString(),
                      loading: () => '...',
                      error: (_, __) => '!',
                    ),
                    icon: Icons.document_scanner,
                    color: AppColors.coralAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Active Card Design',
                    value: selectedDesignAsync.when(
                      data: (design) => design != null ? 'Yes' : 'No',
                      loading: () => '...',
                      error: (_, __) => '!',
                    ),
                    icon: Icons.credit_card,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: 'Last Export',
                    value: 'Never', // Placeholder for actual tracking
                    icon: Icons.cloud_download,
                    color: Colors.purpleAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.trending_up, color: AppColors.primaryGreen),
                      SizedBox(width: 8),
                      Text(
                        'Growth Insights',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your network is growing steadily.',
                    style: TextStyle(fontSize: 14, color: AppColors.darkGray),
                  ),
                  const SizedBox(height: 24),
                  // Placeholder for a bar chart or line chart visualization
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Detailed charts coming soon',
                        style: TextStyle(color: AppColors.mediumGray),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: AppColors.darkGray),
          ),
        ],
      ),
    );
  }
}
