import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../pdf_model.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:project/services/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';

Uuid uuid = const Uuid();

class Education extends StatefulWidget {
  const Education({Key? key}) : super(key: key);

  @override
  State<Education> createState() => _EducationState();
}

class _EducationState extends State<Education> {
  final user = FirebaseAuthMethods(FirebaseAuth.instance).user;

  List<Educations> educationList = <Educations>[];
  void fill() {
    var edu = LocalStorage('${user.email}database').getItem('education');
    if (edu != null) {
      for (var i in edu) {
        educationList.add(Educations.fromJson(i));
      }
    }
  }

  late Timer timer;

  void addEducationSection(Educations section) {
    setState(() {
      educationList.add(section);
      updateResume();
    });
  }

  void removeEducationSection(Educations section) {
    educationList.remove(section);
    setState(() {
      educationList;
      updateResume();
    });
  }

  void updateResume() async {
    await LocalStorage('${user.email}').setItem('education', educationList);
  }

  @override
  void initState() {
    super.initState();
    fill();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      updateResume();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("Education",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            )),
        const SizedBox(
          height: 20.0,
        ),
        Flexible(
          fit: FlexFit.loose,
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: educationList.length,
              itemBuilder: (context, index) {
                log('$index');
                return Padding(
                  key: Key(educationList[index].sectionId),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ExpansionEducation(
                    section: educationList[index],
                    onPressed: () {
                      removeEducationSection(educationList[index]);
                    },
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 28.0, 0.0),
          child: TextButton.icon(
            onPressed: () {
              addEducationSection(Educations.createEmpty());
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Education'),
          ),
        )
      ],
    );
  }
}

class ExpansionEducation extends StatefulWidget {
  const ExpansionEducation({
    Key? key,
    required this.section,
    required this.onPressed,
    //required this.idx,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Educations section;
  //final int idx;

  @override
  State<ExpansionEducation> createState() => _ExpansionEducationState();
}

class _ExpansionEducationState extends State<ExpansionEducation>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TextEditingController schoolController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController gpaController = TextEditingController();
  //text editing controller for text field

  @override
  void initState() {
    startDateController.text = ""; //set the initial value of text field
    super.initState();
  }

  Widget build(BuildContext context) {
    String school = schoolController.text.trim();
    String degree = degreeController.text.trim();
    String course = courseController.text.trim();
    String gpa = gpaController.text.trim();
    String startDate = startDateController.text.trim();
    String endDate = endDateController.text.trim();

    schoolController.text = widget.section.universityName;
    schoolController.selection = TextSelection(
        baseOffset: (widget.section.universityName).length,
        extentOffset: (widget.section.universityName).length);
    school = widget.section.universityName;

    courseController.text = widget.section.courseTaken;
    courseController.selection = TextSelection(
        baseOffset: (widget.section.courseTaken).length,
        extentOffset: (widget.section.courseTaken).length);
    course = widget.section.courseTaken;

    gpaController.text = widget.section.gpa;
    gpaController.selection = TextSelection(
        baseOffset: (widget.section.gpa).length,
        extentOffset: (widget.section.gpa).length);
    gpa = widget.section.gpa;

    degreeController.text = widget.section.degree;
    degreeController.selection = TextSelection(
        baseOffset: (widget.section.degree).length,
        extentOffset: (widget.section.degree).length);
    degree = widget.section.degree;

    startDateController.text = widget.section.startDate;
    startDateController.selection = TextSelection(
        baseOffset: (widget.section.startDate).length,
        extentOffset: (widget.section.startDate).length);
    startDate = widget.section.startDate;

    endDateController.text = widget.section.endDate;
    endDateController.selection = TextSelection(
        baseOffset: (widget.section.endDate).length,
        extentOffset: (widget.section.endDate).length);
    endDate = widget.section.endDate;

    return ExpansionTile(
      title: (school == "") ? const Text('Untitled School') : Text(school),
      subtitle: (degree == "")
          ? const Text('Untitled Degree - Untitled Course')
          : Text('$degree - $course'),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 0.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: schoolController,
                    onChanged: (txt) {
                      setState(() => school = txt);
                      setState(() {
                        widget.section.universityName = txt;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "School",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: degreeController,
                    onChanged: (txt) {
                      setState(() => degree = txt);
                      setState(() {
                        widget.section.degree = txt;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Degree",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 0.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: courseController,
                    onChanged: (txt) {
                      setState(() => course = txt);
                      setState(() {
                        widget.section.courseTaken = txt;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Course',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: gpaController,
                    onChanged: (txt) {
                      setState(() => gpa = txt);
                      setState(() {
                        widget.section.gpa = txt;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "GPA",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20.0, 20.0, 0.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: startDateController,
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2015, 8),
                                lastDate: DateTime(2101));
                            if (picked != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(picked);
                              setState(() {
                                widget.section.startDate = formattedDate;
                                startDate = formattedDate;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "Start Date",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: endDateController,
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2015, 8),
                                lastDate: DateTime(2101));
                            if (picked != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(picked);
                              setState(() {
                                widget.section.endDate = formattedDate;
                                endDate = formattedDate;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "End Date",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    //controller: nameController,
                    decoration: InputDecoration(
                      labelText: "City",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        TextButton.icon(
          onPressed: () => widget.onPressed(),
          icon: Icon(Icons.delete),
          label: Text("Delete this education"),
        )
      ],
    );
  }
}
