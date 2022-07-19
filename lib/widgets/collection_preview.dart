
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/pages/formal/book_details_page_formal.dart';
import 'package:test_app/utils/utils.dart';
import 'package:test_app/widgets/stamp.dart';



class CollectionPreview extends StatefulWidget {



  final List<Book> books;

  final Color color;

  final String title;


  final bool loading;

  CollectionPreview({this.color = Colors.white, required this.title, required this.books, this.loading = false});

  @override
  State<StatefulWidget> createState() =>  _CollectionPreviewState();

}


class _CollectionPreviewState extends State<CollectionPreview> {




  @override
  Widget build(BuildContext context) {
    const textStyle = const TextStyle(
        fontSize: 32.0,
        fontFamily: 'CrimsonText',
        fontWeight: FontWeight.w400
    );
    return  ClipRect(
      child:  Align(
        heightFactor: 0.7,
        alignment: Alignment.topCenter,
        child:  ConstrainedBox(
          constraints:  BoxConstraints(minWidth: double.infinity, maxWidth: double.infinity, minHeight: 0.0, maxHeight: double.infinity),
          child:  Container(
            padding: const EdgeInsets.all(8.0),
            color: widget.color,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
         //        Divider(color: Colors.black,),
                 Text(widget.title, style: textStyle,),
                 Stack(
                  children: <Widget>[
                     SizedBox(
                      height: 200.0,
                      child:  ListView(
                        scrollDirection: Axis.horizontal,
                        children: widget.books.map((book)=> Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child:  Stamp(book.url!, width: 100.0, locked: !book.starred!, onClick: (){
                            Navigator.of(context).push(
                                 FadeRoute(
                                  builder: (BuildContext context) =>  BookDetailsPageFormal(book),
                                  settings:  RouteSettings(name: '/book_detais_formal'),
                                ));
                          },),
                        )).toList()
                      ),
                    ),
                    widget.loading ?  Center(child:  CircularProgressIndicator(),):  Container(),
                  ],
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
