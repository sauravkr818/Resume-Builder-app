import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/resume/widgets/experience.dart';
import 'package:project/resume/widgets/links.dart';
import 'package:project/resume/widgets/skills.dart';
import './widgets/personal_details.dart';
import './widgets/education.dart';
import 'package:project/services/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localstorage/localstorage.dart';
import 'pdf_model.dart';
import 'package:project/widgets/custom_button.dart';

class Resume extends StatefulWidget {
  const Resume({Key? key}) : super(key: key);

  @override
  State<Resume> createState() => _ResumeState();
}

class _ResumeState extends State<Resume> {
  Future saveBio() async {
    final user = FirebaseAuthMethods(FirebaseAuth.instance).user;
    Pdf resume = Pdf(
      personaldetail: LocalStorage('${user.email}').getItem('personaldetail'),
      links: LocalStorage('${user.email}').getItem('links'),
      educations: LocalStorage('${user.email}').getItem('education'),
      experiences: LocalStorage('${user.email}').getItem('experience'),
      skills: LocalStorage('${user.email}').getItem('skills'),
    );
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.email)
        .set(resume.toJson());
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text('Data Added.'),
      action: SnackBarAction(
        label: 'Okay',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resume"),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    PersonalDetails(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Link(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Education(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Experience(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Skill(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    CustomButton(
                      onTap: () {
                        saveBio();
                      },
                      text: 'Save Details',
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Text("Column"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
