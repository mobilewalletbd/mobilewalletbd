import 'package:flutter/material.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_wallet/features/collaboration/domain/entities/team.dart';
import 'package:mobile_wallet/features/collaboration/presentation/providers/team_provider.dart';
import 'package:mobile_wallet/features/collaboration/presentation/widgets/add_team_expense_dialog.dart';
import 'package:mobile_wallet/features/digital_card/presentation/providers/card_design_provider.dart';
import 'package:go_router/go_router.dart';

class TeamWalletTab extends ConsumerWidget {
  final Team team;

  const TeamWalletTab({super.key, required this.team});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(teamExpensesProvider(team.id));
    final sharedCardsAsync = ref.watch(cardsSharedWithTeamProvider(team.id));
    final sharedContactsAsync = ref.watch(
      sharedContactsProvider({'teamId': team.id}),
    );
    final expensesLimit = ref.watch(expensesLimitProvider(team.id));

    return ListView(
      children: [
        // Wallet Balance / Expenses Header
        _buildWalletHeader(context, team),

        const SizedBox(height: 16),

        // Shared Cards Section
        _buildSharedCardsSection(context, sharedCardsAsync),

        const SizedBox(height: 16),

        // Shared Contacts Section
        _buildSharedContactsSection(context, sharedContactsAsync),

        const SizedBox(height: 16),

        // Expenses List Header
        _buildExpensesHeader(context),

        // Expenses List
        _buildExpensesList(context, ref, expensesAsync, expensesLimit),
      ],
    );
  }

  Widget _buildWalletHeader(BuildContext context, Team team) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.primaryIndigoLight.withOpacity(0.1),
        border: Border(bottom: BorderSide(color: AppColors.primaryIndigoLight)),
      ),
      child: Column(
        children: [
          const Text(
            'Total Expenses',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${team.totalExpenses?.toStringAsFixed(2) ?? '0.00'}',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryIndigo,
            ),
          ),
          const SizedBox(height: 24),
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _WalletActionButton(
                icon: Icons.add_circle,
                label: 'Add Expense',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AddTeamExpenseDialog(teamId: team.id),
                  );
                },
              ),
              _WalletActionButton(
                icon: Icons.arrow_downward,
                label: 'Deposit',
                onTap: () {},
              ),
              _WalletActionButton(
                icon: Icons.arrow_upward,
                label: 'Withdraw',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSharedCardsSection(
    BuildContext context,
    AsyncValue<List<dynamic>> cardsAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Shared Cards',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: cardsAsync.when(
            data: (cards) {
              if (cards.isEmpty) {
                return _buildEmptySharedItem('No cards shared yet.');
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                scrollDirection: Axis.horizontal,
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return _SharedCardItem(
                    card: card,
                    onTap: () {
                      context.pushNamed(
                        'sharedCardDetails',
                        pathParameters: {'id': team.id, 'cardId': card.id},
                      );
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Widget _buildSharedContactsSection(
    BuildContext context,
    AsyncValue<List<dynamic>> contactsAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Shared Contacts',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: contactsAsync.when(
            data: (contacts) {
              if (contacts.isEmpty) {
                return _buildEmptySharedItem('No contacts shared yet.');
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                scrollDirection: Axis.horizontal,
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return _SharedContactItem(
                    contact: contact,
                    onTap: () {
                      context.pushNamed(
                        'contactDetails',
                        pathParameters: {'id': contact.id},
                      );
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptySharedItem(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildExpensesHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(onPressed: () {}, child: const Text('See All')),
        ],
      ),
    );
  }

  Widget _buildExpensesList(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<dynamic>> expensesAsync,
    int currentLimit,
  ) {
    return expensesAsync.when(
      data: (expenses) {
        if (expenses.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                'No expenses yet.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }
        return Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: expenses.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(
                      _getCategoryIcon(expense.category),
                      color: Colors.grey.shade700,
                    ),
                  ),
                  title: Text(
                    expense.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Added by ${expense.addedByUserId.substring(0, 5)}... • ${DateFormat.yMMMd().format(expense.date)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Text(
                    '-\$${expense.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ),
            if (expenses.length >= currentLimit)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextButton(
                  onPressed: () {
                    ref
                        .read(teamNotifierProvider.notifier)
                        .loadMoreExpenses(team.id);
                  },
                  child: const Text('Load More Expenses'),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, st) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(child: Text('Error: $e')),
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'software':
        return Icons.computer;
      case 'travel':
        return Icons.flight;
      case 'office':
        return Icons.chair;
      case 'meals':
        return Icons.restaurant;
      default:
        return Icons.receipt;
    }
  }
}

class _SharedCardItem extends StatelessWidget {
  final dynamic card;
  final VoidCallback onTap;

  const _SharedCardItem({required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryIndigoLight.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.credit_card,
                  color: AppColors.primaryIndigo,
                ),
              ),
              const Spacer(),
              Text(
                card.name ?? 'Premium Card',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'ID: ${card.id.substring(0, 8)}',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SharedContactItem extends StatelessWidget {
  final dynamic contact;
  final VoidCallback onTap;

  const _SharedContactItem({required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade100,
              foregroundImage:
                  contact.avatarUrl != null && contact.avatarUrl!.isNotEmpty
                  ? NetworkImage(contact.avatarUrl!)
                  : null,
              child: contact.avatarUrl == null || contact.avatarUrl!.isEmpty
                  ? Text(
                      contact.fullName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 70,
              child: Text(
                contact.fullName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _WalletActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: AppColors.primaryIndigo),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
