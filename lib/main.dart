import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MovieListApp());
}

class MovieListApp extends StatelessWidget {
  const MovieListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MovieList(),
    );
  }
}

class MovieList extends StatefulWidget {
  const MovieList({Key? key}) : super(key: key);

  @override
  State<MovieList> createState() => HomePage();
}

class HomePage extends State<MovieList> {
  final List<Movie> _movies = <Movie>[];
  bool _isLoaded = true;
  int pageNo = 1;

  @override
  void initState() {
    getMoviesAPI();
    super.initState();
  }

  Future<void> getMoviesAPI() async {
    setState(() {
      _isLoaded = true;
    });
    final Response response = await get(
        Uri.parse("https://yts.mx/api/v2/list_movies.json?quality=3D&page=$pageNo"));
    final Map<String, dynamic> resultList =
    jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> movies = resultList['data']['movies'] as List<dynamic>;
    final List<Movie> movieData = <Movie>[];
    for (int i = 0; i < movies.length; i++) {
      final Map<String, dynamic> movieItem = movies[i] as Map<String, dynamic>;
      movieData.add(Movie.fromJson(movieItem));
        print(movies[i]['title']);

    }

    setState(() {
      _movies.addAll(movieData);
      _isLoaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Movie List"),
          actions: [
            IconButton(onPressed: () {
              pageNo++;
              getMoviesAPI();

            }, icon: const Icon(Icons.add))
          ],
        ),
        body: Builder(
          builder: (BuildContext context) {
            if(_isLoaded && _movies.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: _movies.length,
              itemBuilder: (BuildContext context, int index) {
                final Movie movie = _movies[index];
                return Column(
                  children: [
                    Image.network(movie.coverPhoto),
                    Text(movie.title,
                        style: const TextStyle(fontWeight: FontWeight.w300)),
                    Text((movie.year).toString()),
                    Text((movie.rating).toString()),
                    Text(movie.generes.join(',')),
                  ],
                );
              },
            );
          }
        )
    );
  }
}

class Movie {
  Movie(
      {required this.title,
        required this.year,
        required this.rating,
        required this.generes,
        required this.coverPhoto});

  Movie.fromJson(Map<String, dynamic> movieItem)
      : title = movieItem['title'] as String,
        year = movieItem['year'] as int,
        rating = (movieItem['rating'] as num).toDouble(),
        generes = List<String>.from(movieItem['generes'] as List<dynamic>),
        coverPhoto = movieItem['medium_cover_image'] as String;

  final String title;
  final int year;
  final double rating;
  final List<String> generes;
  final String coverPhoto;
}
