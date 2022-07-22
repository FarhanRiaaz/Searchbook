import 'dart:io';

import 'package:flutter/material.dart';
import 'package:test_app/pages/universal/collection_page.dart';
import 'package:test_app/pages/formal/stamp_collection_page_formal.dart';
import 'package:test_app/pages/navigation.dart';
import 'package:test_app/pages/material/search_book_page_material.dart';
import 'package:test_app/pages/formal/search_book_page_formal.dart';
import 'package:test_app/pages/material/stamp_collection_page_material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  return runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book search',
      theme: new ThemeData(
        primaryColor: new Color(0xFF0F2533),
      ),
      routes: {
        '/': (BuildContext context) => new NavigationScreen(),
        '/search_material': (BuildContext context) => new SearchBookPage(),
        '/search_formal': (BuildContext context) => new SearchBookPageNew(),
        '/collection': (BuildContext context) => new CollectionPage(),
        '/stamp_collection_material': (BuildContext context) =>
            new StampCollectionPage(),
        '/stamp_collection_formal': (BuildContext context) =>
            new StampCollectionFormalPage(),
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
