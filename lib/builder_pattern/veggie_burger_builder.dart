import 'builder.dart';
import 'burger.dart';

class VeggieBurgerBuilder implements BurgerBuilder {
  final String _bun = 'Vollkorn';
  final String _patty = 'Gemüse';

  bool _cheese = false;
  bool _pickles = false;
  String _sauce = 'Mayo';

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
  VeggieBurgerBuilder setSauce(String sauce) {
    _sauce = sauce;
    return this;
  }

  @override
  Burger build() {
    return Burger(_bun, _patty, _cheese, _pickles, _sauce);
  }
}
