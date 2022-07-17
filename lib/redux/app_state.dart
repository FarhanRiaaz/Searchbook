import 'package:test_app/model/Book.dart';


class AppState {


  AppState({
    this.readBooks
  });

  final List<Book>? readBooks;



  static AppState initState() {
    return new AppState(readBooks: []);
  }

}