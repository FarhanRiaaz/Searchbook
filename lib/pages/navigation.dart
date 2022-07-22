import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/mobx/book_store.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/model/categories.dart';
import 'package:test_app/pages/formal/search_book_page_formal.dart';
import 'package:test_app/pages/formal/stamp_collection_page_formal.dart';
import 'package:test_app/pages/material/search_book_page_material.dart';
import 'package:test_app/utils/index_offset_curve.dart';
import 'package:test_app/widgets/chips_widget.dart';
import 'package:test_app/widgets/collection_preview.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class NavigationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with SingleTickerProviderStateMixin {
  static AnimationController? cardsFirstOpenController;

  String interfaceType = "formal";
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  static List<Widget> _widgetOptions = <Widget>[
    BookScreen("formal", cardsFirstOpenController!),
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
                  backgroundColor: Colors.pink.shade200,
                ),
                GButton(
                  icon: Icons.explore,
                  text: 'Explore',
                  backgroundColor: Colors.blue.shade200,
                ),
                GButton(
                  icon: LineIcons.stamp,
                  text: 'My Stamps',
                  backgroundColor: Colors.purple.shade100,
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                  backgroundColor: Colors.amber.shade100,
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

class BookScreen extends StatefulWidget {
  BookScreen(this.interfaceType, this.cardFirstOpenController, {Key? key})
      : super(key: key);

  String interfaceType;
  AnimationController? cardFirstOpenController;
  static Repository repository = Repository.get();

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  BookStore bookStore = BookStore();

  @override
  Widget build(BuildContext context) {
    const textStyle = const TextStyle(
        fontSize: 22.0, fontFamily: 'CrimsonText', fontWeight: FontWeight.w800);
    return Observer(builder: (context) {
      bookStore.category;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
          ),
          ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: 80, maxWidth: 100, minHeight: 50, minWidth: 100),
              child: CachedNetworkImage(
                  imageUrl:
                      "https://cdn1.iconfinder.com/data/icons/online-education-indigo-vol-2/256/Know_-_How-512.png")),
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
                    _buildExpandable(),
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
                        collectionPreview(
                            Color(0xffffffff),
                            "Mystery & Thriller",
                            ["1Y9gDQAAQBAJ", "Pz4YDQAAQBAJ", "UXARDgAAQBAJ"]),
                        3),
                    wrapInAnimation(
                        collectionPreview(
                            Color(0xffffffff), "Sience Ficition", [
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
    });
  }

  Widget wrapInAnimation(Widget child, int index) {
    Animation<double> offsetAnimation = CurvedAnimation(
        parent: widget.cardFirstOpenController!,
        curve: IndexOffsetCurve(index));
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
              children: bookStore.category.map((e) {
            return Observer(builder: (context) {
              bookStore.category;
              return ChipsWidget(e, () {
                bookStore.updateCurrentCategory(e);
              },
                  bookStore.currentCategory == e
                      ? Colors.blue.shade500
                      : Colors.white);
            });
          }).toList())),
    );
  }

  Widget getExpandedCategories(List<Category> categories) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: categories.map((e) {
            return Observer(builder: (context) {
              bookStore.allCategories;
              return ChipsWidget(e, () {
                bookStore.updateCurrentCategory(e);
              },
                  bookStore.currentCategory == e
                      ? Colors.blue.shade500
                      : Colors.white);
            });
          }).toList())),
    );
  }

  _buildExpandable() {
    return ExpandableNotifier(
      child: Expandable(
        collapsed: Row(
          children: [
            getExpandedCategories(bookStore.allCategories.sublist(0, 3)),
            Padding(
              padding: const EdgeInsets.only(right: 24.0, top: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: ExpandableButton(
                  child: Text(
                    "See all >",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        expanded: Column(children: [
          getExpandedCategories(bookStore.allCategories.sublist(0, 3)),
          getExpandedCategories(bookStore.allCategories.sublist(3, 7)),
          getExpandedCategories(bookStore.allCategories.sublist(7, 9)),
          Padding(
            padding: const EdgeInsets.only(right: 24.0, top: 8),
            child: Align(
                alignment: Alignment.centerRight,
                child: ExpandableButton(
                    child: Icon(
                  Icons.cancel_rounded,
                  color: Colors.blue,
                ))),
          )
        ]),
      ),
    );
  }
}
