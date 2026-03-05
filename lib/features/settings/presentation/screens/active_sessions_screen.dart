import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';

class SessionData {
  final String id;
  final String deviceModel;
  final String osVersion;
  final String ipAddress;
  final DateTime lastActive;
  final bool isCurrentDevice;

  SessionData({
    required this.id,
    required this.deviceModel,
    required this.osVersion,
    required this.ipAddress,
    required this.lastActive,
    this.isCurrentDevice = false,
  });
}

class ActiveSessionsScreen extends StatefulWidget {
  const ActiveSessionsScreen({super.key});

  @override
  State<ActiveSessionsScreen> createState() => _ActiveSessionsScreenState();
}

class _ActiveSessionsScreenState extends State<ActiveSessionsScreen> {
  bool _isLoading = true;
  List<SessionData> _sessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final deviceInfo = DeviceInfoPlugin();
    String model = 'Unknown Device';
    String os = 'Unknown OS';

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        model = '${androidInfo.manufacturer} ${androidInfo.model}';
        os = 'Android ${androidInfo.version.release}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        model = iosInfo.name;
        os = '${iosInfo.systemName} ${iosInfo.systemVersion}';
      }
    } catch (e) {
      debugPrint('Error loading device info for sessions: $e');
    }

    // Mock session data for UI representation
    // Later to be replaced by Firebase Realtime DB session tracking
    await Future.delayed(const Duration(seconds: 1)); // simulate network

    if (!mounted) return;

    setState(() {
      _sessions = [
        SessionData(
          id: 'current_session_${DateTime.now().millisecondsSinceEpoch}',
          deviceModel: model,
          osVersion: os,
          ipAddress: '192.168.1.100', // Mock IP
          lastActive: DateTime.now(),
          isCurrentDevice: true,
        ),
        SessionData(
          id: 'mock_session_1',
          deviceModel: 'Chrome on Windows',
          osVersion: 'Windows 11',
          ipAddress: '10.0.0.55',
          lastActive: DateTime.now().subtract(const Duration(days: 2)),
          isCurrentDevice: false,
        ),
      ];
      _isLoading = false;
    });
  }

  void _revokeSession(String id) {
    setState(() {
      _sessions.removeWhere((session) => session.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session revoked successfully.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active Sessions')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _sessions.length,
              itemBuilder: (context, index) {
                final session = _sessions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: Icon(
                      session.deviceModel.toLowerCase().contains('chrome')
                          ? Icons.computer
                          : Icons.phone_android,
                      size: 32,
                      color: session.isCurrentDevice
                          ? AppColors.primaryGreen
                          : AppColors.mediumGray,
                    ),
                    title: Text(
                      session.deviceModel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('${session.osVersion} • ${session.ipAddress}'),
                        const SizedBox(height: 4),
                        Text(
                          session.isCurrentDevice
                              ? 'Active Now'
                              : 'Last active: ${_formatDate(session.lastActive)}',
                          style: TextStyle(
                            color: session.isCurrentDevice
                                ? AppColors.primaryGreen
                                : Colors.grey,
                            fontWeight: session.isCurrentDevice
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    trailing: session.isCurrentDevice
                        ? const Icon(
                            Icons.check_circle,
                            color: AppColors.primaryGreen,
                          )
                        : TextButton(
                            onPressed: () => _revokeSession(session.id),
                            child: const Text(
                              'Revoke',
                              style: TextStyle(color: AppColors.error),
                            ),
                          ),
                  ),
                );
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
