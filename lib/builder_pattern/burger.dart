/// Das PRODUKT - Ein immutabler Burger
///
/// Diese Klasse repräsentiert das fertige Produkt, das vom Builder erstellt wird.
/// Alle Eigenschaften sind final und werden über den Konstruktor gesetzt.
class Burger {
  final String bun;
  final String patty;
  final bool cheese;
  final bool pickles;
  final bool tomato;
  final bool lettuce;
  final String sauce;

  /// Privater Konstruktor - nur der Builder kann einen Burger erstellen
  Burger({
    required this.bun,
    required this.patty,
    required this.cheese,
    required this.pickles,
    required this.tomato,
    required this.lettuce,
    required this.sauce,
  });

  /// Gibt eine lesbare Beschreibung des Burgers zurück
  String getDescription() {
    final toppings = <String>[];
    if (cheese) toppings.add('Käse');
    if (pickles) toppings.add('Gurken');
    if (tomato) toppings.add('Tomaten');
    if (lettuce) toppings.add('Salat');

    final toppingsText = toppings.isEmpty
        ? 'ohne Toppings'
        : 'mit ${toppings.join(', ')}';

    return '$bun-Brötchen, $patty-Patty, $toppingsText, $sauce-Sauce';
  }

  @override
  String toString() => 'Burger: ${getDescription()}';
}