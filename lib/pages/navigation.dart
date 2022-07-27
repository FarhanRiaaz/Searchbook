import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/mobx/user_store.dart';
import 'package:test_app/pages/formal/search_book_page_formal.dart';
import 'package:test_app/pages/formal/stamp_collection_page_formal.dart';
import 'package:test_app/pages/universal/book_screen.dart';
import 'package:test_app/pages/universal/profile_page.dart';

class NavigationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with SingleTickerProviderStateMixin {
  static AnimationController? cardsFirstOpenController;
  UserStore userStore = UserStore();


  String interfaceType = "formal";
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    BookScreen("formal", cardsFirstOpenController!),
    SearchBookPageNew(),
    StampCollectionFormalPage(),
    ProfilePage(),
  ];

  bool init = true;

  @override
  void initState() {
    super.initState();
    cardsFirstOpenController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1300));
  }

  @override
  Future<void> didChangeDependencies() async {
    await Repository.get().init().then((it) {
      setState(() {
        init = false;
      });
    });
    cardsFirstOpenController?.forward(from: 0.2);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    cardsFirstOpenController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 6,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 100),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                  textStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                  backgroundColor: Color(0xffFC92AF),
                  leading: Image.asset(
                    "assets/nav.png",
                      height:24,
                    width: 24,
                  ),
                ),
                GButton(
                  icon: Icons.explore,
                  text: 'Explore',
                  textStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                  backgroundColor: Color(0xff6E8BFF),
                  leading: Image.asset(
                    "assets/exp.png",
                    height:24,
                    width: 24,
                  ),
                ),
                GButton(
                  icon: Icons.airplane_ticket,
                  text: 'My Stamp',
                  textStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                  backgroundColor: Color(0xffB86AEC),
                  leading: Image.asset(
                    "assets/stamp.png",
                    height:24,
                    width: 24,
                  ),
                ),
                GButton(
                  icon: Icons.verified_user,
                  text: 'Profile',
                  textStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                  backgroundColor: Color(0xffFFB95D),
                  leading: Image.asset(
                    "assets/prof.png",
                    height:24,
                    width: 24,
                  ),
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
