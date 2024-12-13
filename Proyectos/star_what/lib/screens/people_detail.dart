import 'package:flutter/material.dart';
import 'package:star_what/models/people_response/people.dart';

class PeopleDetail extends StatefulWidget {
  final People person;
  final String imageUrl;

  const PeopleDetail({Key? key, required this.person, required this.imageUrl})
      : super(key: key);

  @override
  _PeopleDetailState createState() => _PeopleDetailState();
}

class _PeopleDetailState extends State<PeopleDetail> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    // Inicializa el controlador de animación con duración de 1 segundo
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // La animación de rotación de 0 a 2*pi (360 grados)
    _rotationAnimation = Tween<double>(begin: 0, end: 3.14 * 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onImageTapped() {
    // Inicia la animación de giro
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person.name ?? "Unknown"),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // Fondo de pantalla
          Image.network(
            'https://img.freepik.com/fotos-premium/fondo-vertical-cielo-estrellado-negro-nocturno-3d-ilustracion-universo-infinito_118047-10254.jpg?w=360',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          // Contenido principal
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'hero-${widget.person.name}',
                    child: GestureDetector(
                      onTap: _onImageTapped, // Detecta el toque en la imagen
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationAnimation.value, // Aplicar la rotación
                            child: ClipOval(
                              child: Image.network(
                                widget.imageUrl,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error, color: Colors.red, size: 100);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.person.name ?? "Unknown",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAttributeRow("Height", widget.person.height ?? "Unknown", Icons.height),
                  _buildAttributeRow("Mass", widget.person.mass ?? "Unknown", Icons.fitness_center),
                  _buildAttributeRow("Hair Color", widget.person.hairColor ?? "Unknown", Icons.palette),
                  _buildAttributeRow("Skin Color", widget.person.skinColor ?? "Unknown", Icons.format_color_fill),
                  _buildAttributeRow("Eye Color", widget.person.eyeColor ?? "Unknown", Icons.remove_red_eye),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: const Text("Back", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
