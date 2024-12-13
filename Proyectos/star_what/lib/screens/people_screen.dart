import 'package:flutter/material.dart';
import 'package:star_what/models/people_response/people.dart';
import 'package:star_what/models/people_response/people_response.dart';
import 'package:http/http.dart' as http;
import 'people_detail.dart'; // Importamos la página de detalles

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  late Future<PeopleResponse> peopleResponse;

  @override
  void initState() {
    super.initState();
    peopleResponse = getPeople();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PeopleResponse>(
        future: peopleResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.black,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true, 
                    title: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), 
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6), 
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Characters',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    background: Image.network(
                      'https://orion-uploads.openroadmedia.com/lg_7b14486fa0b1-50-best-star-wars-characters_feature.jpg',
                      fit: BoxFit.contain, 
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final person = snapshot.data!.results![index];
                      final imageUrl =
                          'https://starwars-visualguide.com/assets/img/characters/${index + 1}.jpg';

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0), // Más padding externo
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PeopleDetail(
                                  person: person,
                                  imageUrl: imageUrl,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(15), // Bordes más redondeados
                            ),
                            padding: const EdgeInsets.all(16.0), // Espaciado interno dentro de la card
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Hero(
                                  tag: 'hero-${person.name}',
                                  child: ClipOval(
                                    child: Image.network(
                                      imageUrl,
                                      height: 100, // Imagen más grande
                                      width: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.error, color: Colors.red, size: 50);
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16.0), // Espaciado entre la imagen y el texto
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        person.name!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20, // Texto más grande
                                        ),
                                      ),
                                      const SizedBox(height: 8.0), // Espaciado entre título y subtítulo
                                      Text(
                                        person.gender!,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16, // Subtítulo más grande
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );

                    },
                    childCount: snapshot.data!.results!.length,
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<PeopleResponse> getPeople() async {
    final response = await http.get(Uri.parse('https://swapi.dev/api/people'));

    if (response.statusCode == 200) {
      return PeopleResponse.fromJson(response.body);
    } else {
      throw Exception('Failed to load people');
    }
  }
}
