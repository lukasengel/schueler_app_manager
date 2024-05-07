import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/models/models.dart';
import 'package:schueler_app_manager/exceptions/exceptions.dart';
import 'package:schueler_app_manager/repositories/repositories.dart';

/// Persistence repository implementation using Google Firebase
/// Realtime Database for storing data and Firebase Storage for storing images.
class FirebasePersistenceRepository extends PersistenceRepository {
  // Make class a singleton
  FirebasePersistenceRepository._();
  static final FirebasePersistenceRepository instance = FirebasePersistenceRepository._();

  @override
  Future<void> initialize() async {
    // Nothing to do here
  }

  @override
  Future<List<SchoolLifeItem>> loadSchoolLifeItems() async {
    try {
      final snapshot = await FirebaseDatabase.instance.ref("schoolLife").get();
      final content = snapshot.value;

      List<SchoolLifeItem> items = [];

      if (content != null && content is Map) {
        final map = Map<String, dynamic>.from(content);

        map.entries.forEach((entry) {
          final item = SchoolLifeItem.fromMapEntry(entry);
          items.add(item);
        });
      }

      items.sort((a, b) => b.datetime.compareTo(a.datetime));
      return items;
    } catch (e) {
      AppLogger.instance.e("Error loading school life items: $e");
      throw PersistenceException("Error loading school life items", e);
    }
  }

  @override
  Future<List<Teacher>> loadTeachers() async {
    try {
      final snapshot = await FirebaseDatabase.instance.ref("teachers").get();
      final content = snapshot.value;

      List<Teacher> items = [];

      if (content != null && content is Map) {
        final map = Map<String, String>.from(content);

        map.entries.forEach((entry) {
          final item = Teacher.fromMapEntry(entry);
          items.add(item);
        });
      }

      items.sort((a, b) => a.identifier.compareTo(b.identifier));
      return items;
    } catch (e) {
      AppLogger.instance.e("Error loading teachers: $e");
      throw PersistenceException("Error loading teachers", e);
    }
  }

  @override
  Future<List<Broadcast>> loadBroadcasts() async {
    try {
      final snapshot = await FirebaseDatabase.instance.ref("broadcast").get();
      final content = snapshot.value;

      List<Broadcast> items = [];

      if (content != null && content is Map) {
        final map = Map<String, dynamic>.from(content);

        map.entries.forEach((entry) {
          final item = Broadcast.fromMapEntry(entry);
          items.add(item);
        });
      }

      items.sort((a, b) => a.datetime.compareTo(b.datetime));
      return items;
    } catch (e) {
      AppLogger.instance.e("Error loading broadcasts: $e");
      throw PersistenceException("Error loading broadcasts", e);
    }
  }

  @override
  Future<Credentials> loadCredentials() async {
    try {
      final snapshot = await FirebaseDatabase.instance.ref("credentials").get();
      final content = snapshot.value;

      if (content != null && content is Map) {
        final map = Map<String, dynamic>.from(content);
        return Credentials.fromMap(map);
      }

      throw "No credentials found in database";
    } catch (e) {
      AppLogger.instance.e("Error loading credentials: $e");
      throw PersistenceException("Error loading credentials", e);
    }
  }

  @override
  Future<List<FeedbackItem>> loadFeedback() async {
    try {
      final snapshot = await FirebaseDatabase.instance.ref("feedback").get();
      final content = snapshot.value;

      List<FeedbackItem> items = [];

      if (content != null && content is Map) {
        final map = Map<String, dynamic>.from(content);

        map.entries.forEach((entry) {
          final item = FeedbackItem.fromMapEntry(entry);
          items.add(item);
        });
      }

      return items;
    } catch (e) {
      AppLogger.instance.e("Error loading feedback: $e");
      throw PersistenceException("Error loading feedback", e);
    }
  }

