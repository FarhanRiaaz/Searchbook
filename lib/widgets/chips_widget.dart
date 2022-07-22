import 'package:flutter/material.dart';
import 'package:test_app/model/categories.dart';

class ChipsWidget extends StatelessWidget {
  const ChipsWidget(this.category, this.callback, {Key? key}) : super(key: key);
  final Category category;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          color:
              category.isChecked == true ? Colors.greenAccent : Colors.black87,
        ),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: InkWell(
        splashColor: Colors.green,
        highlightColor: Colors.greenAccent,
        borderRadius: BorderRadius.circular(15.0),
        onTap: () {
          print("i ham here");
          callback();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(category.title ?? "chip"),
        ),
      ),
    );
  }
}
