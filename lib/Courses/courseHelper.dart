import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './coursesModel.dart';

List mainCategory = [];
List courseList = [];
Map<String, dynamic> courseDetail = {};
List<Widget> allCourseBox = [];
getMainCategories() {
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("Courses_Categories");

  collectionRef.get().then(
    (value) {
      value.docs.forEach(
        (element) {
          mainCategory.add(element.id);
        },
      );
    },
  );
  Set<dynamic> allCategories = mainCategory.toSet();
  return allCategories;
}

Future<dynamic> getSubCategories(document_name) async {
  try {
    List sub_categories = [];
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("Courses_Categories");

    final DocumentSnapshot snapshot =
        await collectionRef.doc(document_name).get();

    if (snapshot.exists) {
      Map<String, dynamic> Document_Value =
          snapshot.data() as Map<String, dynamic>;
    } else {
      print("Document does not exist");
    }
    return snapshot['subCategories'];
  } catch (e) {
    print(
      "${e.toString()}",
    );
  }
}

Future<Map<String, dynamic>> getCourse(mainDocName, DocName) async {
  final Map<String, dynamic> sub_Category_List = {};
  List<dynamic> course_list = [];
  final CollectionReference collectionReference = FirebaseFirestore.instance
      .collection("/Courses_Categories/$mainDocName/$DocName");
  await collectionReference.get().then(
    (value) {
      value.docs.forEach(
        (element) {
          course_list.add(element.id);
        },
      );
    },
  );
  sub_Category_List[DocName] = course_list;
  return sub_Category_List;
}

getAllCategories() async {
  Map<String, dynamic> course_detail = {};
  List main_categories = await getMainCategories().toList();
  for (var categorie in main_categories) {
    List sub_courses_list = [];
    List subCategories = await getSubCategories(categorie);
    for (var subCategor in subCategories) {
      Map<String, dynamic> courses = await getCourse(categorie, subCategor);
      sub_courses_list.add(courses);
    }
    course_detail[categorie] = sub_courses_list;
  }
  courseDetail = course_detail;
  mainCategory = course_detail.keys.toList();
}

Future<List> setAllCourses() async {
  courseList = [];
  mainCategory = courseDetail.keys.toList();
  for (var category in mainCategory) {
    // print("Main Category  = $category");
    var data = courseDetail[category];
    // print("Data = ${data}");
    for (var subCategory in data) {
      var subCategoryName = subCategory.keys.first;
      List subCoursesList = subCategory[subCategoryName];
      for (var course in subCoursesList) {
        courseList.add([category, subCategoryName, course]);
      }
    }
  }
  return courseList;
}

void getCourseData() async {
  List AllCourses = await setAllCourses();
  print("TOTAL COURSES = ${AllCourses}");
}
// Future<Map<String, dynamic>> getCourseData(
//     mainCourseName, subCourseName, courseName) async {
//   Map<String, dynamic> courseData = {};
//   DocumentReference documentReference = FirebaseFirestore.instance
//       .collection("Courses_Categories")
//       .doc(mainCourseName)
//       .collection(subCourseName)
//       .doc(courseName);
//   await documentReference.get().then(
//     (DocumentSnapshot doc) {
//       final data = doc.data() as Map<String, dynamic>;
//       courseData = data;
//     },
//   );
//   return courseData;
// }
