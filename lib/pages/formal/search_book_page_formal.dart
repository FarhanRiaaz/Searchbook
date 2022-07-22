import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:test_app/mobx/book_store.dart';
import 'package:test_app/model/categories.dart';
import 'package:test_app/pages/abstract/search_book_page_abstract.dart';
import 'package:test_app/pages/formal/book_details_page_formal.dart';
import 'package:test_app/utils/utils.dart';
import 'package:test_app/widgets/book_card_compact.dart';
import 'package:test_app/widgets/chips_widget.dart';


class SearchBookPageNew extends StatefulWidget {

  @override
  _SearchBookStateNew createState() =>  _SearchBookStateNew();
}

class _SearchBookStateNew extends AbstractSearchBookState<SearchBookPageNew> {
  BookStore bookStore = BookStore();
  @override
  Widget build(BuildContext context) {
    const textStyle = const TextStyle(
      fontSize: 24.0,
      fontFamily: 'Butler',
      fontWeight: FontWeight.bold
    );
    return  Observer(
      builder: (context) {
        bookStore.category;
        return Scaffold(
          key: scaffoldKey,
          body:
          Column(
            children: [
              SizedBox(height: 60,),
              Expanded(
                child: CustomScrollView(
                  slivers: <Widget>[
                     SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver:  SliverToBoxAdapter(
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                             SizedBox(height: 8.0,),
                             Text("Explore", style: textStyle,),
                             SizedBox(height: 16.0),
                             Card(
                                elevation: 4.0,
                                child:  Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:  TextField(
                                    decoration:  InputDecoration(
                                        hintText: "Search your favourite book",
                                        prefixIcon:  Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:  Icon(Icons.search),
                                        ),
                                        border: InputBorder.none
                                    ),
                                    onChanged: (string) => (subject.add(string)),
                                  ),
                                )
                            ),
                             SizedBox(height: 16.0,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                bookStore.currentCategory?.title == null
                                    ? "Popular Genre"
                                    : bookStore.currentCategory!.title!,
                                style: textStyle,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            getGridForCategories(),
                            _buildExpandable(),
                          ],
                        ),
                      ),
                    ),
                    isLoading?  SliverToBoxAdapter(child:  Center(child:  CircularProgressIndicator()),):  SliverToBoxAdapter(),
                     SliverList(delegate:  SliverChildBuilderDelegate((BuildContext context, int index){
                      return  BookCardCompact(items[index], onClick: (){
                        Navigator.of(context).push(
                             FadeRoute(
                              builder: (BuildContext context) =>  BookDetailsPageFormal(items[index]),
                              settings:  RouteSettings(name: '/book_detais_formal'),
                            ));
                      },);
                    },
                    childCount: items.length)
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }
  Widget getGridForCategories() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: bookStore.category.map((e) {
              return Observer(builder: (context) {
                bookStore.category;
                return ChipsWidget(e, () {
                  bookStore.updateCurrentCategory(e);
                  subject.add(e.title!);
                },
                    bookStore.currentCategory == e
                        ? Colors.blue.shade500
                        : Colors.white);
              });
            }).toList()));
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
                    subject.add(e.title!);
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
        collapsed: Padding(
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

