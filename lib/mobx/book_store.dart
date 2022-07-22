import 'package:mobx/mobx.dart';
import 'package:test_app/data/repository.dart';

part 'book_store.g.dart';

class BookStore = _BookStore with _$BookStore;

abstract class _BookStore with Store {
  // repository instance
  final Repository _repositoryImpl;

  // constructor:---------------------------------------------------------------
  _BookStore(Repository repositoryImpl)
      : _repositoryImpl = repositoryImpl;
}
