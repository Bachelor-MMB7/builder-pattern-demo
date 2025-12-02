import 'burger.dart';

//abstract interface because only abstract methods
abstract interface class BurgerBuilder {
  // Setter
  BurgerBuilder setCheese();
  BurgerBuilder setPickles();
  BurgerBuilder setSauce(String sauce);
  Burger build();

  // Getter
  String get builderName;
  String get bunType;
  String get pattyType;
}
