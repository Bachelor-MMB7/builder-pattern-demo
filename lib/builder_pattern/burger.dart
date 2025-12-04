class Burger {
  final String bun;
  final String patty;
  final bool cheese;
  final bool pickles;
  final String sauce;

  Burger(this.bun, this.patty, this.cheese, this.pickles, this.sauce);

  String getDescription() {
    final toppings = <String>[];
    if (cheese) toppings.add('Käse');
    if (pickles) toppings.add('Gürkchen');

    final toppingsText = toppings.isEmpty
        ? 'ohne Toppings'
        : 'mit ${toppings.join(', ')}';

    return '$bun-Brötchen, $patty-Patty, $toppingsText, $sauce-Sauce';
  }
}
