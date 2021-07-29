import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:firebase_database/firebase_database.dart";

class UserModel {
  String firstName;
  String lastName;

  UserModel({
    required this.firstName,
    required this.lastName
  });

  Map<String, dynamic> toJson() => {
    'author': firstName,
    'quote': lastName,
  };

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
        firstName : json['firstname'],
        lastName :json['lastname']
    );
  }
}
