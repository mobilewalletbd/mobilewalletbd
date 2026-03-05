import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/card_design_provider.dart';

class VersionHistoryScreen extends ConsumerStatefulWidget {
  const VersionHistoryScreen({super.key});

  @override
  ConsumerState<VersionHistoryScreen> createState() =>
      _VersionHistoryScreenState();
}

class _VersionHistoryScreenState extends ConsumerState<VersionHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cardDesignNotifierProvider.notifier).loadVersionHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cardDesignNotifierProvider);
    final history = state.versionHistory;
    final isLoading = state.isLoadingHistory;

    return Scaffold(
      appBar: AppBar(title: const Text('Version History')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : history.isEmpty
          ? const Center(child: Text('No version history available'))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final version = history[index];
                final isCurrent = index == 0; // Assuming sorted desc

                return ListTile(
                  leading: Icon(
                    isCurrent ? Icons.check_circle : Icons.history,
                    color: isCurrent ? Colors.green : Colors.grey,
                  ),
                  title: Text(
                    DateFormat.yMMMd().add_jm().format(version.createdAt),
                  ),
                  subtitle: Text(version.commitMessage ?? 'No description'),
                  trailing: isCurrent
                      ? const Chip(label: Text('Current'))
                      : TextButton(
                          onPressed: () => _confirmRestore(context, version.id),
                          child: const Text('Restore'),
                        ),
                );
              },
            ),
    );
  }

  void _confirmRestore(BuildContext context, String versionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Version?'),
        content: const Text(
          'This will overwrite your current card design with this version. '
          'A new version will be created for the restore action.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(cardDesignNotifierProvider.notifier)
                  .restoreVersion(versionId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Version restored successfully'),
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }
}
