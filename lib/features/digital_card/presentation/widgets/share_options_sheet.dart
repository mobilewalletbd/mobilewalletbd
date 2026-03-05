// Share Options Sheet
// Bottom sheet with sharing options for digital card

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../collaboration/presentation/providers/team_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/card_design_provider.dart';

/// Bottom sheet with share options
class ShareOptionsSheet extends ConsumerWidget {
  final GlobalKey cardPreviewKey;

  const ShareOptionsSheet({super.key, required this.cardPreviewKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardState = ref.watch(cardDesignNotifierProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
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

          // Title
          Text(
            'Share Your Card',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Choose how you want to share your digital business card',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(
                label: 'Views',
                value: cardState.cardDesign?.viewCount ?? 0,
                icon: Icons.visibility,
                color: AppColors.primaryGreen,
              ),
              _StatItem(
                label: 'Scans',
                value: cardState.cardDesign?.scanCount ?? 0,
                icon: Icons.qr_code_scanner,
                color: AppColors.skyBlue,
              ),
              _StatItem(
                label: 'Shares',
                value: cardState.cardDesign?.shareCount ?? 0,
                icon: Icons.share,
                color: AppColors.warmGold,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Share Options Grid
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _ShareOption(
                icon: Icons.qr_code,
                label: 'QR Code',
                color: AppColors.primaryGreen,
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(cardDesignNotifierProvider.notifier)
                      .generateQrCode();
                  _showQrCodeDialog(context, ref);
                },
              ),
              _ShareOption(
                icon: Icons.picture_as_pdf,
                label: 'PDF',
                color: AppColors.error,
                isLoading: cardState.isExportingPdf,
                onTap: () {
                  Navigator.pop(context);
                  ref.read(cardDesignNotifierProvider.notifier).exportPdf();
                },
              ),
              _ShareOption(
                icon: Icons.contact_page,
                label: 'vCard',
                color: AppColors.skyBlue,
                isLoading: cardState.isExportingVcard,
                onTap: () {
                  Navigator.pop(context);
                  ref.read(cardDesignNotifierProvider.notifier).exportVCard();
                },
              ),
              _ShareOption(
                icon: Icons.nfc,
                label: 'NFC',
                color: AppColors.deepBlue,
                isLoading: cardState.isNfcSharing,
                onTap: () async {
                  Navigator.pop(context);
                  final isAvailable = await ref
                      .read(cardDesignNotifierProvider.notifier)
                      .isNfcAvailable();
                  if (context.mounted) {
                    if (isAvailable) {
                      _showNfcDialog(context, ref);
                    } else {
                      _showNfcUnavailableDialog(context);
                    }
                  }
                },
              ),
              _ShareOption(
                icon: Icons.image,
                label: 'Save Image',
                color: Colors.purple,
                isLoading: cardState.isExportingImage,
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(cardDesignNotifierProvider.notifier)
                      .exportAsImage(key: cardPreviewKey);
                },
              ),
              _ShareOption(
                icon: Icons.groups,
                label: 'Share with Team',
                color: AppColors.skyBlue,
                onTap: () {
                  Navigator.pop(context);
                  _showTeamSelectionDialog(context, ref);
                },
              ),
              _ShareOption(
                icon: Icons.link,
                label: 'Link',
                color: AppColors.warmGold,
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement link sharing
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Link sharing coming soon')),
                  );
                },
              ),
              _ShareOption(
                icon: Icons.share,
                label: 'More',
                color: AppColors.mediumGray,
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement native share
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Native share coming soon')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showQrCodeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Code'),
        content: Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(cardDesignNotifierProvider);
            if (state.isGeneratingQr) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (state.qrCodeImage != null) {
              return Image.memory(state.qrCodeImage!);
            }
            return const SizedBox(
              height: 200,
              child: Center(child: Text('QR Code will appear here')),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNfcDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('NFC Sharing'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.nfc, size: 64, color: AppColors.primaryGreen),
            const SizedBox(height: 16),
            const Text(
              'Hold your device near another device to share your contact.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(cardDesignNotifierProvider.notifier).stopNfcSharing();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    ref.read(cardDesignNotifierProvider.notifier).startNfcSharing();
  }

  void _showNfcUnavailableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('NFC Not Available'),
        content: const Text(
          'This device does not support NFC or it is disabled.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showTeamSelectionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share with Team'),
        content: SizedBox(
          width: double.maxFinite,
          child: Consumer(
            builder: (context, ref, child) {
              final teamsAsync = ref.watch(userTeamsProvider);
              return teamsAsync.when(
                data: (teams) {
                  if (teams.isEmpty) {
                    return const Center(child: Text('No teams found.'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: teams.length,
                    itemBuilder: (context, index) {
                      final team = teams[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            team.name.isNotEmpty ? team.name[0] : '?',
                          ),
                        ),
                        title: Text(team.name),
                        onTap: () {
                          ref
                              .read(cardDesignNotifierProvider.notifier)
                              .shareCardWithTeam(team.id);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Shared with ${team.name}')),
                          );
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Text('Error: $e'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

/// Individual share option
class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isLoading;

  const _ShareOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              )
            else
              Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
