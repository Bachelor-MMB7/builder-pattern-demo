import 'builder.dart';
import 'burger.dart';

/// Der DIRECTOR
///
/// Der Director kennt die Reihenfolge der Bauabschnitte und kann
/// vordefinierte Burger-Varianten erstellen. Er arbeitet mit dem
/// abstrakten Builder-Interface, nicht mit konkreten Implementierungen.
///
/// Vorteile des Directors:
/// - Kapselt komplexe Erstellungslogik
/// - Ermöglicht vordefinierte Produktvarianten
/// - Client muss die Erstellungsschritte nicht kennen
class BurgerDirector {
  /// Erstellt einen Standard-Burger mit allen Toppings
  ///
  /// Der Director ruft die Builder-Methoden in einer bestimmten
  /// Reihenfolge auf - der Client muss diese nicht kennen.
  Burger makeFullyLoaded(BurgerBuilder builder) {
    return builder
        .reset()
        .setCheese()
        .setPickles()
        .setTomato()
        .setLettuce()
        .setSauce('Special Sauce')
        .build();
  }

  /// Erstellt einen minimalistischen Burger (nur Käse)
  Burger makeMinimal(BurgerBuilder builder) {
    return builder
        .reset()
        .setCheese()
        .build();
  }

  /// Erstellt einen klassischen Burger mit Käse und Gurken
  Burger makeClassicCombo(BurgerBuilder builder) {
    return builder
        .reset()
        .setCheese()
        .setPickles()
        .setSauce('Ketchup')
        .build();
  }

  /// Erstellt einen frischen Burger mit Salat und Tomaten
  Burger makeFreshBurger(BurgerBuilder builder) {
    return builder
        .reset()
        .setLettuce()
        .setTomato()
        .setSauce('Mayo')
        .build();
  }
}