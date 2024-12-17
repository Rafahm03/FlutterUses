import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiKey = "81819d9750b41c41923effa77112f27a"; 
  List<dynamic> popularActors = [];
  List<dynamic> popularMovies = [];

  @override
  void initState() {
    super.initState();
    fetchPopularActors();
    fetchPopularMovies();
  }

  Future<void> fetchPopularActors() async {
    final response = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/person/popular?api_key=$apiKey"));
    if (response.statusCode == 200) {
      setState(() {
        popularActors = json.decode(response.body)['results'];
      });
    }
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

  Widget _buildHorizontalList(List<dynamic> items) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final imageUrl = item['profile_path'] ?? item['poster_path'];
          return Card(
            child: Column(
              children: [
                Image.network(
                  "https://image.tmdb.org/t/p/w200$imageUrl",
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 8),
                Text(
                  item['name'] ?? item['title'],
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text('Actores Populares', style: TextStyle(fontSize: 18)),
            _buildHorizontalList(popularActors),
            const SizedBox(height: 16),
            const Text('Películas Populares', style: TextStyle(fontSize: 18)),
            _buildHorizontalList(popularMovies),
          ],
        ),
      ),
    );
  }
}
