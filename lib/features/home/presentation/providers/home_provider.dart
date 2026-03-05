// Home Dashboard Provider
// Manages dashboard state including recent activities and statistics

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile_wallet/features/home/presentation/widgets/recent_activity_feed.dart';

part 'home_provider.g.dart';

/// Dashboard statistics model
class DashboardStats {
  final int totalContacts;
  final int businessContacts;
  final int personalContacts;
  final int favoriteContacts;
  final int recentActivities;

  const DashboardStats({
    this.totalContacts = 0,
    this.businessContacts = 0,
    this.personalContacts = 0,
    this.favoriteContacts = 0,
    this.recentActivities = 0,
  });

  DashboardStats copyWith({
    int? totalContacts,
    int? businessContacts,
    int? personalContacts,
    int? favoriteContacts,
    int? recentActivities,
  }) {
    return DashboardStats(
      totalContacts: totalContacts ?? this.totalContacts,
      businessContacts: businessContacts ?? this.businessContacts,
      personalContacts: personalContacts ?? this.personalContacts,
      favoriteContacts: favoriteContacts ?? this.favoriteContacts,
      recentActivities: recentActivities ?? this.recentActivities,
    );
  }
}

/// Dashboard statistics provider
@riverpod
Future<DashboardStats> dashboardStats(DashboardStatsRef ref) async {
  // TODO: Implement real statistics from Isar database
  // For now, return mock data
  await Future.delayed(const Duration(milliseconds: 500));

  return const DashboardStats(
    totalContacts: 23,
    businessContacts: 15,
    personalContacts: 8,
    favoriteContacts: 5,
    recentActivities: 12,
  );
}

/// Recent activities provider
@riverpod
Future<List<ActivityItem>> recentActivities(RecentActivitiesRef ref) async {
  // TODO: Implement real activities from Isar database
  // For now, return mock data
  await Future.delayed(const Duration(milliseconds: 500));

  final now = DateTime.now();
  return [
    ActivityItem(
      id: '1',
      type: ActivityType.added,
      title: 'Contact Added',
      subtitle: 'John Doe from ABC Company',
      timestamp: now.subtract(const Duration(minutes: 15)),
    ),
    ActivityItem(
      id: '2',
      type: ActivityType.edited,
      title: 'Contact Updated',
      subtitle: 'Jane Smith\'s phone number changed',
      timestamp: now.subtract(const Duration(hours: 2)),
    ),
    ActivityItem(
      id: '3',
      type: ActivityType.contacted,
      title: 'Call Made',
      subtitle: 'Called Mike Johnson',
      timestamp: now.subtract(const Duration(hours: 5)),
    ),
    ActivityItem(
      id: '4',
      type: ActivityType.shared,
      title: 'Contact Shared',
      subtitle: 'Shared Sarah Williams via WhatsApp',
      timestamp: now.subtract(const Duration(days: 1)),
    ),
    ActivityItem(
      id: '5',
      type: ActivityType.added,
      title: 'Contact Added',
      subtitle: 'David Brown from XYZ Corp',
      timestamp: now.subtract(const Duration(days: 2)),
    ),
  ];
}

/// Category counts provider
@riverpod
Future<Map<String, int>> categoryCounts(CategoryCountsRef ref) async {
  // TODO: Implement real counts from Isar database
  await Future.delayed(const Duration(milliseconds: 300));

  return {
    'All': 23,
    'Business': 15,
    'Friends': 5,
    'Family': 3,
    'Uncategorized': 0,
  };
}

/// Selected category state provider
@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  String build() {
    return 'All';
  }

  void selectCategory(String category) {
    state = category;
  }
}
