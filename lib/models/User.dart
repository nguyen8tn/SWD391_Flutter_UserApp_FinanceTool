import 'package:flutter/material.dart';

class User {
  String id;
  String token;
  String name;
  String email;

  User(this.token, this.id, this.name, this.email);

  Map<String, dynamic> toJson() => {'id': id, 'token': token, 'name': name, 'email' : email};
}
