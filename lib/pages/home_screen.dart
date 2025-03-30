import 'package:flutter/material.dart';
import 'package:restaurante/pages/Calendario_reservas.dart'; // Ajusta la ruta si es necesario

void main() {
  runApp(SitEatApp());
}

class SitEatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      routes: {
        '/calendar':
            (context) => ReservaScreen(), // Define la ruta para el calendario
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Índice de la barra inferior
  String searchQuery = ""; // Texto de búsqueda

  final List<Map<String, String>> products = [
    {
      'name': 'Tacos al Pastor',
      'price': '\$18.00',
      'image': 'assets/TacosPastor.jpg',
      'description':
          'Deliciosos tacos de cerdo marinado con chiles y especias, cocinados en trompo, servidos con piña, cebolla y cilantro.',
    },
    {
      'name': 'Chiles en Nogada',
      'price': '\$25.00',
      'image': 'assets/ChilesNogada.jpg',
      'description':
          'Chiles poblanos rellenos de picadillo, bañados en salsa de nuez y decorados con granada y perejil.',
    },
    {
      'name': 'Pozole Rojo',
      'price': '\$20.00',
      'image': 'assets/Pozole.jpg',
      'description':
          'Sopa espesa de maíz con carne de cerdo, cocida con chiles secos. Se sirve con rábanos, lechuga y tostadas.',
    },
    {
      'name': 'Tamales',
      'price': '\$15.00',
      'image': 'assets/Tamales.jpg',
      'description':
          'Masa de maíz rellena de guisos como salsa roja, verde o dulce, envuelta en hoja de maíz y cocida al vapor.',
    },
    {
      'name': 'Mole Poblano',
      'price': '\$22.00',
      'image': 'assets/Mole.jpg',
      'description':
          'Salsa espesa de chiles y chocolate que cubre pollo o guajolote. Se acompaña con arroz y tortillas.',
    },
    {
      'name': 'Enchiladas Verdes',
      'price': '\$19.00',
      'image': 'assets/Enchiladas.jpg',
      'description':
          'Tortillas rellenas de pollo, bañadas en salsa de tomate verde con crema y queso, servidas con frijoles refritos.',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navegar según el ítem seleccionado
    if (index == 0) {
      // Si se selecciona el calendario
      Navigator.pushNamed(context, '/calendar');
    } else if (index == 1) {
      // Si se selecciona el pago
      Navigator.pushNamed(context, '/payment');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredProducts =
        products
            .where(
              (product) => product['name']!.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Sit&Eat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle), // Ícono de perfil
            onPressed: () {
              // Acción para ir al perfil
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Todos los productos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 columnas
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.4, // Ajuste de altura de las tarjetas
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    name: filteredProducts[index]['name']!,
                    price: filteredProducts[index]['price']!,
                    image: filteredProducts[index]['image']!,
                    description: filteredProducts[index]['description']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Pago'),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String image;
  final String description;

  const ProductCard({
    required this.name,
    required this.price,
    required this.image,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      child: Column(
        children: [
          Expanded(
            flex: 2, // Espacio de la imagen ajustado
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0), // Menos padding interno
            child: Column(
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(price, style: TextStyle(color: Colors.green)),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  maxLines: 2, // Limita a 2 líneas
                  overflow: TextOverflow.ellipsis, // "..." si el texto es largo
                  style: TextStyle(fontSize: 10), // Fuente más pequeña
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
