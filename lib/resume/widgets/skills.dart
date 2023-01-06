import 'dart:developer';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../pdf_model.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:async';
import 'package:project/services/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';

Uuid uuid = const Uuid();

class Skill extends StatefulWidget {
  const Skill({Key? key}) : super(key: key);

  @override
  State<Skill> createState() => _SkillState();
}

class _SkillState extends State<Skill> {
  List<Skills> SkillList = <Skills>[];
  void fill() {
    var ski = LocalStorage('${user.email}database').getItem('skills');
    if (ski != null) {
      for (var i in ski) {
        SkillList.add(Skills.fromJson(i));
      }
    }
  }

  late Timer timer;
  final user = FirebaseAuthMethods(FirebaseAuth.instance).user;
  void updateResume() async {
    await LocalStorage('${user.email}').setItem('skills', SkillList);
  }

  @override
  void initState() {
    super.initState();
    fill();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      updateResume();
    });
  }

  void addSkillSection(Skills section) {
    setState(() {
      SkillList.add(section);
      updateResume();
    });
  }

  void removeSkillSection(Skills section) {
    SkillList.remove(section);
    setState(() {
      SkillList;
      updateResume();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("Your Skills",
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
              itemCount: SkillList.length,
              itemBuilder: (context, index) {
                log('$index');
                return Padding(
                  key: Key(SkillList[index].sectionId),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ExpansionSkill(
                    section: SkillList[index],
                    onPressed: () {
                      removeSkillSection(SkillList[index]);
                    },
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 28.0, 0.0),
          child: TextButton.icon(
            onPressed: () {
              addSkillSection(Skills.createEmpty());
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Skill'),
          ),
        )
      ],
    );
  }
}

class ExpansionSkill extends StatefulWidget {
  const ExpansionSkill({
    Key? key,
    required this.section,
    required this.onPressed,
    //required this.idx,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Skills section;
  //final int idx;

  @override
  State<ExpansionSkill> createState() => _ExpansionSkillState();
}

class _ExpansionSkillState extends State<ExpansionSkill>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TextEditingController skillController = TextEditingController();
  //text editing controller for text field

  @override
  void initState() {
    skillController.text = ""; //set the initial value of text field
    super.initState();
  }

  Widget build(BuildContext context) {
    String skill = skillController.text.trim();

    skillController.text = widget.section.skillname;
    skillController.selection = TextSelection(
        baseOffset: (widget.section.skillname).length,
        extentOffset: (widget.section.skillname).length);
    skill = widget.section.skillname;

    return ExpansionTile(
      title: (skill == "") ? const Text('Test') : Text(skill),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 0.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: skillController,
                    onChanged: (txt) {
                      setState(() => skill = txt);
                      setState(() {
                        widget.section.skillname = txt;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Skill Name",
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
          height: 20.0,
        ),
        TextButton.icon(
          onPressed: () => widget.onPressed(),
          icon: Icon(Icons.delete),
          label: Text("Delete this Skill"),
        )
      ],
    );
  }
}
