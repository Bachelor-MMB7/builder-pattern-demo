import 'burger.dart';

//abstract interface because only abstract methods
abstract interface class BurgerBuilder {
  // Setter
  BurgerBuilder setCheese();
  BurgerBuilder setOnions();
  BurgerBuilder setSauce(String sauce);
  Burger build();
  BurgerBuilder reset();

  // Getter
  String get builderName;
  String get bunType;
  String get pattyType;
}
