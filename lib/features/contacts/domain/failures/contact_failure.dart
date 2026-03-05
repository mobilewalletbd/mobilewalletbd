/// Failure types for contact operations
enum ContactFailureType {
  /// Contact was not found
  notFound,

  /// Contact already exists (duplicate)
  alreadyExists,

  /// Validation error (invalid data)
  validationError,

  /// Local storage error
  storageError,

  /// Sync/network error
  syncError,

  /// Permission denied
  permissionDenied,

  /// Unknown error
  unknown,
}

/// Exception class for contact-related failures.
///
/// Provides detailed error information for contact operations.
class ContactFailure implements Exception {
  /// The type of failure
  final ContactFailureType type;

  /// Human-readable error message
  final String message;

  /// Original error that caused this failure
  final dynamic originalError;

  /// Stack trace when the error occurred
  final StackTrace? stackTrace;

  const ContactFailure({
    required this.type,
    required this.message,
    this.originalError,
    this.stackTrace,
  });

  /// Creates a not found failure
  factory ContactFailure.notFound([String? contactId]) {
    return ContactFailure(
      type: ContactFailureType.notFound,
      message: contactId != null
          ? 'Contact with ID $contactId not found'
          : 'Contact not found',
    );
  }

  /// Creates an already exists failure
  factory ContactFailure.alreadyExists([String? identifier]) {
    return ContactFailure(
      type: ContactFailureType.alreadyExists,
      message: identifier != null
          ? 'A contact with $identifier already exists'
          : 'Contact already exists',
    );
  }

  /// Creates a validation error failure
  factory ContactFailure.validationError(String field, [String? reason]) {
    return ContactFailure(
      type: ContactFailureType.validationError,
      message: reason ?? 'Invalid value for $field',
    );
  }

  /// Creates a storage error failure
  factory ContactFailure.storageError([String? operation, dynamic error]) {
    return ContactFailure(
      type: ContactFailureType.storageError,
      message: operation != null
          ? 'Failed to $operation contact in local storage'
          : 'Local storage operation failed',
      originalError: error,
    );
  }

  /// Creates a sync error failure
  factory ContactFailure.syncError([String? reason, dynamic error]) {
    return ContactFailure(
      type: ContactFailureType.syncError,
      message: reason ?? 'Failed to sync contacts',
      originalError: error,
    );
  }

  /// Creates a permission denied failure
  factory ContactFailure.permissionDenied([String? resource]) {
    return ContactFailure(
      type: ContactFailureType.permissionDenied,
      message: resource != null
          ? 'Permission denied to access $resource'
          : 'Permission denied',
    );
  }

  /// Creates an unknown failure from an exception
  factory ContactFailure.fromException(dynamic error, [StackTrace? stack]) {
    return ContactFailure(
      type: ContactFailureType.unknown,
      message: error?.toString() ?? 'An unknown error occurred',
      originalError: error,
      stackTrace: stack,
    );
  }

  /// Gets the default message for a failure type
  static String getDefaultMessage(ContactFailureType type) {
    switch (type) {
      case ContactFailureType.notFound:
        return 'Contact not found';
      case ContactFailureType.alreadyExists:
        return 'Contact already exists';
      case ContactFailureType.validationError:
        return 'Invalid contact data';
      case ContactFailureType.storageError:
        return 'Failed to save contact';
      case ContactFailureType.syncError:
        return 'Failed to sync contact';
      case ContactFailureType.permissionDenied:
        return 'Permission denied';
      case ContactFailureType.unknown:
        return 'An error occurred';
    }
  }

  /// Gets a user-friendly message for display
  String get userMessage {
    switch (type) {
      case ContactFailureType.notFound:
        return 'This contact could not be found. It may have been deleted.';
      case ContactFailureType.alreadyExists:
        return 'A contact with this information already exists.';
      case ContactFailureType.validationError:
        return message;
      case ContactFailureType.storageError:
        return 'Unable to save the contact. Please try again.';
      case ContactFailureType.syncError:
        return 'Unable to sync contacts. Please check your connection.';
      case ContactFailureType.permissionDenied:
        return 'You don\'t have permission to perform this action.';
      case ContactFailureType.unknown:
        return 'Something went wrong. Please try again.';
    }
  }

  @override
  String toString() => 'ContactFailure: $message (type: ${type.name})';
}
