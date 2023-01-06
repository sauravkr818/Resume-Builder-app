import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

Uuid uuid = const Uuid();

// class Profile {
//   String name;
//   String lastname;
//   String email;
//   String phone;

//   Profile({
//     required this.name,
//     required this.lastname,
//     required this.email,
//     required this.phone,
//   });
//   factory Profile.fromJson(Map<String, dynamic> json) => new Profile(
//         name: json["name"],
//         lastname: json["lastname"],
//         email: json["email"],
//         phone: json["phone"],
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "designation": lastname,
//         "email": email,
//         "phone": phone,
//       };
// }

class Links {
  String sectionId;
  String linkname;
  String linkurl;

  Links({
    required this.sectionId,
    required this.linkname,
    required this.linkurl,
  });

  factory Links.createEmpty() {
    return Links(sectionId: uuid.v4(), linkname: '', linkurl: "");
  }

  factory Links.fromJson(Map<String, dynamic> json) => new Links(
        sectionId: json["sectionId"],
        linkname: json["linkname"],
        linkurl: json["linkurl"],
      );

  Map<String, dynamic> toJson() => {
        "sectionId": sectionId,
        "linkname": linkname,
        "linkurl": linkurl,
      };
}

class Educations {
  String sectionId;
  String universityName;
  String startDate;
  String endDate;
  String courseTaken;
  String degree;
  String gpa;

  Educations({
    required this.sectionId,
    required this.universityName,
    required this.startDate,
    required this.endDate,
    required this.courseTaken,
    required this.degree,
    required this.gpa,
  });

  factory Educations.createEmpty() {
    return Educations(
        sectionId: uuid.v4(),
        universityName: 'Untitled Sch',
        startDate: "",
        endDate: "",
        courseTaken: "",
        degree: "",
        gpa: "");
  }

  factory Educations.fromJson(Map<String, dynamic> json) => new Educations(
        sectionId: json["sectionId"],
        universityName: json["universityName"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        courseTaken: json["courseTaken"],
        degree: json["degree"],
        gpa: json["gpa"],
      );

  Map<String, dynamic> toJson() => {
        "sectionId": sectionId,
        "universityName": universityName,
        "startDate": startDate,
        "endDate": endDate,
        "courseTaken": courseTaken,
        "degree": degree,
        "gpa": gpa,
      };
}

class Experiences {
  String sectionId;
  String jobtitle;
  String employer;
  String startDate;
  String endDate;
  String city;

  Experiences({
    required this.sectionId,
    required this.jobtitle,
    required this.employer,
    required this.startDate,
    required this.endDate,
    required this.city,
  });

  factory Experiences.createEmpty() {
    return Experiences(
      sectionId: uuid.v4(),
      jobtitle: 'Untitled Job Title',
      employer: '',
      startDate: "",
      endDate: "",
      city: "",
    );
  }

  factory Experiences.fromJson(Map<String, dynamic> json) => new Experiences(
        sectionId: json["sectionId"],
        jobtitle: json["jobtitle"],
        employer: json["employer"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        city: json["city"],
      );

  Map<String, dynamic> toJson() => {
        "sectionId": sectionId,
        "jobtitle": jobtitle,
        "employer": employer,
        "startDate": startDate,
        "endDate": endDate,
        "city": city,
      };
}

// skill model

class Skills {
  String sectionId;
  String skillname;

  Skills({
    required this.sectionId,
    required this.skillname,
  });

  factory Skills.createEmpty() {
    return Skills(
      sectionId: uuid.v4(),
      skillname: 'TEST',
    );
  }

  factory Skills.fromJson(Map<String, dynamic> json) => new Skills(
        sectionId: json["sectionId"],
        skillname: json["skillname"],
      );

  Map<String, dynamic> toJson() => {
        "sectionId": sectionId,
        "skillname": skillname,
      };
}

class Pdf {
  List<Educations> educations;
  List<Experiences> experiences;
  List<Skills> skills;
  List<Links> links;
  Map<String, dynamic> personaldetail;
  Pdf({
    required this.personaldetail,
    required this.links,
    required this.educations,
    required this.experiences,
    required this.skills,
  });

  factory Pdf.fromJson(Map<String, dynamic> json) {
    var experiencesList = json['experiences'] as List;
    var educationsList = json['educations'] as List;
    var skillsList = json['skills'] as List;
    var linksList = json['links'] as List;
    List<Educations> educations =
        educationsList.map((i) => Educations.fromJson(i)).toList();
    List<Experiences> experiences =
        experiencesList.map((i) => Experiences.fromJson(i)).toList();
    List<Skills> skills = skillsList.map((i) => Skills.fromJson(i)).toList();
    List<Links> links = linksList.map((i) => Links.fromJson(i)).toList();

    return Pdf(
      personaldetail: json["personaldetails"],
      links: links,
      educations: educations,
      experiences: experiences,
      skills: skills,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["personaldetails"] = personaldetail;
    data["links"] = jsonEncode(links);
    data["educations"] = jsonEncode(educations);
    data["experiences"] = jsonEncode(experiences);
    data["skills"] = jsonEncode(skills);
    return data;
  }
}
