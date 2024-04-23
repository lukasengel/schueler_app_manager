import 'dart:typed_data';

import 'package:schueler_app_manager/repositories/repositories.dart';
import 'package:schueler_app_manager/models/models.dart';

/// Interface for persistence repositories.
/// Persistence repositories are responsible for storing and retrieving data, such as school life items, teachers, and broadcasts.
///
/// This class is meant to be extended by platform-specific implementations.
abstract class PersistenceRepository {
  // Define which implementation should be used througout the application.
  static PersistenceRepository get instance {
    return FirebasePersistenceRepository.instance;
  }

  /// Initialize database connection.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<void> initialize();

  /// Load all school life items.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<List<SchoolLifeItem>> loadSchoolLifeItems();

  /// Load all teachers.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<List<Teacher>> loadTeachers();

  /// Load all broadcasts.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<List<Broadcast>> loadBroadcasts();

  /// Load credentials.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<Credentials> loadCredentials();

  /// Load feedback.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<List<FeedbackItem>> loadFeedback();

  /// Load all stored images and their previews.
  /// The list contains tuples of the form (URL, preview URL).
  ///
  /// Throws [PersistenceException] upon failure.
  Future<List<(String, String)>> loadImages();

  /// Load a user profile by their identifier.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<UserProfile> loadUserProfile(String uid);

  /// Load all user profiles.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<List<UserProfile>> loadUserProfiles();

  /// Load all flags indicating whether a function is enabled.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<Map<String, bool>> loadFunctionFlags();

  /// Add a school life item.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<void> addSchoolLifeItem(SchoolLifeItem item);

  /// Add a teacher.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<void> addTeacher(Teacher teacher);

  /// Add a broadcast.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<void> addBroadcast(Broadcast broadcast);

  /// Update credentials.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<void> updateCredentials(Credentials credentials);

  /// Update a user profile.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<void> updateUserProfile(UserProfile user);

  /// Update a function flag.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<void> updateFunctionFlag(String functionName, bool enabled);

  /// Delete a school life item by its identifier.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<void> deleteSchoolLifeItem(String identifier);

  /// Delete a teacher by their identifier.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<void> deleteTeacher(String identifier);

  /// Delete a broadcast by its identifier.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<void> deleteBroadcast(String identifier);

  /// Delete feedback by its identifier.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<void> deleteFeedback(String identifier);

  /// Upload an image and produce a compressed preview.
  /// Returns the URLs of the uploaded image and its preview.
  /// If no preview is available, the preview URL is the same as the image URL.
  ///
  /// [filename] is the name of the file.
  /// [dir] is the directory in which the file should be stored.
  /// [bytes] is the image data.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<(String, String)> uploadImage(String filename, String dir, Uint8List bytes);

  /// Delete an image and its preview by their URLs.
  ///
  /// Throws [PersistenceException] upon failure.
  Future<void> deleteImage((String, String) image);
}
