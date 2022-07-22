import 'package:flutter/material.dart';
import 'package:test_app/model/categories.dart';

class ChipsWidget extends StatelessWidget {
  const ChipsWidget(this.category, this.callback,this.color, {Key? key}) : super(key: key);
  final Category category;
  final VoidCallback callback;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.0),
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(
            color: Colors.black,
                width: 1.3,
          ),
        ),
        child: InkWell(
          splashColor: Colors.blue.shade900,
          highlightColor: Colors.blue.shade200,
          borderRadius: BorderRadius.circular(15.0),
          onTap: () {
            callback();
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(category.title ?? "chip"),
          ),
        ),
      ),
    );
  }
}
