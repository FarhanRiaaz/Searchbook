import 'package:flutter/material.dart';
import 'package:test_app/data/repository.dart';

abstract class ProfilePageAbstractState<T extends StatefulWidget>
    extends State<T> {
  int count = 0;

  @override
  void initState() {
    super.initState();
    Repository.get().getFavoriteBooks().then((list) {
      setState(() {
        count = list.length;
      });
    });
  }
}
