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

class Link extends StatefulWidget {
  const Link({Key? key}) : super(key: key);

  @override
  State<Link> createState() => _LinkState();
}

class _LinkState extends State<Link> {
  List<Links> linkList = <Links>[];
  void fill() {
    var lin = LocalStorage('${user.email}database').getItem('links');
    if (lin != null) {
      for (var i in lin) {
        linkList.add(Links.fromJson(i));
      }
    }
  }

  late Timer timer;
  final user = FirebaseAuthMethods(FirebaseAuth.instance).user;

  void updateResume() async {
    await LocalStorage('${user.email}').setItem('links', linkList);
  }

  @override
  void initState() {
    super.initState();
    fill();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      updateResume();
    });
  }

  void addLinkSection(Links section) {
    setState(() {
      linkList.add(section);
      updateResume();
    });
  }

  void removeLinkSection(Links section) {
    linkList.remove(section);
    setState(() {
      linkList;
      updateResume();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("Your Links",
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
              itemCount: linkList.length,
              itemBuilder: (context, index) {
                log('$index');
                return Padding(
                  key: Key(linkList[index].sectionId),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ExpansionLink(
                    section: linkList[index],
                    onPressed: () {
                      removeLinkSection(linkList[index]);
                    },
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 28.0, 0.0),
          child: TextButton.icon(
            onPressed: () {
              addLinkSection(Links.createEmpty());
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Link'),
          ),
        )
      ],
    );
  }
}

class ExpansionLink extends StatefulWidget {
  const ExpansionLink({
    Key? key,
    required this.section,
    required this.onPressed,
    //required this.idx,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Links section;
  //final int idx;

  @override
  State<ExpansionLink> createState() => _ExpansionLinkState();
}

class _ExpansionLinkState extends State<ExpansionLink>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TextEditingController LinknameController = TextEditingController();
  TextEditingController LinkurlController = TextEditingController();
  //text editing controller for text field

  @override
  void initState() {
    LinknameController.text = "";
    LinkurlController.text = ""; //set the initial value of text field
    super.initState();
  }

  Widget build(BuildContext context) {
    String Linkname = LinknameController.text.trim();
    String Linkurl = LinknameController.text.trim();

    LinknameController.text = widget.section.linkname;
    LinknameController.selection = TextSelection(
        baseOffset: (widget.section.linkname).length,
        extentOffset: (widget.section.linkname).length);
    Linkname = widget.section.linkname;

    LinkurlController.text = widget.section.linkurl;
    LinkurlController.selection = TextSelection(
        baseOffset: (widget.section.linkurl).length,
        extentOffset: (widget.section.linkurl).length);
    Linkurl = widget.section.linkurl;
    return ExpansionTile(
      title: (Linkname == "") ? const Text('Test') : Text(Linkname),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 0.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: LinknameController,
                    onChanged: (txt) {
                      setState(() => Linkname = txt);
                      setState(() {
                        widget.section.linkname = txt;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Link Name",
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
                    controller: LinkurlController,
                    onChanged: (txt) {
                      setState(() => Linkurl = txt);
                      setState(() {
                        widget.section.linkurl = txt;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Link URL",
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
          label: Text("Delete this Link"),
        )
      ],
    );
  }
}
