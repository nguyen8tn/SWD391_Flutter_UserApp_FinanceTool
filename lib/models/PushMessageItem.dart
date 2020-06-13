import 'package:flutter/material.dart';

@immutable
class PushMessageItem {
  final String title;
  final String body;

  const PushMessageItem({
    @required this.title,
    @required this.body,
  });
}
