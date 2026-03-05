// Contact Card Widget
// Displays contact information in a card format with front/back toggle

import 'package:flutter/material.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';

/// Contact card widget
/// Shows contact preview with front/back card images
class ContactCard extends StatefulWidget {
  final String name;
  final String? title;
  final String? company;
  final String? imageFrontUrl;
  final String? imageBackUrl;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  const ContactCard({
    super.key,
    required this.name,
    this.title,
    this.company,
    this.imageFrontUrl,
    this.imageBackUrl,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  bool _showFront = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card image area (60%)
            _buildCardImageArea(),
            // Contact info
            _buildContactInfo(),
          ],
        ),
      ),
    );
  }

  /// Build card image area
  Widget _buildCardImageArea() {
    final imageUrl = _showFront ? widget.imageFrontUrl : widget.imageBackUrl;

    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Stack(
        children: [
          // Card image or placeholder
          if (imageUrl != null && imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder();
                },
              ),
            )
          else
            _buildPlaceholder(),
          // Favorite button
          if (widget.onFavoriteToggle != null)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: widget.onFavoriteToggle,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.isFavorite ? Icons.star : Icons.star_border,
                    size: 18,
                    color: widget.isFavorite
                        ? AppColors.warmGold
                        : AppColors.mediumGray,
                  ),
                ),
              ),
            ),
          // Front/Back toggle pills
          if (widget.imageFrontUrl != null || widget.imageBackUrl != null)
            Positioned(
              bottom: 8,
              right: 8,
              child: Row(
                children: [
                  if (widget.imageFrontUrl != null)
                    GestureDetector(
                      onTap: () => setState(() => _showFront = true),
                      child: _buildTogglePill('F', _showFront),
                    ),
                  if (widget.imageFrontUrl != null &&
                      widget.imageBackUrl != null)
                    const SizedBox(width: 4),
                  if (widget.imageBackUrl != null)
                    GestureDetector(
                      onTap: () => setState(() => _showFront = false),
                      child: _buildTogglePill('B', !_showFront),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Build placeholder icon
  Widget _buildPlaceholder() {
    return Center(
      child: Icon(Icons.business_center, size: 48, color: AppColors.mediumGray),
    );
  }

  /// Build front/back toggle pill
  Widget _buildTogglePill(String label, bool isActive) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryGreen : AppColors.lightGray,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? AppColors.white : AppColors.darkGray,
          ),
        ),
      ),
    );
  }

  /// Build contact info
  Widget _buildContactInfo() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            widget.title ?? widget.company ?? 'No position',
            style: const TextStyle(fontSize: 12, color: AppColors.mediumGray),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
