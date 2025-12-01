import 'builder.dart';
import 'burger.dart';

class ClassicBurgerBuilder implements BurgerBuilder {
  final String _bun = 'Brioche';
  final String _patty = 'Rind';

  bool _cheese = false;
  bool _onions = false;
  String _sauce = 'Ketchup';

  // Why no constructor? Because all attributes have default values.
  // If values varied per instance (e.g., different restaurant branches
  // with different suppliers: Munich uses 'Laugenbrot', Berlin uses 'Schrippe'),
  // we would need a constructor to pass these values in. Or height and weight
  // for a PersonBuilder.

  @override
  String get builderName => 'Classic Burger Builder';

  // Getter
  @override
  String get bunType => _bun;

  @override
  String get pattyType => _patty;

  // Setter
  @override
  ClassicBurgerBuilder setCheese() {
    _cheese = true;
    return this;
  }

  @override
  ClassicBurgerBuilder setOnions() {
    _onions = true;
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
    _onions = false;
    _sauce = 'Ketchup';
    return this;
  }

  @override
  Burger build() {
    return Burger(_bun, _patty, _cheese, _onions, _sauce);
  }
}
