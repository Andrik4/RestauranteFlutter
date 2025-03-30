import 'package:flutter/material.dart';
import 'pages/calendario_reservas.dart';
import 'pages/payment_page.dart';
import 'pages/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Restaurante',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false, // Oculta el banner de debug
      initialRoute: '/home', // Define la primera pantalla
      routes: {
        '/home': (context) => HomeScreen(), // Página principal
        '/calendar': (context) => ReservaScreen(), // Calendario de reservas
        // '/payment': (context) => PaymentPage(selectedDate: selectedDate),
      },
    );
  }
}
