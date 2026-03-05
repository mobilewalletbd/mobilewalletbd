import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/settings/presentation/providers/user_profile_provider.dart';

class PinManagementScreen extends ConsumerStatefulWidget {
  const PinManagementScreen({super.key});

  @override
  ConsumerState<PinManagementScreen> createState() =>
      _PinManagementScreenState();
}

class _PinManagementScreenState extends ConsumerState<PinManagementScreen> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _isCreatingPin = true;
  String? _errorText;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _savePin() async {
    final pin = _pinController.text;
    final confirmPin = _confirmPinController.text;

    if (pin.length < 4) {
      setState(() => _errorText = 'PIN must be at least 4 digits.');
      return;
    }

    if (pin != confirmPin) {
      setState(() => _errorText = 'PINs do not match.');
      return;
    }

    setState(() => _errorText = null);

    try {
      await ref.read(userProfileNotifierProvider.notifier).updatePreferences({
        'appPin': pin,
        'hasPinEnabled': true,
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('PIN successfully set.')));
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _errorText = 'Failed to save PIN: $e');
    }
  }

  Future<void> _disablePin() async {
    try {
      await ref.read(userProfileNotifierProvider.notifier).updatePreferences({
        'appPin': null,
        'hasPinEnabled': false,
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('PIN disabled.')));
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _errorText = 'Failed to disable PIN: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileNotifierProvider).valueOrNull;
    final hasPinEnabled =
        profile?.preferences['hasPinEnabled'] as bool? ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('PIN Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasPinEnabled) ...[
              const Icon(
                Icons.security,
                size: 64,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(height: 16),
              const Text(
                'You currently have a PIN enabled for this app. You can change it or disable it.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => setState(() => _isCreatingPin = true),
                child: const Text('Change PIN'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _disablePin,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
                child: const Text('Disable PIN'),
              ),
            ],
            if (!hasPinEnabled || _isCreatingPin) ...[
              Text(
                hasPinEnabled ? 'Set New PIN' : 'Create a PIN',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: 'Enter PIN (4-6 digits)',
                  border: const OutlineInputBorder(),
                  errorText: _errorText,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'Confirm PIN',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _savePin,
                child: const Text('Save PIN'),
              ),
              if (hasPinEnabled && _isCreatingPin) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() => _isCreatingPin = false),
                  child: const Text('Cancel'),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
