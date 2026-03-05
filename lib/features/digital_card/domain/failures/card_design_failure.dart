// Card Design Failure
// Failure types for digital card operations

/// Failure types for card design operations
enum CardDesignFailureType {
  /// Card design was not found
  notFound,

  /// Card design already exists
  alreadyExists,

  /// Validation error (invalid data)
  validationError,

  /// Local storage error
  storageError,

  /// Sync/network error
  syncError,

  /// Permission denied
  permissionDenied,

  /// Template not found
  templateNotFound,

  /// Logo upload failed
  logoUploadFailed,

  /// QR code generation failed
  qrGenerationFailed,

  /// PDF generation failed
  pdfGenerationFailed,

  /// vCard export failed
  vcardExportFailed,

  /// Unknown error
  unknown,
}

/// Exception class for card design-related failures.
class CardDesignFailure implements Exception {
  /// The type of failure
  final CardDesignFailureType type;

  /// Human-readable error message
  final String message;

  /// Original error that caused this failure
  final dynamic originalError;

  /// Stack trace when the error occurred
  final StackTrace? stackTrace;

  const CardDesignFailure({
    required this.type,
    required this.message,
    this.originalError,
    this.stackTrace,
  });

  /// Creates a not found failure
  factory CardDesignFailure.notFound([String? cardId]) {
    return CardDesignFailure(
      type: CardDesignFailureType.notFound,
      message: cardId != null
          ? 'Card design with ID $cardId not found'
          : 'Card design not found',
    );
  }

  /// Creates an already exists failure
  factory CardDesignFailure.alreadyExists(String cardId) {
    return CardDesignFailure(
      type: CardDesignFailureType.alreadyExists,
      message: 'Card design with ID $cardId already exists',
    );
  }

  /// Creates a validation error failure
  factory CardDesignFailure.validationError(String message) {
    return CardDesignFailure(
      type: CardDesignFailureType.validationError,
      message: message,
    );
  }

  /// Creates a storage error failure
  factory CardDesignFailure.storageError(String operation, dynamic error) {
    return CardDesignFailure(
      type: CardDesignFailureType.storageError,
      message: 'Failed to $operation card design: $error',
      originalError: error,
    );
  }

  /// Creates a sync error failure
  factory CardDesignFailure.syncError(String message, dynamic error) {
    return CardDesignFailure(
      type: CardDesignFailureType.syncError,
      message: message,
      originalError: error,
    );
  }

  /// Creates a template not found failure
  factory CardDesignFailure.templateNotFound(String templateId) {
    return CardDesignFailure(
      type: CardDesignFailureType.templateNotFound,
      message: 'Template with ID $templateId not found',
    );
  }

  /// Creates a logo upload failed failure
  factory CardDesignFailure.logoUploadFailed(dynamic error) {
    return CardDesignFailure(
      type: CardDesignFailureType.logoUploadFailed,
      message: 'Failed to upload logo: $error',
      originalError: error,
    );
  }

  /// Creates a QR generation failed failure
  factory CardDesignFailure.qrGenerationFailed(dynamic error) {
    return CardDesignFailure(
      type: CardDesignFailureType.qrGenerationFailed,
      message: 'Failed to generate QR code: $error',
      originalError: error,
    );
  }

  /// Creates a PDF generation failed failure
  factory CardDesignFailure.pdfGenerationFailed(dynamic error) {
    return CardDesignFailure(
      type: CardDesignFailureType.pdfGenerationFailed,
      message: 'Failed to generate PDF: $error',
      originalError: error,
    );
  }

  /// Creates a vCard export failed failure
  factory CardDesignFailure.vcardExportFailed(dynamic error) {
    return CardDesignFailure(
      type: CardDesignFailureType.vcardExportFailed,
      message: 'Failed to export vCard: $error',
      originalError: error,
    );
  }

  /// Creates an unknown error failure
  factory CardDesignFailure.unknown(dynamic error) {
    return CardDesignFailure(
      type: CardDesignFailureType.unknown,
      message: 'An unexpected error occurred: $error',
      originalError: error,
    );
  }

  @override
  String toString() => 'CardDesignFailure: $message';
}
