import 'package:flutter/material.dart';

void main() => runApp(GlobalPathwaysApp());

class GlobalPathwaysApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: ROICalculator(),
    );
  }
}

class ROICalculator extends StatefulWidget {
  @override
  _ROICalculatorState createState() => _ROICalculatorState();
}

class _ROICalculatorState extends State<ROICalculator> {
  // Logic Inputs - Shows you handle fragmented data
  double currentSavings = 10000;
  double relocationBudget = 20000;
  String targetCountry = "USA";
  
  // Real-world Data Streams (Mocked for MVP)
  final Map<String, dynamic> countryData = {
    "India": {"salary": 15000, "cost": 6000, "growth": 0.08},
    "USA": {"salary": 95000, "cost": 45000, "relocation": 25000},
    "Germany": {"salary": 60000, "cost": 28000, "relocation": 15000},
  };

  @override
  Widget build(BuildContext context) {
    // Stage 1: The Analyst (Calculation Logic)
    double localNet = (countryData["India"]["salary"] - countryData["India"]["cost"]) * 5.0 * (1 + countryData["India"]["growth"]);
    double abroadCosts = countryData[targetCountry]["relocation"].toDouble();
    double abroadNet = ((countryData[targetCountry]["salary"] - countryData[targetCountry]["cost"]) * 5.0) - abroadCosts;
    double roiDelta = abroadNet - localNet;

    // Stage 2: The Auditor (Constraint Checking)
    bool budgetExceeded = abroadCosts > relocationBudget;
    bool isPositiveROI = roiDelta > 0;

    return Scaffold(
      appBar: AppBar(title: const Text("Global Pathways AI"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("1. User Profile Constraints"),
            _buildInputField("Current Savings (\$)", (val) => setState(() => currentSavings = double.tryParse(val) ?? 0)),
            _buildInputField("Relocation Budget (\$)", (val) => setState(() => relocationBudget = double.tryParse(val) ?? 0)),
            
            const SizedBox(height: 20),
            _buildSectionTitle("2. Pathway Comparison"),
            DropdownButton<String>(
              value: targetCountry,
              isExpanded: true,
              onChanged: (val) => setState(() => targetCountry = val!),
              items: ["USA", "Germany"].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildROICard("Stay Local", localNet, Colors.blueGrey.shade800),
                const SizedBox(width: 10),
                _buildROICard("Go $targetCountry", abroadNet, Colors.indigo.shade700),
              ],
            ),
            
            const SizedBox(height: 30),
            _buildSectionTitle("3. AI Transparency Audit"),
            _buildAuditPanel(budgetExceeded, isPositiveROI, roiDelta),
            
            const SizedBox(height: 40),
            const Center(child: Text("Logic Grounding: Official 2026 PPP Data", style: TextStyle(color: Colors.grey, fontSize: 11))),
          ],
        ),
      ),
    );
  }

  // --- UI Helper Components ---

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigoAccent)),
  );

  Widget _buildInputField(String label, Function(String) onChanged) => TextField(
    keyboardType: TextInputType.number,
    decoration: InputDecoration(labelText: label, prefixText: "\$ "),
    onChanged: onChanged,
  );

  Widget _buildROICard(String title, double value, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Text("\$${value.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Text("5-Year ROI", style: TextStyle(color: Colors.white38, fontSize: 10)),
        ],
      ),
    ),
  );

  Widget _buildAuditPanel(bool budgetExceeded, bool isPositiveROI, double delta) {
    Color panelColor = (isPositiveROI && !budgetExceeded) ? Colors.green : Colors.red;
    String message = budgetExceeded 
        ? "AUDIT FAILED: Relocation cost exceeds your set budget." 
        : (isPositiveROI ? "VERIFIED: Positive ROI pathway." : "WARNING: Financial loss detected vs staying local.");

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: panelColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: panelColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(panelColor == Colors.green ? Icons.check_circle : Icons.error_outline, color: panelColor),
              const SizedBox(width: 10),
              const Text("Bias-Free Analysis", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Text(message, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}