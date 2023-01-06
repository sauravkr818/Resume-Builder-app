import 'dart:developer';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:localstorage/localstorage.dart';
import '../pdf_model.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:project/services/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';

Uuid uuid = const Uuid();

class Experience extends StatefulWidget {
  const Experience({Key? key}) : super(key: key);

  @override
  State<Experience> createState() => _ExperienceState();
}

class _ExperienceState extends State<Experience> {
  List<Experiences> experienceList = <Experiences>[];
  void fill() {
    var exp = LocalStorage('${user.email}database').getItem('experience');
    if (exp != null) {
      for (var i in exp) {
        experienceList.add(Experiences.fromJson(i));
      }
    }
  }

  late Timer timer;
  final user = FirebaseAuthMethods(FirebaseAuth.instance).user;
  void updateResume() async {
    await LocalStorage('${user.email}').setItem('experience', experienceList);
  }

  @override
  void initState() {
    super.initState();
    fill();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      updateResume();
    });
  }

  void addExperienceSection(Experiences section) {
    setState(() {
      experienceList.add(section);
      updateResume();
    });
  }

  void removeExperienceSection(Experiences section) {
    experienceList.remove(section);
    setState(() {
      experienceList;
      updateResume();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("Experience",
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
              itemCount: experienceList.length,
              itemBuilder: (context, index) {
                log('$index');
                return Padding(
                  key: Key(experienceList[index].sectionId),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ExpansionExperience(
                    section: experienceList[index],
                    onPressed: () {
                      removeExperienceSection(experienceList[index]);
                    },
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 28.0, 0.0),
          child: TextButton.icon(
            onPressed: () {
              addExperienceSection(Experiences.createEmpty());
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Experience'),
          ),
        )
      ],
    );
  }
}

class ExpansionExperience extends StatefulWidget {
  const ExpansionExperience({
    Key? key,
    required this.section,
    required this.onPressed,
    //required this.idx,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Experiences section;
  //final int idx;

  @override
  State<ExpansionExperience> createState() => _ExpansionExperienceState();
}

class _ExpansionExperienceState extends State<ExpansionExperience>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TextEditingController jobtitleController = TextEditingController();
  TextEditingController employerController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  //text editing controller for text field

  @override
  void initState() {
    startDateController.text = ""; //set the initial value of text field
    super.initState();
  }

  Widget build(BuildContext context) {
    String jobtitle = jobtitleController.text.trim();
    String employer = employerController.text.trim();
    String startDate = startDateController.text.trim();
    String endDate = endDateController.text.trim();
    String city = cityController.text.trim();

    jobtitleController.text = widget.section.jobtitle;
    jobtitleController.selection = TextSelection(
        baseOffset: (widget.section.jobtitle).length,
        extentOffset: (widget.section.jobtitle).length);
    jobtitle = widget.section.jobtitle;

    cityController.text = widget.section.city;
    cityController.selection = TextSelection(
        baseOffset: (widget.section.city).length,
        extentOffset: (widget.section.city).length);
    city = widget.section.city;

    employerController.text = widget.section.employer;
    employerController.selection = TextSelection(
        baseOffset: (widget.section.employer).length,
        extentOffset: (widget.section.employer).length);
    employer = widget.section.employer;

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
      title:
          (jobtitle == "") ? const Text('Untitled jobtitle') : Text(jobtitle),
      subtitle:
          (employer == "") ? const Text('Untitled employer') : Text(employer),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 0.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: jobtitleController,
                    onChanged: (txt) {
                      setState(() => jobtitle = txt);
                      setState(() {
                        widget.section.jobtitle = txt;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "jobtitle",
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
                    controller: employerController,
                    onChanged: (txt) {
                      setState(() => employer = txt);
                      setState(() {
                        widget.section.employer = txt;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "employer",
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
                    controller: cityController,
                    onChanged: (txt) {
                      setState(() => city = txt);
                      setState(() {
                        widget.section.city = txt;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'city',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5.0,
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
          label: Text("Delete this Experience"),
        )
      ],
    );
  }
}
