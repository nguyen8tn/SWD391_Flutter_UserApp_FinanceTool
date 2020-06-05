import 'package:flutter/material.dart';

class User {
  String uid;
  String token;
  String name;
  String email;

  User(this.token, this.uid, this.name, this.email);

  Map<String, dynamic> toJson() => {'uid': uid, 'token': token};
}