  @override
  Future<List<(String, String)>> loadImages() async {
    try {
      List<(String, String)> items = [];

      final prefixList = await FirebaseStorage.instance.ref("images").list();

      // Iterate through directories
      for (var prefix in prefixList.prefixes) {
        final itemList = await prefix.list();

        // Iterate through items in directory
        for (var item in itemList.items.where((element) => !element.name.startsWith("PREVIEW"))) {
          final url = await item.getDownloadURL();

          if (itemList.items.any((element) => element.name == "PREVIEW.${item.name}")) {
            final previewRef = FirebaseStorage.instance.ref("images/${prefix.name}/PREVIEW.${item.name}");
            final previewUrl = await previewRef.getDownloadURL();
            items.add((url, previewUrl));
            continue;
          }

          items.add((url, url));
        }
      }

      return items;
    } catch (e) {
      AppLogger.instance.e("Error loading images: $e");
      throw PersistenceException("Error loading images", e);
    }
  }

  @override
  Future<UserProfile> loadUserProfile(String uid) async {
    try {
      final snapshot = await FirebaseDatabase.instance.ref("users/$uid").get();
      final content = snapshot.value;

      if (content != null && content is Map) {
        return UserProfile.fromMapEntry(MapEntry(uid, content));
      }

      throw "No user information found in database for user $uid";
    } catch (e) {
      AppLogger.instance.e("Error loading user profile $uid: $e");
      throw PersistenceException("Error loading user profile $uid", e);
    }
  }

  @override
  Future<List<UserProfile>> loadUserProfiles() async {
    try {
      final snapshot = await FirebaseDatabase.instance.ref("users").get();
      final content = snapshot.value;

      List<UserProfile> items = [];

      if (content != null && content is Map) {
        final map = Map<String, dynamic>.from(content);

        map.entries.forEach((entry) {
          final item = UserProfile.fromMapEntry(entry);
          items.add(item);
        });
      }

      items.sort((a, b) => a.displayName.compareTo(b.displayName));

      return items;
    } catch (e) {
      AppLogger.instance.e("Error loading user profiles: $e");
      throw PersistenceException("Error loading user profiles", e);
    }
  }

  @override
  Future<Map<String, bool>> loadFunctionFlags() async {
    try {
      final snapshot = await FirebaseDatabase.instance.ref("functions").get();
      final content = snapshot.value;

      if (content != null && content is Map) {
        content.removeWhere((key, value) => key == "meta");
        return Map<String, bool>.from(content);
      }

      throw "No function flags found in database";
    } catch (e) {
      AppLogger.instance.e("Error loading function flags: $e");
      throw PersistenceException("Error loading function flags", e);
    }
  }

  @override
  Future<void> addSchoolLifeItem(SchoolLifeItem item) async {
    try {
      final entry = item.toMapEntry();
      final ref = FirebaseDatabase.instance.ref("schoolLife/${entry.key}");
      await ref.set(entry.value);
    } catch (e) {
      AppLogger.instance.e("Error adding school life item: $e");
      throw PersistenceException("Error adding school life item", e);
    }
  }

  @override
  Future<void> addTeacher(Teacher teacher) async {
    try {
      final entry = teacher.toMapEntry();
      final ref = FirebaseDatabase.instance.ref("teachers/${entry.key}");
      await ref.set(entry.value);
    } catch (e) {
      AppLogger.instance.e("Error adding teacher: $e");
      throw PersistenceException("Error adding teacher", e);
    }
  }

  @override
  Future<void> addBroadcast(Broadcast broadcast) async {
    try {
      final entry = broadcast.toMapEntry();
      final ref = FirebaseDatabase.instance.ref("broadcast/${entry.key}");
      await ref.set(entry.value);
    } catch (e) {
      AppLogger.instance.e("Error adding broadcast: $e");
      throw PersistenceException("Error adding broadcast", e);
    }
  }

  @override
  Future<void> updateCredentials(Credentials credentials) async {
    try {
      final ref = FirebaseDatabase.instance.ref("credentials");
      await ref.set(credentials.toMap());
    } catch (e) {
      AppLogger.instance.e("Error updating credentials: $e");
      throw PersistenceException("Error updating credentials", e);
    }
  }

