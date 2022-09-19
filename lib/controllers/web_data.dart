import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/school_life_item.dart';
import '../models/teacher.dart';
import '../models/broadcast.dart';

class WebData extends GetxController {
  List<SchoolLifeItem> schoolLifeItems = [];
  List<Teacher> teachers = [];
  List<Broadcast> broadcasts = [];

  Future<void> fetchData() async {
    final database = FirebaseDatabase.instance.ref();
    final snapshot = await database.get();
    schoolLifeItems = parseSchoolLife(snapshot);
    teachers = parseTeachers(snapshot);
    broadcasts = parseBroadcasts(snapshot);
  }

  // ###################################################################################
  // #                                    PARSERS                                      #
  // ###################################################################################

  List<SchoolLifeItem> parseSchoolLife(DataSnapshot data) {
    final content = data.value;

    List<SchoolLifeItem> list = [];
    if (content is Map) {
      final schoolLife = content["schoolLife"];
      if (schoolLife != null) {
        schoolLife.forEach((key, value) {
          final item = Map<String, dynamic>.from(value);
          list.add(SchoolLifeItem.fromJson(item, key.toString()));
        });
      }
    }
    list.sort((a, b) => b.datetime.compareTo(a.datetime));
    return list;
  }

  List<Teacher> parseTeachers(DataSnapshot data) {
    final content = data.value;

    List<Teacher> list = [];
    if (content is Map) {
      final teachers = content["teachers"];
      if (teachers != null) {
        if (teachers is Map) {
          teachers.forEach((key, value) {
            list.add(Teacher(key, value));
          });
        }
      }
    }
    list.sort((a, b) => a.abbreviation.compareTo(b.abbreviation));
    return list;
  }

  List<Broadcast> parseBroadcasts(DataSnapshot data) {
    final content = data.value;

    List<Broadcast> list = [];
    if (content is Map) {
      final broadcast = content["broadcast"];
      if (broadcast != null) {
        broadcast.forEach((key, value) {
          final item = Map<String, dynamic>.from(value);
          list.add(Broadcast.fromJson(item, int.parse(key)));
        });
      }
    }
    list.sort((a, b) => a.datetime.compareTo(b.datetime));
    return list;
  }

  // ###################################################################################
  // #                                      ADDERS                                     #
  // ###################################################################################

  Future<void> addSchoolLifeItem(SchoolLifeItem item) async {
    final database =
        FirebaseDatabase.instance.ref("schoolLife/${item.identifier}");
    await database.set(item.toJson());
    schoolLifeItems.add(item);
    schoolLifeItems.sort((a, b) => b.datetime.compareTo(a.datetime));
  }

  Future<void> addTeacher(Teacher teacher) async {
    final database =
        FirebaseDatabase.instance.ref("teachers/${teacher.abbreviation}");
    if (teachers
        .where((element) => element.abbreviation == teacher.abbreviation)
        .isNotEmpty) {
      throw ("error/teacher_already_exists".tr);
    }
    await database.set(teacher.name);
    teachers.add(teacher);
    teachers.sort((a, b) => a.abbreviation.compareTo(b.abbreviation));
  }

  Future<void> sendBroadcast(String header, String content) async {
    final key = DateTime.now().hashCode;
    final broadcast = Broadcast(header, content, DateTime.now(), key);
    final database = FirebaseDatabase.instance.ref("broadcast/$key");
    await database.set({
      "header": broadcast.header,
      "content": broadcast.content,
      "datetime": broadcast.datetime.toIso8601String(),
    });
    broadcasts.add(broadcast);
    broadcasts.sort((a, b) => a.datetime.compareTo(b.datetime));
  }

  Future<void> changePassword(String newPassword) async {
    final database = FirebaseDatabase.instance.ref("credentials/password");
    await database.set(newPassword);
  }

  Future<void> testWriteAccess() async {
    final database = FirebaseDatabase.instance.ref("credentials/testWrite");
    await database.set("test");
    await database.remove();
  }
  // ###################################################################################
  // #                                     REMOVERS                                    #
  // ###################################################################################

  Future<void> removeSchoolLifeItem(String identifier, bool images) async {
    if (identifier.startsWith("item")) {
      throw "error/write_protection".tr;
    }
    final database = FirebaseDatabase.instance.ref("schoolLife/$identifier");
    await database.remove();
    if (images) {
      final storage = FirebaseStorage.instance;
      final directory = await storage.ref("images/$identifier").list();
      directory.items.forEach((element) async {
        await element.delete();
      });
    }
    schoolLifeItems.removeWhere((element) => element.identifier == identifier);
  }

  Future<void> removeTeacher(String abbreviation) async {
    if (abbreviation == "gra") {
      throw "error/write_protection".tr;
    }
    final database = FirebaseDatabase.instance.ref("teachers/$abbreviation");
    await database.remove();
    teachers.removeWhere((element) => element.abbreviation == abbreviation);
  }

  Future<void> removeBroadcast(int identifier) async {
    final database = FirebaseDatabase.instance.ref("broadcast/$identifier");
    await database.remove();
    broadcasts.removeWhere((element) => element.identifier == identifier);
    broadcasts.sort((a, b) => a.datetime.compareTo(b.datetime));
  }

  void clear() {
    schoolLifeItems = [];
    teachers = [];
  }

  // ###################################################################################
  // #                                       IMAGE                                     #
  // ###################################################################################

  Future<String> uploadImage(
    String filename,
    String dir,
    Uint8List bytes,
  ) async {
    int i = 1;
    String file = filename;
    while (await fileExists("images/$dir", file)) {
      file = "$i-$filename";
      i++;
    }
    final storage = FirebaseStorage.instance;
    await storage.ref("images/$dir/$file").putData(bytes);
    return await storage.ref("images/$dir/$file").getDownloadURL();
  }

  Future<void> removeImage(String url) async {
    if (url.startsWith("https://firebasestorage.googleapis.com/")) {
      final storage = FirebaseStorage.instance;
      await storage.refFromURL(url).delete();
    }
  }

  Future<bool> fileExists(String dir, String filename) async {
    final storage = FirebaseStorage.instance;
    final directory = await storage.ref(dir).list();
    return directory.items
        .where((file) => file.fullPath == "$dir/$filename")
        .isNotEmpty;
  }
}
