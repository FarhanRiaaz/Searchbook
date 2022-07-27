import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:test_app/mobx/user_store.dart';
import 'package:test_app/pages/navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserStore? userStore;

  @override
  void initState() {
    userStore = UserStore();
    super.initState();
  }

  @override
  void didChangeDependencies() {


    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Image.asset(
            "assets/welcome.png",
            fit: BoxFit.fill,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22))),
              color: Colors.white,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: 300,
                    maxHeight: 300,
                    minWidth: 450,
                    maxWidth: 450),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Collect book as you read them,virtually.",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: GoogleFonts.openSans().fontFamily,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Get started",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: GoogleFonts.openSans().fontFamily,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/google.png",
                            width: 25,
                            height: 25,
                          ),
                        ),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            "Continue with Google",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                fontFamily:
                                    GoogleFonts.montserrat().fontFamily),
                          ),
                        ),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0Xff004CFF)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: BorderSide(
                                        color: Colors.black, width: 3)))),
                        onPressed: () async {
                          if (userStore?.currentUser?.displayName == null &&
                              userStore?.user?.id == null) {
                            await userStore?.handleSignIn().then((value) {
                              if (value == 0) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NavigationScreen()));
                              }
                            });
                          }
                          else {
                            print(userStore?.user?.id);
                            print(userStore?.currentUser?.displayName);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NavigationScreen()));
                          }
                        })
                  ],
                ),
              )),
        )
      ],
    );
  }
}
