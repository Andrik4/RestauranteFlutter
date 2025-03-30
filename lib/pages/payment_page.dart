import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaymentPage extends StatefulWidget {
  final DateTime selectedDate;

  PaymentPage({required this.selectedDate});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPaymentMethod = 'Tarjeta de Crédito';
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Método de Pago',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reserva para: ${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedPaymentMethod,
                      decoration: _inputDecoration('Método de Pago'),
                      items:
                          ['Tarjeta de Crédito', 'Tarjeta de Débito'].map((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPaymentMethod = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      _cardNumberController,
                      'Número de Tarjeta',
                      TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            _expiryDateController,
                            'Expiración (MM/YY)',
                            TextInputType.datetime,
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: _buildTextField(
                            _cvvController,
                            'CVV',
                            TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      _nameController,
                      'Nombre en la Tarjeta',
                      TextInputType.text,
                    ),
                    SizedBox(height: 30),
                    _isProcessing
                        ? Center(
                          child: Lottie.asset(
                            'assets/loading.json',
                            height: 60,
                          ),
                        )
                        : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _processPayment,
                            child: Text(
                              'Confirmar Pago',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    TextInputType type,
  ) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label),
      keyboardType: type,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese $label';
        }
        return null;
      },
    );
  }

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isProcessing = false;
        });
        Navigator.pop(context, true);
      });
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
