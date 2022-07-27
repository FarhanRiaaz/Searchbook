import 'dart:async';
import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/model/Book.dart';
import 'package:http/http.dart' as http;

import '../model/user.dart';

/// A class similar to http.Response but instead of a String describing the body
/// it already contains the parsed Dart-Object
class ParsedResponse<T> {
  ParsedResponse(this.statusCode, this.body);

  final int statusCode;
  final T body;

  bool isOk() {
    return statusCode >= 200 && statusCode < 300;
  }
}

final int NO_INTERNET = 404;

class Repository {
  static final Repository _repo = new Repository._internal();

  late BookDatabase database;

  static Repository get() {
    return _repo;
  }

  Repository._internal() {
    database = BookDatabase.get();
  }

  Future init() async {
    return await database.init();
  }

  /// Fetches the books from the Google Books Api with the query parameter being input.
  /// If a book also exists in the local storage (eg. a book with notes/ stars) that version of the book will be used instead
  Future<ParsedResponse<List<Book>>> getBooks(String input) async {
    //http request, catching error like no internet connection.
    //If no internet is available for example response is
    //TODO restricted language to english, feel free to remove that
    http.Response response = await http
        .get(Uri.parse(
            "https://www.googleapis.com/books/v1/volumes?q=$input&langRestrict=en"))
        .catchError((resp) {});

    if (response == null) {
      return new ParsedResponse(NO_INTERNET, []);
    }

    //If there was an error return an empty list
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return new ParsedResponse(response.statusCode, []);
    }
    // Decode and go to the items part where the necessary book information is
    List<dynamic> list = jsonDecode(response.body)['items'];

    Map<String, Book> networkBooks = {};

    for (dynamic jsonBook in list) {
      Book book = parseNetworkBook(jsonBook);
      networkBooks[book.id!] = book;
    }

    //Adds information (if available) from database
    List<Book> databaseBook =
        await database.getBooks([]..addAll(networkBooks.keys));
    for (Book book in databaseBook) {
      networkBooks[book.id!] = book;
    }

    return new ParsedResponse(
        response.statusCode, []..addAll(networkBooks.values));
  }

  Future<ParsedResponse<Book>> getBook(String id) async {
    http.Response response = await http
        .get(Uri.parse("https://www.googleapis.com/books/v1/volumes/$id"))
        .catchError((resp) {});
    if (response == null) {
      return new ParsedResponse(NO_INTERNET, Book());
    }

    //If there was an error return null
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return new ParsedResponse(response.statusCode, Book());
    }

    dynamic jsonBook = jsonDecode(response.body);

    Book book = parseNetworkBook(jsonBook);

    //Adds information (if available) from database
    List<Book> databaseBook = await database.getBooks([]..add(book.id!));
    for (Book databaseBook in databaseBook) {
      book = databaseBook;
    }

    return new ParsedResponse(response.statusCode, book);
  }

  //TODO optimize and add status code (Parsed Response)
  Future<List<Book>> getBooksById(List<String> ids) async {
    List<Book> books = [];

    //  int statusCode = 200;
    for (String id in ids) {
      ParsedResponse<Book> book = await getBook(id);

      // One of the books went wrong, save status code and continue
      //   if(book.statusCode < 200 || book.statusCode >= 300) {
      //     statusCode = book.statusCode;
      //    }

      books.add(book.body);
    }

    return books;
    //  return new ParsedResponse(statusCode, books);
  }

  Future<List<Book>> getBooksByIdFirstFromDatabaseAndCache(
      List<String> ids) async {
    try {
      print("status code ${ids.length}");

      List<Book> books = [];
      List<String> idsToFetch = ids;
      List<Book> databaseBook = await database.getBooks([]..addAll(ids));
      databaseBook.forEach((element) {
        books.add(element);
        print("books values ${books.length}");
        idsToFetch.remove(element.id);
      });
      print("ids to fetch ${ids.length} and ${idsToFetch.length}");
      Future.forEach(idsToFetch, (element) async {
        http.Response response = await http
            .get(Uri.parse(
                "https://www.googleapis.com/books/v1/volumes/$element"))
            .catchError((Object error) {
          return Future.error(error);
        });

        dynamic jsonBook = jsonDecode(response.body);
        Book book = parseNetworkBook(jsonBook);
        updateBook(book);
        books.add(book);
      });

      return books;
    } catch (exception) {
      rethrow;
    }
  }

  Book parseNetworkBook(jsonBook) {
    Map volumeInfo = jsonBook["volumeInfo"];
    String author = "No author";
    if (volumeInfo.containsKey("authors")) {
      author = volumeInfo["authors"][0];
    }
    String description = "No description";
    if (volumeInfo.containsKey("description")) {
      description = volumeInfo["description"];
    }
    String subtitle = "No subtitle";
    if (volumeInfo.containsKey("subtitle")) {
      subtitle = volumeInfo["subtitle"];
    }
    return new Book(
      title: jsonBook["volumeInfo"]["title"],
      url: jsonBook["volumeInfo"]["imageLinks"] != null
          ? jsonBook["volumeInfo"]["imageLinks"]["smallThumbnail"]
          : "",
      id: jsonBook["id"],
      //only first author
      author: author,
      description: description,
      subtitle: subtitle,
    );
  }

  Future<String>? handleGetContact(GoogleSignInAccount user) async {
    var name = '';
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      print('People API ${response.statusCode} response: ${response.body}');
      return name;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);

    if (namedContact != null) {
      name = namedContact;
      return name;
    } else {
      return name = '';
    }
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  Future updateBook(Book book) async {
    await database.updateBook(book);
  }

  Future updateUser(User user) async {
    await database.updateUser(user);
  }

  Future<User> getUser() async {
    return await database.getUser();
  }

  Future close() async {
    return database.close();
  }

  Future<List<Book>> getFavoriteBooks() {
    return database.getFavoriteBooks();
  }
}
