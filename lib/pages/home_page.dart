import 'package:flutter/material.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/utils/index_offset_curve.dart';
import 'package:test_app/widgets/collection_preview.dart';



class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() =>  _HomePageState();
}



class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {


  late AnimationController cardsFirstOpenController;


  String interfaceType = "formal";

  bool init = true;

  @override
  void initState() {
    super.initState();
    cardsFirstOpenController =  AnimationController(vsync: this, duration: const Duration(milliseconds: 1300));

    Repository.get().init().then((it){
      setState((){
        init = false;
      });
    });
    cardsFirstOpenController.forward(from: 0.2);
  }


  @override
  void dispose() {
    cardsFirstOpenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body: init?  Container():  CustomScrollView(
        slivers: <Widget>[
           SliverAppBar(
            actions: <Widget>[
               IconButton(icon:  Icon(Icons.search), onPressed: () {Navigator.pushNamed(context, '/search_$interfaceType');},),
               IconButton(icon:  Icon(Icons.collections), onPressed: () {Navigator.pushNamed(context, '/stamp_collection_$interfaceType');},),
            ],
            backgroundColor: Colors.white,
            elevation: 2.0,
            iconTheme:  IconThemeData(color: Colors.black),
            floating: true,
            forceElevated: true,
          ),
           SliverList(delegate:  SliverChildListDelegate(
            [
              wrapInAnimation(myCollection(), 0),
              wrapInAnimation(collectionPreview( Color(0xffffffff), "Biographies", ["wO3PCgAAQBAJ","_LFSBgAAQBAJ","8U2oAAAAQBAJ", "yG3PAK6ZOucC"]), 1),
              wrapInAnimation(collectionPreview( Color(0xffffffff), "Fiction", ["OsUPDgAAQBAJ", "3e-dDAAAQBAJ", "-ITZDAAAQBAJ","rmBeDAAAQBAJ", "vgzJCwAAQBAJ"]), 2),
              wrapInAnimation(collectionPreview( Color(0xffffffff), "Mystery & Thriller", ["1Y9gDQAAQBAJ", "Pz4YDQAAQBAJ", "UXARDgAAQBAJ"]), 3),
              wrapInAnimation(collectionPreview( Color(0xffffffff), "Sience Ficition", ["JMYUDAAAQBAJ","PzhQydl-QD8C", "nkalO3OsoeMC", "VO8nDwAAQBAJ", "Nxl0BQAAQBAJ"]), 4),
               Center(
                child:  Switch(value: interfaceType != "formal", onChanged: (bool){
                  setState((){
                    if(bool) {
                      interfaceType = "material";
                    } else {
                      interfaceType = "formal";
                    }
                  });
                }),
              ),
               Center(
                child:  Text("Magic Switch, press for different style", style: const TextStyle(fontSize: 18.0),),
              ),
            ],
          ))
        ],
      )
    );
  }


  /* child:  StoreConnector<AppState, List<Book>>(
             converter: (Store<AppState> store) => store.state.readBooks,
             builder: (BuildContext context, List<Book> books) {
               return  CollectionPreview(
                 books: books,
                 color:  Color(0xff8FC0A9),
                 title: "My Collection",
                 loading: false,
               );
             },
           ),*/

  Widget wrapInAnimation(Widget child, int index) {
    Animation<double> offsetAnimation =  CurvedAnimation(parent: cardsFirstOpenController, curve:  IndexOffsetCurve(index));
    Animation<double> fade =  CurvedAnimation(parent: offsetAnimation, curve: Curves.ease);
    return  SlideTransition(
        position:  Tween<Offset>(begin:  Offset(0.5, 0.0), end:  Offset(0.0, 0.0)).animate(fade),
        child:  FadeTransition(
          opacity: fade,
          child: child,
        )
    );
  }


  Widget collectionPreview(Color color, String name, List<String> ids) {
    return  FutureBuilder<List<Book>>(
      future: Repository.get().getBooksByIdFirstFromDatabaseAndCache(ids),
      builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
        List<Book> books = [];
        if(snapshot.data != null) books = snapshot.data!;
        return
          CollectionPreview(
          books: books,
          color: color,
          title: name,
          loading: snapshot.data == null,
        );
      },
    );
  }


  Widget myCollection() {
    return  FutureBuilder<List<Book>>(
      future: Repository.get().getFavoriteBooks(),
      builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
        List<Book> books = [];
        if(snapshot.data != null) books = snapshot.data!;
        if(books.isEmpty) {
          return  Container();
        }
        return  CollectionPreview(
          books: books,
          //color:  Color(0xffFC96BC),
          color:  Color(0xffffffff),
          title: "My Collection",
          loading: snapshot.data == null,
        );
      },
    );
  }
}