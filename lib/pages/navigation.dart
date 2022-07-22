import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/pages/formal/search_book_page_formal.dart';
import 'package:test_app/pages/formal/stamp_collection_page_formal.dart';
import 'package:test_app/pages/material/search_book_page_material.dart';
import 'package:test_app/utils/index_offset_curve.dart';
import 'package:test_app/widgets/chips_widget.dart';
import 'package:test_app/widgets/collection_preview.dart';

import '../model/categories.dart';

class NavigationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with SingleTickerProviderStateMixin {
  static AnimationController? cardsFirstOpenController;
  static List<Category>? category = [
    Category(
      title: "Fiction",
      isChecked: true,
    ),
    Category(
      title: "Non-Fiction",
    ),
    Category(
      title: "Mystery",
    ),
    Category(
      title: "Thriller",
    ),
  ];
  String interfaceType = "formal";
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  static List<Widget> _widgetOptions = <Widget>[
    BookScreen("formal", cardsFirstOpenController!, category),
    SearchBookPageNew(),
    StampCollectionFormalPage(),
    SearchBookPage(),
  ];

  bool init = true;

  @override
  void initState() {
    super.initState();
    cardsFirstOpenController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1300));

    print("we are here ${category?.length}");
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
                  backgroundColor: Colors.pink.shade300,
                ),
                GButton(
                  icon: Icons.explore,
                  text: 'Explore',
                  backgroundColor: Colors.blue.shade300,
                ),
                GButton(
                  icon: LineIcons.stamp,
                  text: 'My Stamps',
                  backgroundColor: Colors.deepPurpleAccent.shade100,
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                  backgroundColor: Colors.amber.shade300,
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

class BookScreen extends StatelessWidget {
  BookScreen(this.interfaceType, this.cardFirstOpenController, this.dataList,
      {Key? key})
      : super(key: key);

  String interfaceType;
  List<Category>? dataList;
  AnimationController cardFirstOpenController;

  @override
  Widget build(BuildContext context) {
    const textStyle = const TextStyle(
        fontSize: 22.0, fontFamily: 'CrimsonText', fontWeight: FontWeight.w800);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 60,
        ),
        Icon(
          Icons.sticky_note_2_outlined,
          size: 70,
        ),
        Expanded(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                  delegate: SliverChildListDelegate(
                [
                  wrapInAnimation(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Hello, Usman!",
                          style: textStyle.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 32),
                        ),
                      ),
                      0),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "Search your favourite book",
                                hintStyle: TextStyle(color: Colors.black26),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.search),
                                ),
                                border: InputBorder.none),
                            onChanged: (string) => () {},
                          ),
                        )),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Popular Genre",
                      style: textStyle,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  getGridForCategories(),
                  SizedBox(height: 16.0),
                  wrapInAnimation(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Top books",
                          style: textStyle,
                        ),
                      ),
                      0),
                  wrapInAnimation(
                      collectionPreview(Color(0xffffffff), "Biographies", [
                        "wO3PCgAAQBAJ",
                        "_LFSBgAAQBAJ",
                        "8U2oAAAAQBAJ",
                        "yG3PAK6ZOucC",
                      ]),
                      1),
                  wrapInAnimation(
                      collectionPreview(Color(0xffffffff), "Fiction", [
                        "OsUPDgAAQBAJ",
                        "3e-dDAAAQBAJ",
                        "-ITZDAAAQBAJ",
                        "rmBeDAAAQBAJ",
                        "vgzJCwAAQBAJ",
                      ]),
                      2),
                  wrapInAnimation(
                      collectionPreview(Color(0xffffffff), "Mystery & Thriller",
                          ["1Y9gDQAAQBAJ", "Pz4YDQAAQBAJ", "UXARDgAAQBAJ"]),
                      3),
                  wrapInAnimation(
                      collectionPreview(Color(0xffffffff), "Sience Ficition", [
                        "JMYUDAAAQBAJ",
                        "PzhQydl-QD8C",
                        "nkalO3OsoeMC",
                        "VO8nDwAAQBAJ",
                        "Nxl0BQAAQBAJ"
                      ]),
                      4),
                ],
              ))
            ],
          ),
        ),
      ],
    );
  }

  Widget wrapInAnimation(Widget child, int index) {
    Animation<double> offsetAnimation = CurvedAnimation(
        parent: cardFirstOpenController, curve: IndexOffsetCurve(index));
    Animation<double> fade =
        CurvedAnimation(parent: offsetAnimation, curve: Curves.ease);
    return SlideTransition(
        position: Tween<Offset>(begin: Offset(0.5, 0.0), end: Offset(0.0, 0.0))
            .animate(fade),
        child: FadeTransition(
          opacity: fade,
          child: child,
        ));
  }

  Widget collectionPreview(Color color, String name, List<String> ids) {
    return FutureBuilder<List<Book>>(
      future: Repository.get().getBooksByIdFirstFromDatabaseAndCache(ids),
      builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
        List<Book> books = [];
        if (snapshot.data != null) books = snapshot.data!;
        return CollectionPreview(
          books: books,
          color: color,
          title: name,
          loading: snapshot.data == null,
        );
      },
    );
  }

  Widget getGridForCategories() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: dataList!.map((e) {
            return ChipsWidget(e, () {});
          }).toList())),
    );
  }
}
