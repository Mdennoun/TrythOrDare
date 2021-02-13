import 'package:flutter/foundation.dart';

class Question {
  final String response;
  String get _response => response;

  Question({
    @required this.response,
  });


  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      response: json['response'] as String,
    );
  }
}