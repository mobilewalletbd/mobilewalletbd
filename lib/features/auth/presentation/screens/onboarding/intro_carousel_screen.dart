import 'package:flutter/material.dart';

import 'package:mobile_wallet/core/theme/app_colors.dart';

/// Intro carousel screen for app onboarding.
///
/// Design based on V1_APP_DESIGN_PLAN specifications:
/// - 4 slides: Scan & Save, Connect & Share, Pay Securely, Stay Organized
/// - Skip button at top right (hidden on last slide)
/// - Pagination dots at bottom
/// - Next/Get Started button
class IntroCarouselScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const IntroCarouselScreen({super.key, required this.onComplete});

  @override
  State<IntroCarouselScreen> createState() => _IntroCarouselScreenState();
}

class _IntroCarouselScreenState extends State<IntroCarouselScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<IntroSlide> _slides = [
    IntroSlide(
      illustration: Icons.qr_code_scanner_outlined,
      headline: 'Scan & Save Instantly',
      description:
          'Capture business cards with your camera and save contacts in seconds.',
    ),
    IntroSlide(
      illustration: Icons.share_outlined,
      headline: 'Share Effortlessly',
      description: 'Share your contact via QR code, NFC, or messaging apps.',
    ),
    IntroSlide(
      illustration: Icons.security_outlined,
      headline: 'Pay with Confidence',
      description:
          'Make secure payments and manage your wallet all in one place.',
    ),
    IntroSlide(
      illustration: Icons.folder_special_outlined,
      headline: 'Never Lose a Contact',
      description:
          'Organize, categorize, and access your contacts anytime, anywhere.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // Skip button
          Align(
            alignment: Alignment.centerRight,
            child: _currentPage < _slides.length - 1
                ? TextButton(
                    onPressed: widget.onComplete,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.mediumGray,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          // Page view
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (page) => setState(() => _currentPage = page),
              itemCount: _slides.length,
              itemBuilder: (context, index) => _buildSlide(_slides[index]),
            ),
          ),
          // Pagination dots
          _buildPaginationDots(),
          const SizedBox(height: 16),
          // Next button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _currentPage < _slides.length - 1
                    ? () => _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      )
                    : widget.onComplete,
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
                child: Text(
                  _currentPage < _slides.length - 1 ? 'NEXT' : 'GET STARTED',
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSlide(IntroSlide slide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.primaryGreenLight.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              slide.illustration,
              size: 100,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 48),
          // Headline
          Text(
            slide.headline,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            slide.description,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_slides.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == _currentPage ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == _currentPage
                ? AppColors.primaryGreen
                : AppColors.lightGray,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class IntroSlide {
  final IconData illustration;
  final String headline;
  final String description;

  IntroSlide({
    required this.illustration,
    required this.headline,
    required this.description,
  });
}
