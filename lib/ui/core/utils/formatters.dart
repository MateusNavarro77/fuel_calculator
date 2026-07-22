class AppFormatters {
  static String formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(2).replaceAll('.', ',');
    return 'R\$ $formatted';
  }

  static String formatDistance(double km) {
    final formatted = km.toStringAsFixed(1).replaceAll('.', ',');
    return '$formatted km';
  }

  static String formatLitres(double litres) {
    final formatted = litres.toStringAsFixed(2).replaceAll('.', ',');
    return '$formatted L';
  }
}
