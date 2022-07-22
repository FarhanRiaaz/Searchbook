import 'package:mobx/mobx.dart';
import 'package:test_app/data/repository.dart';

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
    Category(title: "Detective", isChecked: false),
    Category(title: "Fantasy", isChecked: false),
    Category(title: "Horror", isChecked: false),
    Category(title: "Action", isChecked: false),
    Category(title: "Adventure", isChecked: false),
    Category(title: "Classics", isChecked: false),
    Category(title: "Comic", isChecked: false),
    Category(title: "Graphic Novel", isChecked: false),
    Category(title: "Historical Fiction", isChecked: false),
  ];

  @observable
  List<Category> categories = [
    Category(title: "Fiction", isChecked: false),
    Category(title: "Non-Fiction", isChecked: false),
    Category(title: "Mystery", isChecked: false),
    Category(title: "Thriller", isChecked: false),
  ];

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
