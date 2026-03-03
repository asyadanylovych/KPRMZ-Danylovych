import 'package:flutter/material.dart';

void main() => runApp(const FuelApp());

class FuelApp extends StatelessWidget {
  const FuelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const CalcScreen(),
    );
  }
}

class CalcScreen extends StatefulWidget {
  const CalcScreen({super.key});

  @override
  State<CalcScreen> createState() => _CalcScreenState();
}

class _CalcScreenState extends State<CalcScreen> {
  // TextEditingControllers for input values, initialized with Variant 7 default values.
  final TextEditingController hp = TextEditingController(text: "1.4"); // Hydrogen (H)
  final TextEditingController cp = TextEditingController(text: "71.7"); // Carbon (C)
  final TextEditingController sp = TextEditingController(text: "1.8"); // Sulfur (S)
  final TextEditingController np = TextEditingController(text: "0.8"); // Nitrogen (N)
  final TextEditingController op = TextEditingController(text: "1.4"); // Oxygen (O)
  final TextEditingController wp = TextEditingController(text: "6.0"); // Moisture (W)
  final TextEditingController ap = TextEditingController(text: "16.9"); // Ash (A)

  // String variables to display calculation results for Task 1, initialized to indicate no calculation yet.
  String qphResult = "Нижча теплотворна здатність (Qp_h): -";
  String kpcResult = "Kpc: -";
  String kpgResult = "Kpg: -";
  String qchResult = "Qc_h: -";
  String qghResult = "Qg_h: -";

  // TextEditingControllers for Mazut inputs (Task 2)
  final TextEditingController cDafController = TextEditingController(text: "85.5"); // Carbon (C_daf)
  final TextEditingController hDafController = TextEditingController(text: "11.2"); // Hydrogen (H_daf)
  final TextEditingController oDafController = TextEditingController(text: "0.8"); // Oxygen (O_daf)
  final TextEditingController sDafController = TextEditingController(text: "2.5"); // Sulfur (S_daf)
  final TextEditingController qDafController = TextEditingController(text: "40.4"); // Lower heating value (Q_daf)
  final TextEditingController wPController = TextEditingController(text: "2.0"); // Moisture (W_p)
  final TextEditingController aDController = TextEditingController(text: "0.15"); // Ash (A_d)

  // String variables to display Mazut calculation results (Task 2)
  String apMazutResult = "Робоча зола (Ap): -";
  String kMazutResult = "Коефіцієнт (K): -";
  String qphMazutResult = "Мазут Qp_h: -";
  String cWorkingResult = "Мазут C_роб: -";
  String hWorkingResult = "Мазут H_роб: -";
  String sWorkingResult = "Мазут S_роб: -";
  String oWorkingResult = "Мазут O_роб: -";

  @override
  void dispose() {
    // Dispose of TextEditingControllers to prevent memory leaks.
    hp.dispose();
    cp.dispose();
    sp.dispose();
    np.dispose();
    op.dispose();
    wp.dispose();
    ap.dispose();

    cDafController.dispose();
    hDafController.dispose();
    oDafController.dispose();
    sDafController.dispose();
    qDafController.dispose();
    wPController.dispose();
    aDController.dispose();

    super.dispose();
  }

