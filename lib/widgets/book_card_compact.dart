import 'package:flutter/material.dart';
import 'package:test_app/model/Book.dart';


class BookCardCompact extends StatelessWidget {


  BookCardCompact(this.book, {required this.onClick});

  final Book book;

  final VoidCallback? onClick;


  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap : onClick,
      child: new Container(
        child: new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Hero(child: new Image.network(book.url!, height: 150.0, width: 100.0,), tag: book.id!,),
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(top : 8.0, left: 24.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(book.title!, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0), overflow: TextOverflow.ellipsis, maxLines: 2,),
                          new SizedBox(height: 4.0,),
                          new Text(book.author!),
                       //   new SizedBox(height: 8.0,),
                      //    new Text(_short(book.subtitle, 30)),
                        ],
                      ),
                    ),
                  ),
                  new SizedBox(width: 16.0,)
                ],
              ),
              new Divider(color: Colors.black38, indent: 128.0,),
            ],
          ),
        ),
      ),
    );
  }



}