  @override
  Future<void> updateUserProfile(UserProfile user) async {
    try {
      final entry = user.toMapEntry();
      final ref = FirebaseDatabase.instance.ref("users/${entry.key}");
      await ref.set(entry.value);
    } catch (e) {
      AppLogger.instance.e("Error updating user profile ${user.uid}: $e");
      throw PersistenceException("Error updating user profile ${user.uid}", e);
    }
  }

  @override
  Future<void> updateFunctionFlag(String functionName, bool enabled) async {
    try {
      final ref = FirebaseDatabase.instance.ref("functions/$functionName");
      await ref.set(enabled);
    } catch (e) {
      AppLogger.instance.e("Error updating flag for function $functionName: $e");
      throw PersistenceException("Error updating flag for function $functionName", e);
    }
  }

  @override
  Future<void> deleteSchoolLifeItem(String identifier) async {
    try {
      final database = FirebaseDatabase.instance.ref("schoolLife/$identifier");
      await database.remove();
    } catch (e) {
      AppLogger.instance.e("Error deleting school life item: $e");
      throw PersistenceException("Error deleting school life item", e);
    }
  }

  @override
  Future<void> deleteTeacher(String identifier) async {
    try {
      final database = FirebaseDatabase.instance.ref("teachers/$identifier");
      await database.remove();
    } catch (e) {
      AppLogger.instance.e("Error deleting teacher: $e");
      throw PersistenceException("Error deleting teacher", e);
    }
  }

  @override
  Future<void> deleteBroadcast(String identifier) async {
    try {
      final database = FirebaseDatabase.instance.ref("broadcast/$identifier");
      await database.remove();
    } catch (e) {
      AppLogger.instance.e("Error deleting broadcast: $e");
      throw PersistenceException("Error deleting broadcast", e);
    }
  }

  @override
  Future<void> deleteFeedback(String identifier) async {
    try {
      final database = FirebaseDatabase.instance.ref("feedback/$identifier");
      await database.remove();
    } catch (e) {
      AppLogger.instance.e("Error deleting feedback: $e");
      throw PersistenceException("Error deleting feedback", e);
    }
  }

  @override
  Future<(String, String)> uploadImage(String filename, String dir, Uint8List bytes) async {
    try {
      int i = 1;
      String fullFilename = filename;

      while (await _fileExists("images/$dir", fullFilename)) {
        fullFilename = "$i-$filename";
        i++;
      }

      var compressed = await FlutterImageCompress.compressWithList(
        bytes,
        minHeight: 200,
        minWidth: 200,
        quality: 85,
      );

      final imageRef = FirebaseStorage.instance.ref("images/$dir/$fullFilename");
      await imageRef.putData(bytes);
      final imageUrl = await imageRef.getDownloadURL();

      final previewRef = FirebaseStorage.instance.ref("images/$dir/PREVIEW.$fullFilename");
      await previewRef.putData(compressed);
      final previewUrl = await previewRef.getDownloadURL();

      return (imageUrl, previewUrl);
    } catch (e) {
      AppLogger.instance.e("Error uploading image: $e");
      throw PersistenceException("Error uploading image", e);
    }
  }

  @override
  Future<void> deleteImage((String, String) image) async {
    try {
      final imageRef = FirebaseStorage.instance.refFromURL(image.$1);
      await imageRef.delete();

      if (image.$1 != image.$2) {
        final previewRef = FirebaseStorage.instance.refFromURL(image.$2);
        await previewRef.delete();
      }
    } catch (e) {
      AppLogger.instance.e("Error deleting image: $e");
      throw PersistenceException("Error deleting image", e);
    }
  }

  /// Check if a file exists in a directory.
  Future<bool> _fileExists(String dir, String filename) async {
    final directory = await FirebaseStorage.instance.ref(dir).list();
    return directory.items.any((element) => element.name == filename);
  }
}
