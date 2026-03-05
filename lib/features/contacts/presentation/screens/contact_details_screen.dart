import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:mobile_wallet/features/contacts/presentation/providers/contact_provider.dart';
import 'package:mobile_wallet/features/contacts/presentation/widgets/delete_contact_dialog.dart';
import 'package:mobile_wallet/shared/presentation/widgets/share_bottom_sheet.dart';

/// Contact Details Screen (Page 20 in design specs)
///
/// Features:
/// - Header action buttons (favorite, edit, delete)
/// - Card image with front/back toggle
/// - Contact name and title
/// - Quick action buttons (Call, SMS, Email)
/// - Detail rows with action icons
/// - QR Code section
/// - Share contact button
class ContactDetailsScreen extends ConsumerStatefulWidget {
  final String contactId;

  const ContactDetailsScreen({super.key, required this.contactId});

  @override
  ConsumerState<ContactDetailsScreen> createState() =>
      _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends ConsumerState<ContactDetailsScreen> {
  bool _showFrontCard = true;

  Future<void> _toggleFavorite(Contact contact) async {
    await ref
        .read(contactsNotifierProvider.notifier)
        .toggleFavorite(contact.id);
  }

  Future<void> _deleteContact(Contact contact) async {
    final confirmed = await DeleteContactDialog.show(
      context,
      contactName: contact.fullName,
    );

    if (confirmed == true) {
      await ref
          .read(contactsNotifierProvider.notifier)
          .deleteContact(contact.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${contact.fullName} deleted'),
            backgroundColor: AppColors.primaryGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go('/contacts');
      }
    }
  }

  void _navigateToEdit(Contact contact) {
    context.push('/contacts/${contact.id}/edit');
  }

  /// Show share options for contact
  Future<void> _showShareOptions(BuildContext context, Contact contact) async {
    await ShareBottomSheet.show(
      context,
      title: 'Share Contact',
      options: [
        ShareOption(
          icon: Icons.contact_page,
          label: 'Share as vCard',
          onTap: () async {
            // In a real implementation, export contact as vCard
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sharing as vCard...')),
            );
          },
        ),
        ShareOption(
          icon: Icons.image,
          label: 'Share as Image',
          onTap: () async {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Exporting as image...')),
            );
          },
        ),
        ShareOption(
          icon: Icons.qr_code,
          label: 'Share QR Code',
          onTap: () async {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Generating QR code...')),
            );
          },
        ),
      ],
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      // Update last contacted
      await ref
          .read(contactsNotifierProvider.notifier)
          .updateLastContacted(widget.contactId);
    }
  }

  Future<void> _sendSms(String phoneNumber) async {
    final uri = Uri.parse('sms:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      await ref
          .read(contactsNotifierProvider.notifier)
          .updateLastContacted(widget.contactId);
    }
  }

  Future<void> _sendEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      await ref
          .read(contactsNotifierProvider.notifier)
          .updateLastContacted(widget.contactId);
    }
  }

  Future<void> _openMaps(String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encodedAddress',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contactAsync = ref.watch(watchContactProvider(widget.contactId));

    return contactAsync.when(
      data: (contact) {
        if (contact == null) {
          return _buildNotFound();
        }
        return _buildContent(contact);
      },
      loading: () => _buildLoading(),
      error: (error, _) => _buildError(error),
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(
        child: CircularProgressIndicator(color: AppColors.primaryGreen),
      ),
    );
  }

  Widget _buildNotFound() {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_off_outlined,
              size: 64,
              color: AppColors.mediumGray,
            ),
            const SizedBox(height: 16),
            const Text(
              'Contact not found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/contacts'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Back to Contacts'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(Object error) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.coralAccent,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load contact',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(color: AppColors.darkGray),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(Contact contact) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Favorite
          IconButton(
            icon: Icon(
              contact.isFavorite ? Icons.star : Icons.star_border,
              color: AppColors.warmGold,
            ),
            onPressed: () => _toggleFavorite(contact),
          ),
          // Edit
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.darkGray),
            onPressed: () => _navigateToEdit(contact),
          ),
          // Share
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.primaryGreen),
            onPressed: () => _showShareOptions(context, contact),
          ),
          // Delete
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.coralAccent,
            ),
            onPressed: () => _deleteContact(contact),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Card Image
              _buildCardImage(contact),
              const SizedBox(height: 16),
              // Name and Title
              _buildNameTitle(contact),
              const SizedBox(height: 16),
              // Quick Actions
              if (contact.hasContactInfo) _buildQuickActions(contact),
              const SizedBox(height: 16),
              // Details
              _buildDetails(contact),
              const SizedBox(height: 16),
              // Tags
              if (contact.tags.isNotEmpty) _buildTags(contact),
              // Notes
              if (contact.notes != null && contact.notes!.isNotEmpty)
                _buildNotes(contact),
              const SizedBox(height: 16),
              // QR Code
              _buildQRCode(contact),
              const SizedBox(height: 24),
              // Share Button
              _buildShareButton(context, contact),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardImage(Contact contact) {
    final hasImages = contact.hasBusinessCard;
    final showFront = _showFrontCard;
    final imageUrl = showFront ? contact.frontImageUrl : contact.backImageUrl;

    return Column(
      children: [
        Center(
          child: Container(
            width: 280,
            height: 175,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: hasImages && imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _buildCardPlaceholder(contact),
                    ),
                  )
                : _buildCardPlaceholder(contact),
          ),
        ),
        if (hasImages &&
            contact.frontImageUrl != null &&
            contact.backImageUrl != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCardToggle('F', _showFrontCard, () {
                  setState(() => _showFrontCard = true);
                }),
                const SizedBox(width: 8),
                _buildCardToggle('B', !_showFrontCard, () {
                  setState(() => _showFrontCard = false);
                }),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCardPlaceholder(Contact contact) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                contact.initials,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No card image',
            style: TextStyle(fontSize: 12, color: AppColors.mediumGray),
          ),
        ],
      ),
    );
  }

  Widget _buildCardToggle(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : AppColors.offWhite,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.lightGray,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.darkGray,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameTitle(Contact contact) {
    return Column(
      children: [
        Text(
          contact.fullName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        if (contact.displaySubtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            contact.displaySubtitle!,
            style: const TextStyle(fontSize: 14, color: AppColors.darkGray),
          ),
        ],
        const SizedBox(height: 8),
        _buildCategoryBadge(contact.category),
      ],
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        ContactCategories.displayName(category),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }

  Widget _buildQuickActions(Contact contact) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (contact.primaryPhone != null)
              _buildQuickActionButton(
                icon: Icons.call_outlined,
                label: 'Call',
                onTap: () => _makePhoneCall(contact.primaryPhone!),
              ),
            if (contact.primaryPhone != null)
              _buildQuickActionButton(
                icon: Icons.sms_outlined,
                label: 'SMS',
                onTap: () => _sendSms(contact.primaryPhone!),
              ),
            if (contact.primaryEmail != null)
              _buildQuickActionButton(
                icon: Icons.email_outlined,
                label: 'Email',
                onTap: () => _sendEmail(contact.primaryEmail!),
              ),
            if (contact.primaryAddress != null)
              _buildQuickActionButton(
                icon: Icons.map_outlined,
                label: 'Map',
                onTap: () => _openMaps(contact.primaryAddress!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.darkGray),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails(Contact contact) {
    final details = <Widget>[];

    // Phone numbers
    for (final phone in contact.phoneNumbers) {
      details.add(
        _buildDetailRow(
          icon: Icons.call_outlined,
          label: 'Phone',
          value: phone,
          actionIcon: Icons.content_copy,
          onAction: () => _copyToClipboard(phone, 'Phone number'),
        ),
      );
      details.add(const Divider(height: 1, indent: 56));
    }

    // Emails
    for (final email in contact.emails) {
      details.add(
        _buildDetailRow(
          icon: Icons.email_outlined,
          label: 'Email',
          value: email,
          actionIcon: Icons.content_copy,
          onAction: () => _copyToClipboard(email, 'Email'),
        ),
      );
      details.add(const Divider(height: 1, indent: 56));
    }

    // Addresses
    for (final address in contact.addresses) {
      details.add(
        _buildDetailRow(
          icon: Icons.location_on_outlined,
          label: 'Address',
          value: address,
          actionIcon: Icons.map_outlined,
          onAction: () => _openMaps(address),
        ),
      );
      details.add(const Divider(height: 1, indent: 56));
    }

    // Websites
    for (final website in contact.websiteUrls) {
      details.add(
        _buildDetailRow(
          icon: Icons.language_outlined,
          label: 'Website',
          value: website,
          actionIcon: Icons.open_in_new,
          onAction: () async {
            final uri = Uri.parse(website);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
        ),
      );
      details.add(const Divider(height: 1, indent: 56));
    }

    // Company
    if (contact.companyName != null) {
      details.add(
        _buildDetailRow(
          icon: Icons.business_outlined,
          label: 'Company',
          value: contact.companyName!,
          actionIcon: Icons.content_copy,
          onAction: () => _copyToClipboard(contact.companyName!, 'Company'),
        ),
      );
    }

    // Remove last divider
    if (details.isNotEmpty && details.last is Divider) {
      details.removeLast();
    }

    if (details.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: details),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required IconData actionIcon,
    required VoidCallback onAction,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryGreen, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: AppColors.mediumGray),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 16, color: AppColors.black),
      ),
      trailing: IconButton(
        icon: Icon(actionIcon, color: AppColors.mediumGray, size: 20),
        onPressed: onAction,
      ),
    );
  }

  Widget _buildTags(Contact contact) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tags',
              style: TextStyle(fontSize: 12, color: AppColors.mediumGray),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: contact.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotes(Contact contact) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.note_outlined,
                  size: 16,
                  color: AppColors.mediumGray,
                ),
                SizedBox(width: 8),
                Text(
                  'Notes',
                  style: TextStyle(fontSize: 12, color: AppColors.mediumGray),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              contact.notes!,
              style: const TextStyle(fontSize: 14, color: AppColors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCode(Contact contact) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.lightGray),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.qr_code_2_outlined,
            size: 80,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Scan to add contact',
          style: TextStyle(fontSize: 14, color: AppColors.mediumGray),
        ),
      ],
    );
  }

  Widget _buildShareButton(BuildContext context, Contact contact) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          onPressed: () => _showShareOptions(context, contact),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          icon: const Icon(Icons.share_outlined),
          label: const Text('SHARE CONTACT'),
        ),
      ),
    );
  }
}
