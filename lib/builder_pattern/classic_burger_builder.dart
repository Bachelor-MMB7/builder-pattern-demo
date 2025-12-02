import 'builder.dart';
import 'burger.dart';

class ClassicBurgerBuilder implements BurgerBuilder {
  final String _bun = 'Brioche';
  final String _patty = 'Rind';

  bool _cheese = false;
  bool _pickles = false;
  String _sauce = 'Ketchup';

  // Why no constructor? Because all attributes have default values.
  // If values varied per instance (e.g., different restaurant branches
  // with different suppliers: Munich uses 'Laugenbrot', Berlin uses 'Schrippe'),
  // we would need a constructor to pass these values in. Or height and weight
  // for a PersonBuilder.

  @override
  ClassicBurgerBuilder setCheese() {
    _cheese = true;
    return this;
  }

  @override
  ClassicBurgerBuilder setPickles() {
    _pickles = true;
    return this;
  }

  @override
  ClassicBurgerBuilder setSauce(String sauce) {
    _sauce = sauce;
    return this;
  }

  @override
  Burger build() {
    return Burger(_bun, _patty, _cheese, _pickles, _sauce);
  }
}
