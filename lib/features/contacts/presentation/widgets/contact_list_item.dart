import 'package:flutter/material.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';

/// List item widget for displaying a contact in list view
/// Height: 72px as per design specifications
class ContactListItem extends StatelessWidget {
  final Contact contact;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onDelete;
  final bool showDivider;
  final bool isSelectionMode;
  final bool isSelected;
  final ValueChanged<bool?>? onSelectionChanged;
  final VoidCallback? onLongPress;

  const ContactListItem({
    super.key,
    required this.contact,
    this.onTap,
    this.onFavoriteToggle,
    this.onDelete,
    this.showDivider = true,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onSelectionChanged,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (isSelectionMode) {
      return InkWell(
        onTap: () => onSelectionChanged?.call(!isSelected),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryGreen.withValues(alpha: 0.1)
                : AppColors.white,
            border: showDivider
                ? Border(
                    bottom: BorderSide(color: AppColors.lightGray, width: 1),
                  )
                : null,
          ),
          child: Row(
            children: [
              // Checkbox
              Checkbox(
                value: isSelected,
                onChanged: onSelectionChanged,
                activeColor: AppColors.primaryGreen,
              ),
              const SizedBox(width: 8),

              // Avatar
              _buildAvatar(),
              const SizedBox(width: 12),

              // Name and subtitle
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (contact.displaySubtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        contact.displaySubtitle!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGray,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Dismissible(
      key: Key(contact.id),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Delete action - ask for confirmation
          return onDelete != null;
        } else if (direction == DismissDirection.startToEnd) {
          // Favorite action - toggle immediately
          onFavoriteToggle?.call();
          return false; // Don't dismiss the item
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete?.call();
        }
      },
      background: Container(
        color: AppColors.warmGold,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: Icon(
          contact.isFavorite ? Icons.star : Icons.star_border,
          color: Colors.white,
          size: 28,
        ),
      ),
      secondaryBackground: Container(
        color: AppColors.coralAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: showDivider
                ? Border(
                    bottom: BorderSide(color: AppColors.lightGray, width: 1),
                  )
                : null,
          ),
          child: Row(
            children: [
              // Avatar
              _buildAvatar(),
              const SizedBox(width: 12),

              // Name and subtitle
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            contact.fullName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (contact.isFavorite)
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.star,
                              size: 16,
                              color: AppColors.warmGold,
                            ),
                          ),
                      ],
                    ),
                    if (contact.displaySubtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        contact.displaySubtitle!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGray,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Chevron
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.lightGray,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryGreenLight.withValues(alpha: 0.2),
        border: Border.all(color: AppColors.lightGray, width: 1),
      ),
      child: contact.hasBusinessCard && contact.frontImageUrl != null
          ? ClipOval(
              child: Image.network(
                contact.frontImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildInitials(),
              ),
            )
          : _buildInitials(),
    );
  }

  Widget _buildInitials() {
    return Center(
      child: Text(
        contact.initials,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }
}

/// Sticky header for alphabetical sections
class ContactSectionHeader extends StatelessWidget {
  final String letter;

  const ContactSectionHeader({super.key, required this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.offWhite,
      alignment: Alignment.centerLeft,
      child: Text(
        letter,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.darkGray,
        ),
      ),
    );
  }
}

/// Empty state widget for no contacts
class EmptyContactsState extends StatelessWidget {
  final VoidCallback? onAddContact;
  final String? message;

  const EmptyContactsState({super.key, this.onAddContact, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_outline,
                size: 60,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message ?? 'No contacts yet',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your first contact to get started',
              style: TextStyle(fontSize: 14, color: AppColors.darkGray),
              textAlign: TextAlign.center,
            ),
            if (onAddContact != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAddContact,
                icon: const Icon(Icons.add),
                label: const Text('Add Contact'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Alphabet scrubber for quick navigation
class AlphabetScrubber extends StatelessWidget {
  final List<String> letters;
  final ValueChanged<String>? onLetterSelected;
  final String? selectedLetter;

  const AlphabetScrubber({
    super.key,
    required this.letters,
    this.onLetterSelected,
    this.selectedLetter,
  });

  static const List<String> alphabet = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    '#',
  ];

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 4,
      top: 0,
      bottom: 0,
      child: Center(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            final box = context.findRenderObject() as RenderBox;
            final localPosition = box.globalToLocal(details.globalPosition);
            final index = (localPosition.dy / 14).floor().clamp(
              0,
              alphabet.length - 1,
            );
            final letter = alphabet[index];
            if (letters.contains(letter)) {
              onLetterSelected?.call(letter);
            }
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: alphabet.map((letter) {
                final isAvailable = letters.contains(letter);
                final isSelected = letter == selectedLetter;

                return GestureDetector(
                  onTap: isAvailable
                      ? () => onLetterSelected?.call(letter)
                      : null,
                  child: SizedBox(
                    height: 14,
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primaryGreen
                            : isAvailable
                            ? AppColors.primaryGreen
                            : AppColors.mediumGray,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
