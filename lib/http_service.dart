import 'question.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpService {
  static final String postsURL = "https://thuth-dare.herokuapp.com/api/thruth";

  static getData() async {
    var fullUrl = postsURL ;
    return await http.get(
        fullUrl,
    );
  }
  static Future<List<Question>> getQuestions() async {
    http.Response res = await http.get(postsURL);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<Question> posts = body
          .map(
            (dynamic item) => Question.fromJson(item),
      )
          .toList();

      return posts;
    } else {
      throw "Can't get question.";
    }
  }
}