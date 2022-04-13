import 'dart:convert';

import 'package:http/http.dart';

Future<void> main() async {
  final Response response = await get(
      Uri.parse("https://yts.mx/api/v2/list_movies.json?quality=3D"));
  final Map<String, dynamic> resultList =
  jsonDecode(response.body) as Map<String, dynamic>;
  final List<dynamic> movies = resultList['data']['movies'] as List<dynamic>;

  for(int i = 0;i< movies.length;i++){
    print(movies[i]['title']);
    print(movies[i]['rating']);
  }
}