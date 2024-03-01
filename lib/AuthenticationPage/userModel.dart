import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_tutor_zone/helperFunction.dart';

class Student {
  String? uid = "";
  String? _student_name = "";
  String? _student_email = "";
  String? _student_education = "";
  String? _student_phoneNumber = "";
  List _courses_Enrolled = [];

  User() {
    _student_name = "";
    _student_email = "";
    _student_education = "";
    _student_phoneNumber = "";
    _courses_Enrolled = [];
  }

  final studentRef = FirebaseFirestore.instance.collection("Students");
  Future<void> createStudentEntity(
      {String student_email = "",
      String student_name = "",
      String student_PhoneNumber = "",
      String student_Education = ""}) async {
    studentRef.doc(uid).set(
      {
        "email": student_email,
        "name": student_name,
        "phoneNumber": student_PhoneNumber,
        "Education": student_Education,
        "Courses": _courses_Enrolled
      },
    );
  }

  Future<String?> getStudentName() async {
    return await helperFunction.getStudentName();
  }

  Future<String?> getStudentEmail() async {
    return await helperFunction.getStudentEmail();
  }

  Future<String?> getStudentEducation() async {
    return await helperFunction.getStudentEducation();
  }

  Future<String?> getStudentPhNumber() async {
    return await helperFunction.getPhoneNumber();
  }

  // Future<String> _GetStudentName() async {
  //   studentRef.where('uid');
  //   return " ";
  // }
}
