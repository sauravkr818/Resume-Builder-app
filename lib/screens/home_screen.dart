import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/firebase_options.dart';
import 'package:project/services/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import '../resume/resume_maker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import './user_profile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final double coverHeight = 280;

  final double profileHeight = 144;

  List<dynamic> educationList = <dynamic>[];

  List<dynamic> experienceList = <dynamic>[];

  List<dynamic> skillsList = <dynamic>[];

  List<dynamic> linksList = <dynamic>[];

  Map<String, dynamic> ans = new Map<String, dynamic>();

  void saveBio() async {
    final user = FirebaseAuthMethods(FirebaseAuth.instance).user;
    final docRef =
        FirebaseFirestore.instance.collection("users").doc(user.email);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

        setState(() {
          ans = data;
          educationList = (jsonDecode(data['educations']));
          experienceList = (jsonDecode(data['experiences']));
          skillsList = (jsonDecode(data['skills']));
          linksList = (jsonDecode(data['links']));
          WidgetsFlutterBinding.ensureInitialized();
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  User user = FirebaseAuthMethods(FirebaseAuth.instance).user;

  // WidgetsBinding.instance.addPostFrameCallback((_) => saveBio(context));

  @override
  void initState() {
    super.initState();
    setState(() {
      user = FirebaseAuthMethods(FirebaseAuth.instance).user;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final user = FirebaseAuthMethods(FirebaseAuth.instance).user;
    final email = user.email;
    final name = user.displayName;
    final Image = user.photoURL;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.home),
        ),
        title: Text('Hello $name'),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                fixedSize: Size.fromHeight(10),
                textStyle: TextStyle(color: Colors.blue),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onPressed: () =>
                  {FirebaseAuthMethods(FirebaseAuth.instance).signOut(context)},
              icon: Icon(
                Icons.logout,
              ),
              label: Text(
                'SignOut',
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    //                   <--- left side
                    color: Colors.grey,
                  ),
                ),
              ),
              width: MediaQuery.of(context).size.width * 0.25,
              //height: MediaQuery.of(context).size.height*0.50,

              child: Column(
                children: <Widget>[
                  buildTop(),
                  UserInformation(user: user),
                  buildContent(),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.65,
                //height: MediaQuery.of(context).size.height*0.50,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (!user.emailVerified && !user.isAnonymous)
                                  CustomButton(
                                    onTap: () {
                                      FirebaseAuthMethods(FirebaseAuth.instance)
                                          .sendEmailVerification(context);
                                    },
                                    text: 'Email not verified!   Verify Email',
                                  ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => Resume()));
                                  },
                                  child: Text(" Edit Resume Details"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     CupertinoPageRoute(
                                    //         builder: (context) => PdfPage()));
                                    Navigator.pushNamed(
                                        context, '/resume/$email');
                                  },
                                  child: Text("View Resume"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        UserProfile(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text('Help'),
        backgroundColor: Colors.red[600],
      ),
    );
  }
}

final double coverHeight = 280;

final double profileHeight = 144;

class buildCoverImage extends StatefulWidget {
  const buildCoverImage({Key? key}) : super(key: key);

  @override
  State<buildCoverImage> createState() => _buildCoverImageState();
}

class _buildCoverImageState extends State<buildCoverImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        child: Image.network(
          'https://media.istockphoto.com/photos/dark-blue-grunge-background-picture-id170958625?b=1&k=20&m=170958625&s=170667a&w=0&h=xG_DER6VK7CEXuPh0TUQu7H_xqlF_LZ0uNgumm40ylw=',
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ));
  }
}

class buildProfileImage extends StatefulWidget {
  const buildProfileImage({Key? key}) : super(key: key);

  @override
  State<buildProfileImage> createState() => _buildProfileImageState();
}

class _buildProfileImageState extends State<buildProfileImage> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: NetworkImage(
            'https://media-exp2.licdn.com/dms/image/C560BAQH_1D47hfHBCQ/company-logo_200_200/0/1622694492980?e=1663200000&v=beta&t=Wry9l_63x5JajM2ZflulafSYvuhhKtqeYlM03RDwG60'));
  }
}

class buildTop extends StatefulWidget {
  const buildTop({Key? key}) : super(key: key);

  @override
  State<buildTop> createState() => _buildTopState();
}

class _buildTopState extends State<buildTop> {
  @override
  Widget build(BuildContext context) {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
        ),
        Positioned(top: top, child: buildProfileImage()),
      ],
    );
  }
}

class buildContent extends StatefulWidget {
  const buildContent({Key? key}) : super(key: key);

  @override
  State<buildContent> createState() => _buildContentState();
}

class _buildContentState extends State<buildContent> {
  @override
  Widget build(BuildContext context) {
    return (Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildIcon(icon: FontAwesomeIcons.facebook),
              buildIcon(icon: FontAwesomeIcons.instagram),
              buildIcon(icon: FontAwesomeIcons.twitter),
              buildIcon(icon: FontAwesomeIcons.linkedin),
            ],
          )
        ],
      ),
    ));
  }
}

class buildIcon extends StatefulWidget {
  final IconData icon;
  buildIcon({Key? key, required this.icon}) : super(key: key);

  @override
  State<buildIcon> createState() => _buildIconState();
}

class _buildIconState extends State<buildIcon> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 25,
        child: Material(
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              child: Center(
                child: Icon(widget.icon, size: 32),
              ),
            )));
  }
}

class UserInformation extends StatefulWidget {
  final User user;
  const UserInformation({Key? key, required this.user}) : super(key: key);

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  @override
  Widget build(BuildContext context) {
    String? profilePic = widget.user.photoURL;
    bool isPicNull = profilePic == null;
    String? email = widget.user.email;
    String? name = widget.user.displayName;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: NetworkImage(profilePic!),
              //   fit: BoxFit.contain,
              // ),
              ),
          child: isPicNull == true
              ? Center(
                  child: Text(
                    email!.substring(0, 1).toUpperCase(),
                  ),
                )
              : null,
        ),
        const SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name!,
            ),
            Text(
              email!,
            )
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
