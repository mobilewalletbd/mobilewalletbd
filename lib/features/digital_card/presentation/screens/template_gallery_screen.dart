// Template Gallery Screen
// Browse and select card templates

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/digital_card/domain/entities/card_template.dart';
import 'package:mobile_wallet/features/digital_card/presentation/providers/template_provider.dart';
import 'package:mobile_wallet/features/digital_card/presentation/widgets/template_card.dart';

/// Template Gallery Screen - Browse and select card templates
/// Page 38 design: Template selection with category filters
class TemplateGalleryScreen extends ConsumerStatefulWidget {
  const TemplateGalleryScreen({super.key});

  @override
  ConsumerState<TemplateGalleryScreen> createState() =>
      _TemplateGalleryScreenState();
}

class _TemplateGalleryScreenState extends ConsumerState<TemplateGalleryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<TemplateCategory> _categories = [
    TemplateCategory.minimal,
    TemplateCategory.modern,
    TemplateCategory.elegant,
    TemplateCategory.creative,
    TemplateCategory.professional,
    TemplateCategory.luxury,
    TemplateCategory.corporate,
    TemplateCategory.tech,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length + 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryTabs(),
          Expanded(child: _buildTemplateGrid()),
        ],
      ),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.black),
        onPressed: () => context.pop(),
      ),
      title: const Text(
        'Choose Template',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.lightGray),
      ),
    );
  }

  /// Build search bar
  Widget _buildSearchBar() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search templates...',
          prefixIcon: const Icon(Icons.search, color: AppColors.mediumGray),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.mediumGray),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.offWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: (value) {
          setState(() => _searchQuery = value);
        },
      ),
    );
  }

  /// Build category tabs
  Widget _buildCategoryTabs() {
    return Container(
      color: AppColors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppColors.primaryGreen,
        indicatorWeight: 3,
        labelColor: AppColors.primaryGreen,
        unselectedLabelColor: AppColors.mediumGray,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          const Tab(text: 'All'),
          ..._categories.map(
            (category) => Tab(text: _getCategoryName(category)),
          ),
        ],
      ),
    );
  }

  /// Build template grid
  Widget _buildTemplateGrid() {
    // If searching, show search results
    if (_searchQuery.isNotEmpty) {
      return _buildSearchResults();
    }

    // Otherwise show category-based templates
    return TabBarView(
      controller: _tabController,
      children: [
        _buildAllTemplates(),
        ..._categories.map(_buildCategoryTemplates),
      ],
    );
  }

  /// Build all templates grid
  Widget _buildAllTemplates() {
    final templatesAsync = ref.watch(allTemplatesProvider);

    return templatesAsync.when(
      data: (templates) => _buildGrid(templates),
      loading: () => _buildLoadingGrid(),
      error: (error, stack) => _buildErrorState(error),
    );
  }

  /// Build category-specific templates
  Widget _buildCategoryTemplates(TemplateCategory category) {
    final templatesAsync = ref.watch(templatesByCategoryProvider(category));

    return templatesAsync.when(
      data: (templates) => _buildGrid(templates),
      loading: () => _buildLoadingGrid(),
      error: (error, stack) => _buildErrorState(error),
    );
  }

  /// Build search results
  Widget _buildSearchResults() {
    final searchAsync = ref.watch(searchTemplatesProvider(_searchQuery));

    return searchAsync.when(
      data: (templates) {
        if (templates.isEmpty) {
          return _buildEmptySearchState();
        }
        return _buildGrid(templates);
      },
      loading: () => _buildLoadingGrid(),
      error: (error, stack) => _buildErrorState(error),
    );
  }

  /// Build template grid
  Widget _buildGrid(List<CardTemplate> templates) {
    if (templates.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return TemplateCard(
          template: template,
          onTap: () => _onTemplateSelected(template),
        );
      },
    );
  }

  /// Build loading grid
  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => _buildShimmerCard(),
    );
  }

  /// Build shimmer loading card
  Widget _buildShimmerCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray, width: 1),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightGray.withValues(alpha: 0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.style_outlined, size: 64, color: AppColors.mediumGray),
          const SizedBox(height: 16),
          const Text(
            'No templates available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new designs',
            style: TextStyle(fontSize: 14, color: AppColors.mediumGray),
          ),
        ],
      ),
    );
  }

  /// Build empty search state
  Widget _buildEmptySearchState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppColors.mediumGray),
          const SizedBox(height: 16),
          const Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords',
            style: TextStyle(fontSize: 14, color: AppColors.mediumGray),
          ),
        ],
      ),
    );
  }

  /// Build error state
  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          const Text(
            'Failed to load templates',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(fontSize: 14, color: AppColors.mediumGray),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => ref.refresh(allTemplatesProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Handle template selection
  void _onTemplateSelected(CardTemplate template) {
    // Save selected template to state
    ref.read(selectedTemplateProvider.notifier).selectTemplate(template);

    // Navigate to card editor
    context.push('/digital-card/editor');
  }

  /// Get category display name
  String _getCategoryName(TemplateCategory category) {
    switch (category) {
      case TemplateCategory.minimal:
        return 'Minimal';
      case TemplateCategory.modern:
        return 'Modern';
      case TemplateCategory.elegant:
        return 'Elegant';
      case TemplateCategory.creative:
        return 'Creative';
      case TemplateCategory.professional:
        return 'Professional';
      case TemplateCategory.luxury:
        return 'Luxury';
      case TemplateCategory.corporate:
        return 'Corporate';
      case TemplateCategory.tech:
        return 'Tech';
    }
  }
}
