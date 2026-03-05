// NFC Share Screen
// Full-screen UI for sharing your digital card via NFC tap
// MISSING-02 FIX: This screen was not implemented — now complete.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/services/nfc_service.dart';
import '../../domain/failures/card_design_failure.dart';
import '../providers/card_design_provider.dart';

/// Full-screen NFC sharing experience
class NfcShareScreen extends ConsumerStatefulWidget {
  const NfcShareScreen({super.key});

  @override
  ConsumerState<NfcShareScreen> createState() => _NfcShareScreenState();
}

class _NfcShareScreenState extends ConsumerState<NfcShareScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _successController;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _scaleAnimation;

  NfcSessionState _sessionState = NfcSessionState.idle;
  String? _errorMessage;
  Timer? _timeoutTimer;

  static const _sessionTimeout = Duration(seconds: 60);

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );

    _startNfcSession();
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _pulseController.dispose();
    _successController.dispose();
    // Stop NFC session if still active
    ref.read(nfcServiceProvider).stopSession();
    super.dispose();
  }

  Future<void> _startNfcSession() async {
    setState(() {
      _sessionState = NfcSessionState.waitingForTag;
      _errorMessage = null;
    });

    final cardState = ref.read(cardDesignNotifierProvider);
    if (cardState.cardDesign == null) {
      setState(() {
        _sessionState = NfcSessionState.error;
        _errorMessage = 'No card design found. Please create a card first.';
      });
      return;
    }

    // Start automatic timeout
    _timeoutTimer = Timer(_sessionTimeout, () {
      if (mounted && _sessionState == NfcSessionState.waitingForTag) {
        _handleError('NFC session timed out. Please try again.');
      }
    });

    try {
      await ref.read(cardDesignNotifierProvider.notifier).startNfcSharing();

      if (mounted) {
        setState(() => _sessionState = NfcSessionState.success);
        _successController.forward();
        _pulseController.stop();

        // Auto-close after success
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.of(context).pop();
        });
      }
    } catch (e) {
      final message = e is CardDesignFailure
          ? e.message
          : 'NFC sharing failed. Please try again.';
      _handleError(message);
    } finally {
      _timeoutTimer?.cancel();
    }
  }

  void _handleError(String message) {
    if (mounted) {
      setState(() {
        _sessionState = NfcSessionState.error;
        _errorMessage = message;
      });
      _pulseController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('NFC Share'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIcon(),
              const SizedBox(height: 40),
              _buildTitle(),
              const SizedBox(height: 16),
              _buildSubtitle(),
              const SizedBox(height: 48),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (_sessionState) {
      case NfcSessionState.success:
        return ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              size: 72,
              color: AppColors.primaryGreen,
            ),
          ),
        );

      case NfcSessionState.error:
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.nfc, size: 72, color: AppColors.error),
        );

      default:
        return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _pulseAnimation.value, child: child);
          },
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryGreen.withValues(alpha: 0.4),
                width: 3,
              ),
            ),
            child: Icon(Icons.nfc, size: 80, color: AppColors.primaryGreen),
          ),
        );
    }
  }

  Widget _buildTitle() {
    final text = switch (_sessionState) {
      NfcSessionState.idle => 'Preparing NFC…',
      NfcSessionState.waitingForTag => 'Hold Near Another Phone',
      NfcSessionState.writing => 'Transferring Card…',
      NfcSessionState.success => 'Card Shared!',
      NfcSessionState.error => 'NFC Error',
    };

    return Text(
      text,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: _sessionState == NfcSessionState.success
            ? AppColors.primaryGreen
            : _sessionState == NfcSessionState.error
            ? AppColors.error
            : AppColors.textPrimary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    final text = switch (_sessionState) {
      NfcSessionState.success => 'Your digital card was sent successfully!',
      NfcSessionState.error =>
        _errorMessage ?? 'Something went wrong. Please try again.',
      _ =>
        'Bring this phone close to the back of the recipient\'s device to share your card instantly.',
    };

    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActions() {
    if (_sessionState == NfcSessionState.error) {
      return Column(
        children: [
          ElevatedButton.icon(
            onPressed: _startNfcSession,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      );
    }

    if (_sessionState == NfcSessionState.waitingForTag ||
        _sessionState == NfcSessionState.writing) {
      return Column(
        children: [
          const LinearProgressIndicator(),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () async {
              await ref.read(nfcServiceProvider).stopSession();
              if (mounted) Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
