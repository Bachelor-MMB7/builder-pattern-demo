import 'builder.dart';
import 'burger.dart';

/// KONKRETER BUILDER für vegetarische Burger
///
/// Implementiert das Builder Interface für einen vegetarischen Burger.
/// Zeigt, wie verschiedene Builder das gleiche Interface implementieren,
/// aber unterschiedliche Basis-Zutaten verwenden.
class VeggieBurgerBuilder implements BurgerBuilder {
  // Feste Basis-Zutaten für den Veggie Burger
  final String _bun = 'Vollkorn';
  final String _patty = 'Gemüse';

  // Optionale Toppings
  bool _cheese = false;
  bool _pickles = false;
  bool _tomato = false;
  bool _lettuce = false;
  String _sauce = 'Hummus';

  @override
  String get builderName => 'Veggie Burger Builder';

  @override
  String get bunType => _bun;

  @override
  String get pattyType => _patty;

  @override
  VeggieBurgerBuilder setCheese() {
    _cheese = true;
    return this;
  }

  @override
  VeggieBurgerBuilder setPickles() {
    _pickles = true;
    return this;
  }

  @override
  VeggieBurgerBuilder setTomato() {
    _tomato = true;
    return this;
  }

  @override
  VeggieBurgerBuilder setLettuce() {
    _lettuce = true;
    return this;
  }

  @override
  VeggieBurgerBuilder setSauce(String sauce) {
    _sauce = sauce;
    return this;
  }

  @override
  VeggieBurgerBuilder reset() {
    _cheese = false;
    _pickles = false;
    _tomato = false;
    _lettuce = false;
    _sauce = 'Hummus';
    return this;
  }

  @override
  Burger build() {
    return Burger(
      bun: _bun,
      patty: _patty,
      cheese: _cheese,
      pickles: _pickles,
      tomato: _tomato,
      lettuce: _lettuce,
      sauce: _sauce,
    );
  }
}