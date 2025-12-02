import 'burger.dart';

//abstract interface because only abstract methods
abstract interface class BurgerBuilder {
  BurgerBuilder setCheese();
  BurgerBuilder setPickles();
  BurgerBuilder setSauce(String sauce);
  Burger build();
}
