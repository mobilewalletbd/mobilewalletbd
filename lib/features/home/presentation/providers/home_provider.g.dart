// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardStatsHash() => r'e2e4771f7f0d8444c93508890be993a18a64a2fc';

/// Dashboard statistics provider
///
/// Copied from [dashboardStats].
@ProviderFor(dashboardStats)
final dashboardStatsProvider =
    AutoDisposeFutureProvider<DashboardStats>.internal(
  dashboardStats,
  name: r'dashboardStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DashboardStatsRef = AutoDisposeFutureProviderRef<DashboardStats>;
String _$recentActivitiesHash() => r'ecd8fe616c94bfe0da288cfcf0cf210cb66d1cb2';

/// Recent activities provider
///
/// Copied from [recentActivities].
@ProviderFor(recentActivities)
final recentActivitiesProvider =
    AutoDisposeFutureProvider<List<ActivityItem>>.internal(
  recentActivities,
  name: r'recentActivitiesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recentActivitiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RecentActivitiesRef = AutoDisposeFutureProviderRef<List<ActivityItem>>;
String _$categoryCountsHash() => r'085cf06be20d5a614ff29dd1216a700bfa0c39b2';

/// Category counts provider
///
/// Copied from [categoryCounts].
@ProviderFor(categoryCounts)
final categoryCountsProvider =
    AutoDisposeFutureProvider<Map<String, int>>.internal(
  categoryCounts,
  name: r'categoryCountsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$categoryCountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CategoryCountsRef = AutoDisposeFutureProviderRef<Map<String, int>>;
String _$selectedCategoryHash() => r'061bc8234e8db4e942c32813a12666fc4233ad4a';

/// Selected category state provider
///
/// Copied from [SelectedCategory].
@ProviderFor(SelectedCategory)
final selectedCategoryProvider =
    AutoDisposeNotifierProvider<SelectedCategory, String>.internal(
  SelectedCategory.new,
  name: r'selectedCategoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCategoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCategory = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
