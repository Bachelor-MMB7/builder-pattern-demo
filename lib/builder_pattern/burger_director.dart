import 'builder.dart';
import 'burger.dart';

class BurgerDirector {
  Burger makeFullyLoaded(BurgerBuilder builder) {
    return builder
        .setCheese()
        .setOnions()
        .setSauce('BBQ')
        .build();
  }

  Burger makeMinimal(BurgerBuilder builder) {
    return builder
        .setCheese()
        .build();
  }
}