  void calculate() {
    // Task 1: Existing calculations
    final double h = double.tryParse(hp.text) ?? 0.0;
    final double c = double.tryParse(cp.text) ?? 0.0;
    final double s = double.tryParse(sp.text) ?? 0.0;
    final double o = double.tryParse(op.text) ?? 0.0;
    final double w = double.tryParse(wp.text) ?? 0.0;
    final double a = double.tryParse(ap.text) ?? 0.0;

    final double qph = (339 * c + 1030 * h - 108.8 * (o - s) - 25 * w) / 1000.0;

    double kpc;
    if ((100.0 - w).abs() < 1e-9) {
      kpc = double.infinity;
    } else {
      kpc = 100.0 / (100.0 - w);
    }

    double kpg;
    if ((100.0 - w - a).abs() < 1e-9) {
      kpg = double.infinity;
    } else {
      kpg = 100.0 / (100.0 - w - a);
    }

    final double qch = (qph + 0.025 * w) * kpc;
    final double qgh = (qph + 0.025 * w) * kpg;

    // Task 2: Mazut calculations
    final double cDaf = double.tryParse(cDafController.text) ?? 0.0;
    final double hDaf = double.tryParse(hDafController.text) ?? 0.0;
    final double oDaf = double.tryParse(oDafController.text) ?? 0.0;
    final double sDaf = double.tryParse(sDafController.text) ?? 0.0;
    final double qDaf = double.tryParse(qDafController.text) ?? 0.0;
    final double wP = double.tryParse(wPController.text) ?? 0.0;
    final double aD = double.tryParse(aDController.text) ?? 0.0;

    final double apMazut = aD * (100.0 - wP) / 100.0;

    double kMazut;
    if ((100.0 - wP - apMazut).abs() < 1e-9) {
      kMazut = double.infinity;
    } else {
      kMazut = (100.0 - wP - apMazut) / 100.0;
    }

    final double qphMazut = qDaf * kMazut - 0.025 * wP;
    final double cWorking = cDaf * kMazut;
    final double hWorking = hDaf * kMazut;
    final double sWorking = sDaf * kMazut;
    final double oWorking = oDaf * kMazut;

    // Update the state with the calculated results.
    setState(() {
      // Task 1 results
      qphResult = "Нижча теплотворна здатність (Qp_h): ${qph.toStringAsFixed(3)}";
      kpcResult = "Kpc: ${kpc.isInfinite ? 'Помилка (100-W=0)' : kpc.toStringAsFixed(3)}";
      kpgResult = "Kpg: ${kpg.isInfinite ? 'Помилка (100-W-A=0)' : kpg.toStringAsFixed(3)}";
      qchResult = "Qc_h: ${qch.isInfinite ? 'Помилка' : qch.toStringAsFixed(3)}";
      qghResult = "Qg_h: ${qgh.isInfinite ? 'Помилка' : qgh.toStringAsFixed(3)}";

      // Task 2 results
      apMazutResult = "Робоча зола (Ap): ${apMazut.toStringAsFixed(3)}";
      kMazutResult = "Коефіцієнт (K): ${kMazut.isInfinite ? 'Помилка (100-Wp-Ap=0)' : kMazut.toStringAsFixed(3)}";
      qphMazutResult = "Мазут Qp_h: ${qphMazut.isInfinite ? 'Помилка' : qphMazut.toStringAsFixed(3)} МДж/кг";
      cWorkingResult = "Мазут C_роб: ${cWorking.isInfinite ? 'Помилка' : cWorking.toStringAsFixed(3)}%";
      hWorkingResult = "Мазут H_роб: ${hWorking.isInfinite ? 'Помилка' : hWorking.toStringAsFixed(3)}%";
      sWorkingResult = "Мазут S_роб: ${sWorking.isInfinite ? 'Помилка' : sWorking.toStringAsFixed(3)}%";
      oWorkingResult = "Мазут O_роб: ${oWorking.isInfinite ? 'Помилка' : oWorking.toStringAsFixed(3)}%";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Калькулятор палива")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Task 1: Inputs
            const Text(
              "Розрахунок для твердого палива",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            _inputField("Водень (H), %", hp),
            _inputField("Вуглець (C), %", cp),
            _inputField("Сірка (S), %", sp),
            _inputField("Азот (N), %", np),
            _inputField("Кисень (O), %", op),
            _inputField("Волога (W), %", wp),
            _inputField("Зола (A), %", ap),
            const SizedBox(height: 20),

            // Button to trigger the calculation.
            ElevatedButton(
              onPressed: calculate,
              child: const Text("ОБЧИСЛИТИ"),
            ),
            const SizedBox(height: 20),

            // Task 1: Results
            const Text(
              "Результати розрахунку для твердого палива:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            _resultBox(qphResult, Colors.blue[50]!),
            const SizedBox(height: 10),
            _resultBox(kpcResult, Colors.blue[50]!),
            const SizedBox(height: 10),
            _resultBox(kpgResult, Colors.blue[50]!),
            const SizedBox(height: 10),
            _resultBox(qchResult, Colors.green[50]!),
            const SizedBox(height: 10),
            _resultBox(qghResult, Colors.green[50]!),
            const SizedBox(height: 30),
            const Divider(thickness: 2),
            const SizedBox(height: 30),

            // Task 2: Mazut Inputs
            const Text(
              "Розрахунок для мазуту",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            _inputField("Вуглець (C_daf), %", cDafController),
            _inputField("Водень (H_daf), %", hDafController),
            _inputField("Кисень (O_daf), %", oDafController),
            _inputField("Сірка (S_daf), %", sDafController),
            _inputField("Нижча теплотворна здатність (Q_daf), МДж/кг", qDafController),
            _inputField("Волога (W_p), %", wPController),
            _inputField("Зола (A_d), %", aDController),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: calculate,
              child: const Text("ОБЧИСЛИТИ"),
            ),
            const SizedBox(height: 20),

            // Task 2: Mazut Results
            const Text(
              "Результати розрахунку для мазуту:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            _resultBox(apMazutResult, Colors.orange[50]!),
            const SizedBox(height: 10),
            _resultBox(kMazutResult, Colors.orange[50]!),
            const SizedBox(height: 10),
            _resultBox(qphMazutResult, Colors.teal[50]!),
            const SizedBox(height: 10),
            _resultBox(cWorkingResult, Colors.teal[50]!),
            const SizedBox(height: 10),
            _resultBox(hWorkingResult, Colors.teal[50]!),
            const SizedBox(height: 10),
            _resultBox(sWorkingResult, Colors.teal[50]!),
            const SizedBox(height: 10),
            _resultBox(oWorkingResult, Colors.teal[50]!),
          ],
        ),
      ),
    );
  }

  // Helper widget to create a standardized input TextField.
  Widget _inputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }

  // Helper widget to display a calculation result in a styled box.
  Widget _resultBox(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}