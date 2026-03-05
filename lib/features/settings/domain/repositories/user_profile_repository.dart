import 'package:mobile_wallet/features/settings/domain/entities/user_profile.dart';

/// Repository interface for user profile operations.
///
/// Defines the contract for user profile data access,
/// abstracting the data layer from the domain layer.
abstract class UserProfileRepository {
  /// Creates a new user profile in the database.
  ///
  /// [profile] - The user profile to create
  /// Returns the created profile with any server-generated fields
  /// Throws [UserProfileFailure] if creation fails
  Future<UserProfile> createUserProfile(UserProfile profile);

  /// Retrieves a user profile by user ID.
  ///
  /// [uid] - The unique user identifier (Firebase UID)
  /// Returns the user profile if found, null otherwise
  /// Throws [UserProfileFailure] on database errors
  Future<UserProfile?> getUserProfile(String uid);

  /// Updates an existing user profile.
  ///
  /// [profile] - The updated user profile
  /// Returns the updated profile
  /// Throws [UserProfileFailure] if update fails
  Future<UserProfile> updateUserProfile(UserProfile profile);

  /// Deletes a user profile from the database.
  ///
  /// [uid] - The unique user identifier to delete
  /// Throws [UserProfileFailure] if deletion fails
  Future<void> deleteUserProfile(String uid);

  /// Streams real-time updates to a user profile.
  ///
  /// [uid] - The unique user identifier
  /// Returns a stream of profile updates
  Stream<UserProfile?> watchUserProfile(String uid);

  /// Updates the user's last active timestamp.
  ///
  /// [uid] - The unique user identifier
  Future<void> updateLastActive(String uid);

  /// Updates user preferences.
  ///
  /// [uid] - The unique user identifier
  /// [preferences] - Map of preference key-value pairs to update
  Future<UserProfile> updatePreferences(
    String uid,
    Map<String, dynamic> preferences,
  );

  /// Checks if a user profile exists.
  ///
  /// [uid] - The unique user identifier
  /// Returns true if profile exists
  Future<bool> profileExists(String uid);

  /// Searches for users by name, email, or phone number.
  ///
  /// [query] - The search query
  /// Returns a list of matching user profiles
  Future<List<UserProfile>> searchUsers(String query);
}
