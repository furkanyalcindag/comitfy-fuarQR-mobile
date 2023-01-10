import 'dart:convert';

import 'package:http/http.dart';

class ArticleService {
  static Future<Map<String, dynamic>?> fetchArticleByID(
      {required String path, required String uuid}) async {
    // late List<Article> list;

    final response = await get(
      Uri.parse(path + uuid),
      headers: {
        "accept": "application/json",
        "Accept-Language": "TR",
      },
    );
    final data;
    if (response.statusCode == 200) {
      data = json.decode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      return null;
    }
  }
}
