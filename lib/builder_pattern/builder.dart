import 'burger.dart';

/// Das BUILDER INTERFACE
///
/// Definiert die Schritte, die jeder konkrete Builder implementieren muss.
/// Jede Methode gibt den Builder selbst zurück (Fluent Interface),
/// um Method Chaining zu ermöglichen: builder.setCheese().setPickles().build()
abstract interface class BurgerBuilder {
  /// Setzt Käse auf den Burger
  BurgerBuilder setCheese();

  /// Setzt Gurken auf den Burger
  BurgerBuilder setPickles();

  /// Setzt Tomaten auf den Burger
  BurgerBuilder setTomato();

  /// Setzt Salat auf den Burger
  BurgerBuilder setLettuce();

  /// Setzt die Sauce
  BurgerBuilder setSauce(String sauce);

  /// Erstellt das fertige Burger-Objekt
  Burger build();

  /// Setzt den Builder auf Standardwerte zurück
  BurgerBuilder reset();

  /// Getter für den Builder-Namen (für UI)
  String get builderName;

  /// Getter für die Basis-Zutaten (für UI)
  String get bunType;
  String get pattyType;
}