import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:schueler_app_manager/models/models.dart';
import 'package:schueler_app_manager/repositories/repositories.dart';

final persistenceProvider = ChangeNotifierProvider((ref) => PersistenceProvider(ref));

class PersistenceProvider extends ChangeNotifier {
  // Store ref for accessing other providers
  // ignore: unused_field
  final Ref _ref;
  PersistenceProvider(this._ref);

  List<SchoolLifeItem> _schoolLifeItems = [];
  List<Teacher> _teachers = [];
  List<Broadcast> _broadcasts = [];
  List<FeedbackItem> _feedbacks = [];
  Credentials? _credentials;
  List<(String, String)> _allImages = [];
  List<String> _referencedImages = [];
  List<UserProfile> _userProfiles = [];

  List<SchoolLifeItem> get schoolLifeItems => [..._schoolLifeItems];
  List<Teacher> get teachers => [..._teachers];
  List<Broadcast> get broadcasts => [..._broadcasts];
  List<FeedbackItem> get feedbacks => [..._feedbacks];
  Credentials? get credentials => _credentials;
  List<(String, String)> get allImages => [..._allImages];
  List<String> get referencedImages => [..._referencedImages];
  List<UserProfile> get userProfiles => [..._userProfiles];

  Future<void> loadStandardData() async {
    _teachers = await PersistenceRepository.instance.loadTeachers();
    _schoolLifeItems = await PersistenceRepository.instance.loadSchoolLifeItems();
    _broadcasts = await PersistenceRepository.instance.loadBroadcasts();
    notifyListeners();
  }

  Future<void> loadAdminData() async {
    _feedbacks = await PersistenceRepository.instance.loadFeedback();
    _credentials = await PersistenceRepository.instance.loadCredentials();
    _allImages = await PersistenceRepository.instance.loadImages();
    _referencedImages = _loadReferencedImages();
    _userProfiles = await PersistenceRepository.instance.loadUserProfiles();
    notifyListeners();
  }

  Future<void> addSchoolLifeItem(SchoolLifeItem item) async {
    await PersistenceRepository.instance.addSchoolLifeItem(item);
  }

  Future<void> addTeacher(Teacher teacher) async {
    await PersistenceRepository.instance.addTeacher(teacher);
  }

  Future<void> addBroadcast(Broadcast broadcast) async {
    await PersistenceRepository.instance.addBroadcast(broadcast);
  }

  Future<void> updateCredentials(Credentials credentials) async {
    await PersistenceRepository.instance.updateCredentials(credentials);
  }

  Future<void> markUserForPasswordReset(UserProfile userProfile) async {
    await PersistenceRepository.instance.updateUserProfile(userProfile.copyWith(
      passwordResetNeeded: true,
    ));
  }

  Future<void> deleteSchoolLifeItem(SchoolLifeItem item) async {
    await PersistenceRepository.instance.deleteSchoolLifeItem(item.identifier);
  }

  Future<void> deleteTeacher(Teacher teacher) async {
    await PersistenceRepository.instance.deleteTeacher(teacher.identifier);
  }

  Future<void> deleteBroadcast(Broadcast broadcast) async {
    await PersistenceRepository.instance.deleteBroadcast(broadcast.identifier);
  }

  Future<void> deleteFeedback(FeedbackItem feedback) async {
    await PersistenceRepository.instance.deleteFeedback(feedback.identifier);
  }

  Future<void> deleteImage((String, String) image) async {
    await PersistenceRepository.instance.deleteImage(image);
  }

  Future<String> uploadImage(String filename, String dir, Uint8List bytes) async {
    final res = await PersistenceRepository.instance.uploadImage(filename, dir, bytes);
    return res.$1;
  }

  /// Load all images that are referenced in the school life items.
  List<String> _loadReferencedImages() {
    List<String> items = [];

    // Load all images from school life items
    for (var schoolLifeItem in _schoolLifeItems) {
      // Only add images that are not external
      if (schoolLifeItem is ArticleSchoolLifeItem && !schoolLifeItem.externalImage) {
        items.add(schoolLifeItem.imageUrl);
      }

      // Add images from article elements
      if (schoolLifeItem.articleElements != null && schoolLifeItem.articleElements!.isNotEmpty) {
        for (var articleElement in schoolLifeItem.articleElements!) {
          if (articleElement is ImageArticleElement) {
            items.add(articleElement.data);
          }
        }
      }
    }

    return items;
  }

  /// Clear all data to ensure that the next user will not have access to the previous user's data.
  void clearData() {
    _teachers = [];
    _schoolLifeItems = [];
    _broadcasts = [];
    _feedbacks = [];
    notifyListeners();
  }
}
