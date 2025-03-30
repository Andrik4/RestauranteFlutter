import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:restaurante/pages/payment_page.dart';

class ReservaScreen extends StatefulWidget {
  @override
  _ReservaScreenState createState() => _ReservaScreenState();
}

class _ReservaScreenState extends State<ReservaScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final List<DateTime> _reservas = [];

  final List<DateTime> _ocupadas = [
    DateTime.utc(2025, 3, 5),
    DateTime.utc(2025, 3, 10),
    DateTime.utc(2025, 3, 15),
    DateTime.utc(2025, 3, 20),
    DateTime.utc(2025, 3, 25),
    DateTime.utc(2025, 4, 5),
    DateTime.utc(2025, 4, 10),
    DateTime.utc(2025, 4, 15),
    DateTime.utc(2025, 4, 20),
    DateTime.utc(2025, 4, 25),
  ];

  final List<DateTime> _disponibles = [
    DateTime.utc(2025, 3, 1),
    DateTime.utc(2025, 3, 3),
    DateTime.utc(2025, 3, 8),
    DateTime.utc(2025, 3, 12),
    DateTime.utc(2025, 3, 17),
    DateTime.utc(2025, 3, 22),
    DateTime.utc(2025, 4, 2),
    DateTime.utc(2025, 4, 6),
    DateTime.utc(2025, 4, 12),
    DateTime.utc(2025, 4, 18),
    DateTime.utc(2025, 4, 22),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selección de Reserva'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2025, 1, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged:
                  (format) => setState(() => _calendarFormat = format),
              onPageChanged: (focusedDay) => _focusedDay = focusedDay,

              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  Color? backgroundColor;
                  Color textColor = Colors.black;

                  if (_ocupadas.any((d) => isSameDay(d, day))) {
                    backgroundColor = Colors.redAccent;
                    textColor = Colors.white;
                  } else if (_disponibles.any((d) => isSameDay(d, day))) {
                    backgroundColor = Colors.greenAccent;
                    textColor = Colors.white;
                  }

                  return Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: backgroundColor ?? Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            backgroundColor == null
                                ? Colors.grey
                                : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
                todayBuilder:
                    (context, day, focusedDay) =>
                        _buildDayCell(day, Colors.blue),
                selectedBuilder:
                    (context, day, focusedDay) =>
                        _buildDayCell(day, Colors.orange),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    if (_selectedDay != null) {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  PaymentPage(selectedDate: _selectedDay!),
                        ),
                      );

                      if (result == true) {
                        _agendarReserva(_selectedDay!);
                      }
                    } else {
                      _mostrarMensaje('Por favor selecciona una fecha');
                    }
                  },
                  child: Text('Proceder al Pago'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    if (_selectedDay != null) {
                      _cancelarReserva(_selectedDay!);
                    } else {
                      _mostrarMensaje('Por favor selecciona una fecha');
                    }
                  },
                  child: Text('Cancelar Reserva'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Mis Reservas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _reservas.length,
                itemBuilder: (context, index) {
                  DateTime fecha = _reservas[index];
                  return ListTile(
                    title: Text(
                      'Reserva el ${fecha.day}/${fecha.month}/${fecha.year}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCell(DateTime day, Color backgroundColor) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Text(
        '${day.day}',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _agendarReserva(DateTime fecha) {
    setState(() => _reservas.add(fecha));
    _mostrarMensaje(
      'Reserva agendada para el ${fecha.day}/${fecha.month}/${fecha.year}',
    );
  }

  void _cancelarReserva(DateTime fecha) {
    setState(() => _reservas.removeWhere((d) => isSameDay(d, fecha)));
    _mostrarMensaje(
      'Reserva cancelada para el ${fecha.day}/${fecha.month}/${fecha.year}',
    );
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }
}
