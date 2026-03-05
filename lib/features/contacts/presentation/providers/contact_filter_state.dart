class ContactFilterState {
  final bool showFavoritesOnly;
  final bool hasPhoneNumber;
  final bool hasEmail;
  final String sortBy; // 'name', 'date'

  const ContactFilterState({
    this.showFavoritesOnly = false,
    this.hasPhoneNumber = false,
    this.hasEmail = false,
    this.sortBy = 'name',
  });

  ContactFilterState copyWith({
    bool? showFavoritesOnly,
    bool? hasPhoneNumber,
    bool? hasEmail,
    String? sortBy,
  }) {
    return ContactFilterState(
      showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
      hasPhoneNumber: hasPhoneNumber ?? this.hasPhoneNumber,
      hasEmail: hasEmail ?? this.hasEmail,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}
