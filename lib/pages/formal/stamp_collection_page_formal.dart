import 'package:flutter/material.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/pages/abstract/stamp_collection_page_abstract.dart';
import 'package:test_app/pages/formal/book_details_page_formal.dart';
import 'package:test_app/utils/utils.dart';
import 'package:test_app/widgets/stamp.dart';


class StampCollectionFormalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>  _StampCollectionPageFormalState();

}


class _StampCollectionPageFormalState extends StampCollectionPageAbstractState<StampCollectionFormalPage> {



  @override
  Widget build(BuildContext context) {

    const textStyle = const TextStyle(
        fontSize: 35.0,
        fontFamily: 'Butler',
        fontWeight: FontWeight.w400
    );

    Widget body;

    if(items.isEmpty) {
      body =  Center(child:  Text("You have no collection yet"));
    } else {
      body =  ListView.builder(itemBuilder: (BuildContext context, int index){
        return  Padding(
          padding: const EdgeInsets.all(8.0),
          child:  Stamp(items[index].url!, onClick: () {  },),
        );
      },
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
      );
    }


    body =  GridView.extent(
      maxCrossAxisExtent: 150.0,
      mainAxisSpacing: 20.0,
      children: items.map((Book book)=>  Stamp(book.url!, width: 90.0, onClick: (){
        Navigator.of(context).push(
             FadeRoute(
              builder: (BuildContext context) =>  BookDetailsPageFormal(book),
              settings:  RouteSettings(name: '/book_detais_formal'),
            ));
      },)).toList(),

    );

    body =  Container(
      padding: const EdgeInsets.all(16.0),
      child: body,
      color:  Color(0xFFF5F5F5),
    );


    return  Scaffold(
      appBar:  AppBar(
        title:  Text("Stamp Collection", style: const TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 1.0,
        iconTheme:  IconThemeData(color: Colors.black),
      ),
      body: body,
    );
  }


}