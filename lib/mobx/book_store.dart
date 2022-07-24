import 'package:mobx/mobx.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/model/Book.dart';

import '../model/categories.dart';

part 'book_store.g.dart';

class BookStore = _BookStore with _$BookStore;

abstract class _BookStore with Store {
  // constructor:---------------------------------------------------------------
  _BookStore() {
    Repository.get().init().then((value) {
      changeReload(true);
    });
  }

  @observable
  bool shouldReload = false;

  @observable
  Category? currentCategory;

  @computed
  ObservableList<Category> get category => ObservableList.of(categories);

  @observable
  List<Book> loadedBooks = [];

  @computed
  ObservableList<Book> get books => ObservableList.of(loadedBooks);

  @computed
  ObservableList<Category> get allCategories => ObservableList.of(allCategory);

  @action
  void changeReload(bool reload) {
    shouldReload = reload;
  }

  @action
  void updateCurrentCategory(Category category) {
    currentCategory = category;
  }

  @observable
  List<Category> allCategory = [
    Category(title: "Detective"),
    Category(title: "Fantasy"),
    Category(title: "Horror"),
    Category(title: "Action"),
    Category(title: "Adventure"),
    Category(title: "Classics"),
    Category(title: "Comic"),
    Category(title: "Graphic Novel"),
    Category(title: "Mystery"),
  ];

  @observable
  List<Category> categories = [
    Category(title: "Fiction"),
    Category(title: "Historical Fiction"),
    Category(title: "Thriller"),
  ];

  @action
  Future<List<Book>> getBooksByIdFirstFromDatabaseAndCache() async {
    try {
      return await Repository.get().getBooksByIdFirstFromDatabaseAndCache([
        "wO3PCgAAQBAJ",
        "_LFSBgAAQBAJ",
        "8U2oAAAAQBAJ",
        "yG3PAK6ZOucC",
        "OsUPDgAAQBAJ",
        "3e-dDAAAQBAJ",
        "-ITZDAAAQBAJ",
        "rmBeDAAAQBAJ",
        "vgzJCwAAQBAJ",
        "1Y9gDQAAQBAJ",
        "Pz4YDQAAQBAJ",
        "UXARDgAAQBAJ",
        "JMYUDAAAQBAJ",
        "PzhQydl-QD8C",
        "nkalO3OsoeMC",
        "VO8nDwAAQBAJ",
        "Nxl0BQAAQBAJ"
      ]);
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

  @action
  void removeElement(Category value) {
    print("you tried to hit me ${value.title}");
    category.remove(value);
  }

  @action
  void addElement(Category value) {
    print("you tried to hit me ${value.title}");
    category.add(value);
  }
}
