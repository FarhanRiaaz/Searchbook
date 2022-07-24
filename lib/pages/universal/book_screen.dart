import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/mobx/book_store.dart';
import 'package:test_app/model/categories.dart';
import 'package:test_app/pages/abstract/search_book_page_abstract.dart';
import 'package:test_app/pages/formal/book_details_page_formal.dart';
import 'package:test_app/utils/index_offset_curve.dart';
import 'package:test_app/utils/utils.dart';
import 'package:test_app/widgets/chips_widget.dart';
import 'package:test_app/widgets/collection_preview.dart';
import 'package:test_app/widgets/stamp.dart';

import '../../model/Book.dart';

class BookScreen extends StatefulWidget {
  BookScreen(this.interfaceType, this.cardFirstOpenController, {Key? key})
      : super(key: key);

  String interfaceType;
  AnimationController? cardFirstOpenController;
  static Repository repository = Repository.get();

  @override
  _BookScreenStateNew createState() => _BookScreenStateNew();
}

class _BookScreenStateNew extends AbstractSearchBookState<BookScreen> {
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
              child: Image.asset(
                "assets/stamp.png",
                height: 250,
                width: 250,
              )),
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
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                                fontFamily:
                                    GoogleFonts.ibarraRealNova().fontFamily),
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
                                  hintStyle: TextStyle(
                                      color: Colors.black26,
                                      fontFamily: GoogleFonts.ibarraRealNova()
                                          .fontFamily,
                                      fontSize: 14),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.search),
                                  ),
                                  border: InputBorder.none),
                              onChanged: (string) => (subject.add(string)),
                            ),
                          )),
                    ),
                    SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        bookStore.currentCategory?.title == null
                            ? "Popular Genre"
                            : bookStore.currentCategory!.title!,
                        style: textStyle.copyWith(
                            fontFamily:
                                GoogleFonts.ibarraRealNova().fontFamily),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    getGridForCategories(),
                    _buildExpandable(),
                    items.isNotEmpty
                        ? GridView.extent(
                            padding: EdgeInsets.zero,
                            maxCrossAxisExtent: 150,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            children: items
                                .map((Book book) => Padding(
                                      padding: const EdgeInsets.only(top:8.0,bottom:16.0,left: 24.0,right: 24.0),
                                      child: Stamp(
                                        book.url!,
                                        width: 105.0,
                                        onClick: () {
                                          Navigator.of(context).push(FadeRoute(
                                            builder: (BuildContext context) =>
                                                Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child:
                                                  BookDetailsPageFormal(book),
                                            ),
                                            settings: RouteSettings(
                                                name: '/book_detais_formal'),
                                          ));
                                        },
                                      ),
                                    ))
                                .toList(),
                          )
                        : SizedBox.shrink(),
                    items.isEmpty && isLoading == false
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                wrapInAnimation(
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(
                                        "Top books",
                                        style: textStyle.copyWith(
                                            fontFamily:
                                                GoogleFonts.ibarraRealNova()
                                                    .fontFamily),
                                      ),
                                    ),
                                    0),
                                wrapInAnimation(
                                    collectionPreview(
                                        Color(0xffffffff), "Biographies", [
                                      "wO3PCgAAQBAJ",
                                      "_LFSBgAAQBAJ",
                                      "8U2oAAAAQBAJ",
                                      "yG3PAK6ZOucC",
                                    ]),
                                    1),
                                wrapInAnimation(
                                    collectionPreview(
                                        Color(0xffffffff), "Fiction", [
                                      "OsUPDgAAQBAJ",
                                      "3e-dDAAAQBAJ",
                                      "-ITZDAAAQBAJ",
                                      "rmBeDAAAQBAJ",
                                      "vgzJCwAAQBAJ",
                                    ]),
                                    2),
                                wrapInAnimation(
                                    collectionPreview(Color(0xffffffff),
                                        "Mystery & Thriller", [
                                      "1Y9gDQAAQBAJ",
                                      "Pz4YDQAAQBAJ",
                                      "UXARDgAAQBAJ"
                                    ]),
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
                              ])
                        : isLoading == true
                            ? Column(
                                children: [
                                  SizedBox(height: 100),
                                  Center(
                                    child: CircularProgressIndicator(),
                                  )
                                ],
                              )
                            : SizedBox.shrink(),
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
        if (snapshot.data != null) bookStore.loadedBooks = snapshot.data!;
        return CollectionPreview(
          books: bookStore.books,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: bookStore.category.map((e) {
                return Observer(builder: (context) {
                  bookStore.category;
                  return ChipsWidget(e, () {
                    bookStore.updateCurrentCategory(e);
                    subject.add(e.title!);
                  },
                      bookStore.currentCategory == e
                          ? Color(0xff31A7FB)
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: categories.map((e) {
                return Observer(builder: (context) {
                  bookStore.allCategories;
                  return ChipsWidget(e, () {
                    bookStore.updateCurrentCategory(e);
                    subject.add(e.title!);
                  },
                      bookStore.currentCategory == e
                          ? Color(0xff31A7FB)
                          : Colors.white);
                });
              }).toList())),
    );
  }

  _buildExpandable() {
    return ExpandableNotifier(
      child: Expandable(
        collapsed: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getExpandedCategories(bookStore.allCategories.sublist(0, 2)),
            Padding(
              padding: const EdgeInsets.only(right: 24.0, top: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: ExpandableButton(
                  child: Text(
                    "See all >",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontFamily: GoogleFonts.ibarraRealNova().fontFamily,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        expanded: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              getExpandedCategories(bookStore.allCategories.sublist(0, 3)),
              getExpandedCategories(bookStore.allCategories.sublist(3, 6)),
              getExpandedCategories(bookStore.allCategories.sublist(6, 9)),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: ExpandableButton(
                        child: Icon(
                      Icons.keyboard_arrow_up,
                    ))),
              )
            ]),
      ),
    );
  }
}
