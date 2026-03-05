import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/digital_card/domain/entities/card_design.dart';
import 'package:mobile_wallet/features/digital_card/presentation/providers/card_design_provider.dart';
import 'package:mobile_wallet/features/settings/presentation/providers/user_profile_provider.dart';
import 'package:mobile_wallet/features/digital_card/presentation/widgets/digital_card_preview.dart';

class DigitalCardDetailScreen extends ConsumerWidget {
  final String cardId;

  const DigitalCardDetailScreen({super.key, required this.cardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardAsync = ref.watch(cardDesignByIdProvider(cardId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Digital Card')),
      body: cardAsync.when(
        data: (card) {
          if (card == null) {
            return const Center(child: Text('Card not found'));
          }
          return _buildContent(context, ref, card);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, CardDesign card) {
    // Fetch card owner's profile to show their name/title
    final ownerProfileAsync = ref.watch(userProfileByIdProvider(card.userId));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card Preview
          DigitalCardPreview(cardDesign: card),
          const SizedBox(height: 32),

          // Owner Info
          ownerProfileAsync.when(
            data: (profile) => Column(
              children: [
                Text(
                  profile?.fullName ?? 'Unknown User',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (profile?.jobTitle != null)
                  Text(
                    profile!.jobTitle!,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 48),

          // Action Buttons (Simplified for viewing others' cards)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _DetailActionButton(
                icon: Icons.contact_page,
                label: 'Save Contact',
                onTap: () {
                  // TODO: Implement save to phone or app contacts
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saving to contacts...')),
                  );
                },
              ),
              _DetailActionButton(
                icon: Icons.share,
                label: 'Share',
                onTap: () {
                  // TODO: Implement sharing the public link
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DetailActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton.filledTonal(
          onPressed: onTap,
          icon: Icon(icon),
          padding: const EdgeInsets.all(16),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
