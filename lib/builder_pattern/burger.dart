class Burger {
  final String bun;
  final String patty;
  final bool cheese;
  final bool onions;
  final String sauce;

  Burger(this.bun, this.patty, this.cheese, this.onions, this.sauce);

  String getDescription() {
    final toppings = <String>[];
    if (cheese) toppings.add('Käse');
    if (onions) toppings.add('Zwiebeln');

    final toppingsText = toppings.isEmpty
        ? 'ohne Toppings'
        : 'mit ${toppings.join(', ')}';

    return '$bun-Brötchen, $patty-Patty, $toppingsText, $sauce-Sauce';
  }

  @override
  String toString() => 'Burger: ${getDescription()}';
}
