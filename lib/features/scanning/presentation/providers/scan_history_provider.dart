import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';

import 'package:mobile_wallet/features/contacts/data/repositories/contact_repository_impl.dart';

final scanHistoryProvider = FutureProvider.autoDispose<List<Contact>>((
  ref,
) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return [];
  }

  final repository = ref.watch(contactRepositoryProvider);
  return repository.getContactsBySource(user.id, ContactSources.scan);
});
