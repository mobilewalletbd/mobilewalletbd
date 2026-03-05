// Card Editor Screen
// Allows users to customize their digital card design

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/card_design.dart';
import '../providers/card_design_provider.dart';
import '../widgets/digital_card_preview.dart';
import '../widgets/template_picker.dart';
import '../widgets/theme_color_picker.dart';

/// Screen for editing digital card design
class CardEditorScreen extends ConsumerStatefulWidget {
  const CardEditorScreen({super.key});

  @override
  ConsumerState<CardEditorScreen> createState() => _CardEditorScreenState();
}

class _CardEditorScreenState extends ConsumerState<CardEditorScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedTab = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardState = ref.watch(cardDesignNotifierProvider);
    final cardDesign = cardState.cardDesign;

    if (cardDesign == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Card'),
        actions: [
          if (cardState.isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Card Preview
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.all(16),
            child: DigitalCardPreview(cardDesign: cardDesign, height: 200),
          ),

          // Tab Bar
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.dashboard), text: 'Template'),
              Tab(icon: Icon(Icons.color_lens), text: 'Theme'),
              Tab(icon: Icon(Icons.settings), text: 'Fields'),
            ],
          ),

          // Tab Content
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _TemplateTab(cardDesign: cardDesign),
                _ThemeTab(cardDesign: cardDesign),
                _FieldsTab(cardDesign: cardDesign),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Template selection tab
class _TemplateTab extends ConsumerWidget {
  final CardDesign cardDesign;

  const _TemplateTab({required this.cardDesign});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardState = ref.watch(cardDesignNotifierProvider);
    final templates = cardState.templates;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose a Template',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Select a layout style for your digital card',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          TemplatePicker(
            templates: templates,
            selectedTemplateId: cardDesign.frontCardTemplateId ?? 'classic',
            onTemplateSelected: (template) {
              ref
                  .read(cardDesignNotifierProvider.notifier)
                  .applyTemplate(template.id);
            },
          ),
        ],
      ),
    );
  }
}

/// Theme customization tab
class _ThemeTab extends ConsumerWidget {
  final CardDesign cardDesign;

  const _ThemeTab({required this.cardDesign});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Theme Color', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Choose a primary color for your card',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ThemeColorPicker(
            selectedColor: cardDesign.themeColor,
            onColorSelected: (color) {
              ref
                  .read(cardDesignNotifierProvider.notifier)
                  .updateThemeColor(color);
            },
          ),
          const SizedBox(height: 32),
          Text('Layout Style', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _LayoutStyleSelector(
            selectedStyle: cardDesign.layoutStyle,
            onStyleSelected: (style) {
              ref
                  .read(cardDesignNotifierProvider.notifier)
                  .updateLayoutStyle(style);
            },
          ),
          const SizedBox(height: 32),
          Text(
            'Design Elements',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Background Pattern'),
                  subtitle: const Text('Show subtle patterns from template'),
                  value: cardDesign.enablePattern,
                  activeThumbColor: AppColors.primaryGreen,
                  onChanged: (value) {
                    ref
                        .read(cardDesignNotifierProvider.notifier)
                        .togglePattern(value);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Background Gradient'),
                  subtitle: const Text('Apply gradient from template'),
                  value: cardDesign.enableGradient,
                  activeThumbColor: AppColors.primaryGreen,
                  onChanged: (value) {
                    ref
                        .read(cardDesignNotifierProvider.notifier)
                        .toggleGradient(value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Layout style selector
class _LayoutStyleSelector extends StatelessWidget {
  final CardDesignLayout selectedStyle;
  final Function(CardDesignLayout) onStyleSelected;

  const _LayoutStyleSelector({
    required this.selectedStyle,
    required this.onStyleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: CardDesignLayout.values.map((style) {
        final isSelected = style == selectedStyle;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => onStyleSelected(style),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryGreen.withValues(alpha: 0.1)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryGreen
                        : AppColors.divider,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _getStyleIcon(style),
                      color: isSelected
                          ? AppColors.primaryGreen
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getStyleName(style),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getStyleIcon(CardDesignLayout style) {
    switch (style) {
      case CardDesignLayout.classic:
        return Icons.view_agenda;
      case CardDesignLayout.modern:
        return Icons.view_compact;
      case CardDesignLayout.minimal:
        return Icons.minimize;
    }
  }

  String _getStyleName(CardDesignLayout style) {
    switch (style) {
      case CardDesignLayout.classic:
        return 'Classic';
      case CardDesignLayout.modern:
        return 'Modern';
      case CardDesignLayout.minimal:
        return 'Minimal';
    }
  }
}

/// Fields configuration tab
class _FieldsTab extends ConsumerWidget {
  final CardDesign cardDesign;

  const _FieldsTab({required this.cardDesign});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleFields = cardDesign.visibleFields;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Visible Fields', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Choose which information to display on your card',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                _buildSwitchTile(
                  title: 'Phone Number',
                  subtitle: 'Display your phone number',
                  icon: Icons.phone,
                  value: visibleFields['phone'] ?? true,
                  onChanged: (value) => _updateField(ref, 'phone', value),
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  title: 'Email Address',
                  subtitle: 'Display your email address',
                  icon: Icons.email,
                  value: visibleFields['email'] ?? true,
                  onChanged: (value) => _updateField(ref, 'email', value),
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  title: 'Company Name',
                  subtitle: 'Display your company',
                  icon: Icons.business,
                  value: visibleFields['companyName'] ?? true,
                  onChanged: (value) => _updateField(ref, 'companyName', value),
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  title: 'Job Title',
                  subtitle: 'Display your position',
                  icon: Icons.work,
                  value: visibleFields['jobTitle'] ?? true,
                  onChanged: (value) => _updateField(ref, 'jobTitle', value),
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  title: 'Website',
                  subtitle: 'Display your website URL',
                  icon: Icons.language,
                  value: visibleFields['website'] ?? false,
                  onChanged: (value) => _updateField(ref, 'website', value),
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  title: 'Address',
                  subtitle: 'Display your address',
                  icon: Icons.location_on,
                  value: visibleFields['address'] ?? false,
                  onChanged: (value) => _updateField(ref, 'address', value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('QR Code', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Card(
            child: SwitchListTile(
              title: const Text('Show QR Code'),
              subtitle: const Text('Display QR code on your card'),
              value: cardDesign.showQrCode,
              onChanged: (value) {
                ref
                    .read(cardDesignNotifierProvider.notifier)
                    .toggleQrCode(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      secondary: Icon(icon, color: AppColors.primaryGreen),
      value: value,
      onChanged: onChanged,
    );
  }

  void _updateField(WidgetRef ref, String field, bool value) {
    final currentFields = Map<String, bool>.from(cardDesign.visibleFields);
    currentFields[field] = value;
    ref
        .read(cardDesignNotifierProvider.notifier)
        .updateVisibleFields(currentFields);
  }
}
