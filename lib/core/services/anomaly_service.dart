import 'dart:math';

class AnomalyService {
  // Mock thresholds for demo purpose
  final Map<String, double> _thresholds = {
    'Alimentação': 300.0,
    'Transporte': 150.0,
    'Despesas': 1000.0,
  };

  /// Checks if a transaction is anomalous based on local rules.
  /// Returns a warning message if anomalous, or null if normal.
  String? detectAnomaly(double amount, String category) {
    // 1. Check against simple threshold
    final threshold = _thresholds[category] ?? 500.0;
    if (amount > threshold * 1.5) {
      return "⚠️ Gasto de ${category} 50% acima da média!";
    }

    // 2. Random "AI Intuition" (Simulated pattern recognition)
    // In a real app, this would use TensorFlow Lite or Cloud Functions
    if (amount > threshold && Random().nextBool()) {
      return "🤖 Padrão incomum detectado para ${category}.";
    }

    return null;
  }
}
