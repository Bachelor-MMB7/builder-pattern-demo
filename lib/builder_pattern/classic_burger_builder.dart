import 'builder.dart';
import 'burger.dart';

/// KONKRETER BUILDER für klassische Burger
///
/// Implementiert das Builder Interface für einen klassischen Rindfleisch-Burger.
/// Die Basis-Zutaten (Brötchen, Patty) sind vordefiniert,
/// die optionalen Toppings können flexibel hinzugefügt werden.
class ClassicBurgerBuilder implements BurgerBuilder {
  // Feste Basis-Zutaten für den klassischen Burger
  final String _bun = 'Brioche';
  final String _patty = 'Rind';

  // Optionale Toppings - standardmäßig alle deaktiviert
  bool _cheese = false;
  bool _pickles = false;
  bool _tomato = false;
  bool _lettuce = false;
  String _sauce = 'Ketchup';

  @override
  String get builderName => 'Classic Burger Builder';

  @override
  String get bunType => _bun;

  @override
  String get pattyType => _patty;

  @override
  ClassicBurgerBuilder setCheese() {
    _cheese = true;
    return this; // Fluent Interface - ermöglicht Method Chaining
  }

  @override
  ClassicBurgerBuilder setPickles() {
    _pickles = true;
    return this;
  }

  @override
  ClassicBurgerBuilder setTomato() {
    _tomato = true;
    return this;
  }

  @override
  ClassicBurgerBuilder setLettuce() {
    _lettuce = true;
    return this;
  }

  @override
  ClassicBurgerBuilder setSauce(String sauce) {
    _sauce = sauce;
    return this;
  }

  @override
  ClassicBurgerBuilder reset() {
    _cheese = false;
    _pickles = false;
    _tomato = false;
    _lettuce = false;
    _sauce = 'Ketchup';
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