// My Digital Card Screen
// Displays the user's digital business card with sharing options

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/card_design.dart';
import '../providers/card_design_provider.dart';
import '../widgets/digital_card_preview.dart';
import '../widgets/qr_code_display.dart';
import '../widgets/share_options_sheet.dart';
import 'nfc_share_screen.dart';

/// Screen for displaying and sharing the user's digital card
class MyDigitalCardScreen extends ConsumerStatefulWidget {
  const MyDigitalCardScreen({super.key});

  @override
  ConsumerState<MyDigitalCardScreen> createState() =>
      _MyDigitalCardScreenState();
}

class _MyDigitalCardScreenState extends ConsumerState<MyDigitalCardScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey _cardPreviewKey = GlobalKey();
  // Card flip state
  bool _isFlipped = false;
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardState = ref.watch(cardDesignNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Digital Card'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _navigateToHistory(context),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditor(context),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _showShareOptions(context),
          ),
        ],
      ),
      body: _buildBody(context, cardState),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showShareOptions(context),
        icon: const Icon(Icons.share),
        label: const Text('Share Card'),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CardDesignState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.error!.message}',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.error),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Reload the provider to trigger _loadUserCard
                ref.refresh(cardDesignNotifierProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final cardDesign = state.cardDesign;
    if (cardDesign == null) {
      return _buildEmptyState(context);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // MISSING-03 FIX: Card flip animation wraps the RepaintBoundary
          GestureDetector(
            onTap: _toggleFlip,
            child: AnimatedBuilder(
              animation: _flipAnimation,
              builder: (context, child) {
                // Front face (0–0.5 → full front, 0.5–1.0 → hidden)
                final isFrontVisible = _flipAnimation.value <= 0.5;
                final rotationY = _flipAnimation.value * 3.14159;
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // perspective
                    ..rotateY(rotationY),
                  child: isFrontVisible
                      ? RepaintBoundary(
                          key: _cardPreviewKey,
                          child: DigitalCardPreview(cardDesign: cardDesign),
                        )
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(3.14159),
                          child: _buildCardBackFace(context, cardDesign, state),
                        ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.touch_app, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  'Tap card to flip',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Publish Status
          _buildPublishStatus(context, cardDesign),
          const SizedBox(height: 24),

          // QR Code Section
          if (cardDesign.showQrCode) ...[
            _buildSectionTitle('QR Code'),
            const SizedBox(height: 12),
            QrCodeDisplay(
              onGenerate: () => ref
                  .read(cardDesignNotifierProvider.notifier)
                  .generateQrCode(),
              qrImage: state.qrCodeImage,
              isGenerating: state.isGeneratingQr,
            ),
            const SizedBox(height: 24),
          ],

          // Quick Actions
          _buildSectionTitle('Quick Actions'),
          const SizedBox(height: 12),
          _buildQuickActions(context, state),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.credit_card_outlined,
              size: 80,
              color: AppColors.primaryGreen.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Create Your Digital Card',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Design your digital business card and share it with others via QR code, NFC, or export as PDF/vCard.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _createCard(context),
              icon: const Icon(Icons.add),
              label: const Text('Create Card'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildQuickActions(BuildContext context, CardDesignState state) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _ActionButton(
          icon: Icons.style,
          label: 'Templates',
          onTap: () => context.pushNamed('templateGallery'),
        ),
        _ActionButton(
          icon: Icons.qr_code,
          label: 'QR Code',
          onTap: () =>
              ref.read(cardDesignNotifierProvider.notifier).generateQrCode(),
          isLoading: state.isGeneratingQr,
        ),
        _ActionButton(
          icon: Icons.picture_as_pdf,
          label: 'Export PDF',
          onTap: () =>
              ref.read(cardDesignNotifierProvider.notifier).exportPdf(),
          isLoading: state.isExportingPdf,
        ),
        _ActionButton(
          icon: Icons.contact_page,
          label: 'vCard',
          onTap: () =>
              ref.read(cardDesignNotifierProvider.notifier).exportVCard(),
          isLoading: state.isExportingVcard,
        ),
        _ActionButton(
          icon: Icons.nfc,
          label: 'NFC Share',
          // MISSING-02 FIX: Navigate to dedicated NfcShareScreen instead of old dialog
          onTap: () => _showNfcShare(context),
          isLoading: state.isNfcSharing,
        ),
        _ActionButton(
          icon: Icons.image,
          label: 'Save Image',
          onTap: () => ref
              .read(cardDesignNotifierProvider.notifier)
              .exportAsImage(key: _cardPreviewKey),
          isLoading: state.isExportingImage,
        ),
      ],
    );
  }

  void _createCard(BuildContext context) {
    final authState = ref.read(authenticationProvider);
    authState.whenData((user) {
      if (user != null) {
        ref
            .read(cardDesignNotifierProvider.notifier)
            .createCardDesign(userId: user.id, templateId: 'classic');
      }
    });
  }

  void _navigateToEditor(BuildContext context) {
    context.pushNamed('cardEditor');
  }

  void _navigateToHistory(BuildContext context) {
    context.pushNamed('versionHistory');
  }

  void _showShareOptions(BuildContext context) {
    final cardState = ref.read(cardDesignNotifierProvider);
    if (cardState.cardDesign == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Create a card first')));
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ShareOptionsSheet(cardPreviewKey: _cardPreviewKey),
    );
  }

  void _toggleFlip() {
    setState(() => _isFlipped = !_isFlipped);
    if (_isFlipped) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
  }

  void _showNfcShare(BuildContext context) {
    // MISSING-02 FIX: Use dedicated full-screen NFC share experience
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const NfcShareScreen()));
  }

  // Legacy NFC dialog — kept for reference but replaced by _showNfcShare
  void _showNfcDialog(BuildContext context) async {
    final isAvailable = await ref
        .read(cardDesignNotifierProvider.notifier)
        .isNfcAvailable();
    if (!isAvailable) {
      if (context.mounted) {
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
      return;
    }
    // Navigate to full-screen NFC share screen
    if (context.mounted) _showNfcShare(context);
  }

  /// Build the back face of the flipped card
  Widget _buildCardBackFace(
    BuildContext context,
    CardDesign cardDesign,
    CardDesignState state,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Scan to Connect',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (state.qrCodeImage != null)
            Image.memory(state.qrCodeImage!, width: 140, height: 140)
          else
            InkWell(
              onTap: () => ref
                  .read(cardDesignNotifierProvider.notifier)
                  .generateQrCode(),
              child: Icon(
                Icons.qr_code,
                size: 100,
                color: AppColors.primaryGreen,
              ),
            ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.nfc, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                'NFC Ready',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPublishStatus(BuildContext context, CardDesign cardDesign) {
    final isPublished = cardDesign.status == CardStatus.active;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPublished ? AppColors.success : AppColors.divider,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isPublished ? Icons.public : Icons.public_off,
            color: isPublished ? AppColors.success : AppColors.textSecondary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPublished ? 'Card is Live' : 'Card is Offline',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  isPublished
                      ? 'Anyone with the link can view.'
                      : 'Only you can see this card.',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: isPublished,
            onChanged: (value) {
              if (value) {
                ref.read(cardDesignNotifierProvider.notifier).publishCard();
              } else {
                ref.read(cardDesignNotifierProvider.notifier).unpublishCard();
              }
            },
            activeThumbColor: AppColors.success,
          ),
        ],
      ),
    );
  }
}

/// Quick action button
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(icon, color: AppColors.primaryGreen),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
