import 'builder.dart';
import 'burger.dart';

class BurgerDirector {
  Burger makeFullyLoaded(BurgerBuilder builder) {
    return builder
        .setCheese()
        .setPickles()
        .setSauce('BBQ')
        .build();
  }

  Burger makeCheeseLover(BurgerBuilder builder) {
    return builder
        .setCheese()
        .setSauce('Mayonnaise')
        .build();
  }
}
