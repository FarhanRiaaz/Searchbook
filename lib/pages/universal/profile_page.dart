import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app/main.dart';
import 'package:test_app/mobx/user_store.dart';
import 'package:test_app/pages/abstract/profile_page_abstract.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ProfilePageAbstractState {
  UserStore userStore = UserStore();

  @override
  Widget build(BuildContext context) {
    const textStyle = const TextStyle(
        fontSize: 34.0, fontFamily: 'Butler', fontWeight: FontWeight.w800);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80.0,
                ),
                Text(
                  "My Profile",
                  style: textStyle.copyWith(
                      fontFamily: GoogleFonts.ibarraRealNova().fontFamily,
                      fontSize: 26),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Card(
                  color: Color(0XFFF6F6F6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            width: 85.0,
                            height: 85.0,
                            decoration: new BoxDecoration(
                              color: Color(0XFF3B56FF),
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Observer(builder: (context) {
                              return userStore.user?.photoUrl == null
                                  ? Text(
                                      userStore.user?.displayName?.substring(0, 1).toUpperCase() ??
                                          "",
                                      style: TextStyle(
                                          fontSize: 42,
                                          color: Colors.white,
                                          fontFamily: GoogleFonts.openSans()
                                              .fontFamily),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: userStore.user!.photoUrl!,
                                      fit: BoxFit.fill,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            width: 80.0,
                                            height: 80.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator());
                            })),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Observer(builder: (context) {
                              return Text(
                                userStore.user?.displayName?.toUpperCase() ?? "",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.openSans().fontFamily),
                              );
                            }),
                            SizedBox(
                              height: 6,
                            ),
                            Observer(builder: (context) {
                              return Text(
                                "${userStore.user?.email}",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0XFF31A7FB),
                                    fontFamily:
                                        GoogleFonts.openSans().fontFamily),
                              );
                            }),
                          ],
                        ),
                      )
                    ],
                  ),
                  elevation: 4,
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: 180,
                            minWidth: 160,
                            maxHeight: 160,
                            minHeight: 160),
                        child: Card(
                          color: Color(0XFFF6F6F6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(26.0),
                                  child: Center(
                                      child: Text(
                                    "$count",
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontFamily:
                                            GoogleFonts.openSans().fontFamily),
                                  )),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  "Books reading",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontFamily:
                                          GoogleFonts.openSans().fontFamily),
                                ),
                              )
                            ],
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 5,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: 180,
                            minWidth: 160,
                            maxHeight: 160,
                            minHeight: 160),
                        child: Card(
                          color: Color(0XFFF6F6F6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(26.0),
                                  child: Center(
                                      child: Text(
                                    "$count",
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontFamily:
                                            GoogleFonts.openSans().fontFamily),
                                  )),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  "Stamp collected",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontFamily:
                                          GoogleFonts.openSans().fontFamily),
                                ),
                              )
                            ],
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 36.0),
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0XFFFB4A59)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  icon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/logout.png",
                      height: 16,
                      width: 16,
                    ),
                  ),
                  label: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Logout"),
                  ),
                  onPressed: () async {
                    await userStore.handleSignOut().then((value) {
                      Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
                    });

                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
