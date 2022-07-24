import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/pages/abstract/stamp_collection_page_abstract.dart';
import 'package:test_app/pages/formal/book_details_page_formal.dart';
import 'package:test_app/utils/utils.dart';
import 'package:test_app/widgets/stamp.dart';

class StampCollectionFormalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StampCollectionPageFormalState();
}

class _StampCollectionPageFormalState
    extends StampCollectionPageAbstractState<StampCollectionFormalPage> {
  @override
  Widget build(BuildContext context) {
    const textStyle = const TextStyle(
        fontSize: 34.0, fontFamily: 'Butler', fontWeight: FontWeight.w800);

    Widget body;

    if (items.isEmpty) {
      body = Center(child: Text("You have no collection yet"));
    }

    body = GridView.extent(
      maxCrossAxisExtent: 150.0,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      mainAxisSpacing: 20.0,
      children: items
          .map((Book book) => Stamp(
                book.url!,
                width: 105.0,
                onClick: () {
                  Navigator.of(context).push(FadeRoute(
                    builder: (BuildContext context) =>
                        BookDetailsPageFormal(book),
                    settings: RouteSettings(name: '/book_detais_formal'),
                  ));
                },
              ))
          .toList(),
    );

    body = Container(
      padding: const EdgeInsets.all(16.0),
      child: body,
      color: Color(0xFFF5F5F5),
    );

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 80.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "My Stamps",
              style: textStyle.copyWith(
                  fontFamily: GoogleFonts.ibarraRealNova().fontFamily,
                  fontSize: 26),
            ),
          ),
          Expanded(
              child: CustomScrollView(slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate([
              body,
            ]))
          ]))
        ],
      ),
    );
  }
}
