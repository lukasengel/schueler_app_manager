import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/school_life_item.dart';
import '../models/teacher.dart';

class WebData extends GetxController {
  List<SchoolLifeItem> schoolLifeItems = [];
  List<Teacher> teachers = [];

  Future<void> fetchData() async {
    final database = FirebaseDatabase.instance.ref();
    final snapshot = await database.get();
    schoolLifeItems = parseSchoolLife(snapshot);
    teachers = parseTeachers(snapshot);
  }

  List<SchoolLifeItem> parseSchoolLife(DataSnapshot data) {
    final content = data.value;

    List<SchoolLifeItem> list = [];
    if (content is Map) {
      final schoolLife = content["schoolLife"];
      schoolLife.forEach((key, value) {
        final item = Map<String, dynamic>.from(value);
        list.add(SchoolLifeItem.fromJson(item, key.toString()));
      });
      list.sort((a, b) {
        return b.datetime.millisecondsSinceEpoch
            .compareTo(a.datetime.millisecondsSinceEpoch);
      });
    }

    return list;
  }

  Future<void> deleteItem(String identifier) async {
    if(identifier.startsWith("item")){
      throw "error/write_protection".tr;
    }
    final database = FirebaseDatabase.instance.ref("schoolLife/$identifier");
    await database.remove();
    schoolLifeItems.removeWhere((element) => element.identifier == identifier);
  }

  List<Teacher> parseTeachers(DataSnapshot data) {
    final content = data.value;

    List<Teacher> list = [];
    if (content is Map) {
      final teachers = content["teachers"];
      if (teachers is Map) {
        teachers.forEach((key, value) {
          list.add(Teacher(key, value));
        });
      }
    }
    list.sort((a, b) {
      return a.abbreviation.compareTo(b.abbreviation);
    });

    return list;
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
    teachers.sort((a, b) {
      return a.abbreviation.compareTo(b.abbreviation);
    });
  }

  Future<void> removeTeacher(String abbreviation) async {
    final database = FirebaseDatabase.instance.ref("teachers/$abbreviation");
    await database.remove();
    teachers.removeWhere((element) => element.abbreviation == abbreviation);
  }

  Future<void> sendBroadcast(String header, String content) async {
    final key = DateTime.now().hashCode;
    final database = FirebaseDatabase.instance.ref("broadcast/$key");
    await database.set({
      "header": header,
      "content": content,
      "datetime": DateTime.now().toIso8601String(),
    });
  }

  void clear() {
    schoolLifeItems = [];
    teachers = [];
  }
}
