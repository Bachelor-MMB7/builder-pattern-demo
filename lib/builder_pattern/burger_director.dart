import 'builder.dart';
import 'burger.dart';

class BurgerDirector {
  Burger makeFullyLoaded(BurgerBuilder builder) {
    return builder
        .reset()
        .setCheese()
        .setOnions()
        .setSauce('BBQ')
        .build();
  }

  Burger makeMinimal(BurgerBuilder builder) {
    return builder
        .reset()
        .setCheese()
        .build();
  }

  Burger makeClassicCombo(BurgerBuilder builder) {
    return builder
        .reset()
        .setCheese()
        .setOnions()
        .setSauce('Ketchup')
        .build();
  }
}
