import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final String apiKey = "81819d9750b41c41923effa77112f27a"; 
  List<dynamic> popularMovies = [];

  @override
  void initState() {
    super.initState();
    fetchPopularMovies();
  }

  Future<void> fetchPopularMovies() async {
    final response = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey"));
    if (response.statusCode == 200) {
      setState(() {
        popularMovies = json.decode(response.body)['results'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Películas')),
      body: ListView.builder(
        itemCount: popularMovies.length,
        itemBuilder: (context, index) {
          final movie = popularMovies[index];
          final imageUrl = movie['poster_path'];
          return ListTile(
            leading: Image.network(
              "https://image.tmdb.org/t/p/w200$imageUrl",
              width: 50,
              fit: BoxFit.cover,
            ),
            title: Text(movie['title']),
            subtitle: Text('Puntuación: ${movie['vote_average']}'),
          );
        },
      ),
    );
  }
}
