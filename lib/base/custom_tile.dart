import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final String title;
  final String subTitle;
  const CustomTile({
    required this.title,
    required this.subTitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subTitle),
      ),
    );
  }
}
