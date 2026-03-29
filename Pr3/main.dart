import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const SolarApp());

class SolarApp extends StatelessWidget {
  const SolarApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const ProfitCalculator(),
    );
  }
}

class ProfitCalculator extends StatefulWidget {
  const ProfitCalculator({super.key});
  @override
  State<ProfitCalculator> createState() => _ProfitCalculatorState();
}

class _ProfitCalculatorState extends State<ProfitCalculator> {
  final _pcController = TextEditingController(text: "5.0");
  final _sigmaController = TextEditingController(text: "1.0");
  final _priceController = TextEditingController(text: "7.0");
  
  String _probabilityResult = "";
  String _moneyResult = "Натисніть кнопку для розрахунку";

  double pdf(double x, double mean, double sigma) {
    return (1.0 / (sigma * sqrt(2.0 * pi))) * exp(-0.5 * pow((x - mean) / sigma, 2.0));
  }

  double integrate(double mean, double sigma) {
    double a = mean - 0.25;
    double b = mean + 0.25;
    const int steps = 1000;
    double h = (b - a) / steps;
    double sum = 0.5 * (pdf(a, mean, sigma) + pdf(b, mean, sigma));
    for (int i = 1; i < steps; i++) {
      sum += pdf(a + i * h, mean, sigma);
    }
    return sum * h;
  }

  void _calculate() {
    double pc = double.tryParse(_pcController.text) ?? 0;
    double sigma = double.tryParse(_sigmaController.text) ?? 0;
    double b = double.tryParse(_priceController.text) ?? 0;

    double prob = integrate(pc, sigma);
    double enNoPen = pc * 24 * prob;
    double enPen = pc * 24 * (1 - prob);
    double total = (enNoPen * b) - (enPen * b);

    setState(() {
      _probabilityResult = "Ймовірність прогнозу: ${(prob * 100).toStringAsFixed(1)}%";
      _moneyResult = "${total.toStringAsFixed(1)} тис. грн";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("СЕС Калькулятор", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputCard(),
            const SizedBox(height: 24),
            
            // Велика кнопка
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
              ),
              child: const Text("РОЗРАХУВАТИ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            ),
            
            const SizedBox(height: 32),
            
            // Блок результату
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.indigo.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Text(_probabilityResult, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  const SizedBox(height: 8),
                  Text(
                    _moneyResult,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(_pcController, "Потужність Pc (МВт)", Icons.bolt),
            const SizedBox(height: 16),
            // Fix: Changed Icons.Analytics to Icons.analytics_outlined as Icons.Analytics does not exist.
            _buildTextField(_sigmaController, "Похибка sigma (МВт)", Icons.analytics_outlined),
            const SizedBox(height: 16),
            _buildTextField(_priceController, "Ціна B (грн/кВт-год)", Icons.payments),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.indigo),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}