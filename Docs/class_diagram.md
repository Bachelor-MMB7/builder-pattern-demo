```mermaid
classDiagram
    direction LR

    class BurgerBuilder {
        <<interface>>
        +setCheese() BurgerBuilder
        +setPickles() BurgerBuilder
        +setSauce(String) BurgerBuilder
        +build() Burger
    }

    class ClassicBurgerBuilder {
        -String _bun
        -String _patty
        -bool _cheese
        -bool _pickles
        -String _sauce
        +setCheese() ClassicBurgerBuilder
        +setPickles() ClassicBurgerBuilder
        +setSauce(String) ClassicBurgerBuilder
        +build() Burger
    }

    class VeggieBurgerBuilder {
        -String _bun
        -String _patty
        -bool _cheese
        -bool _pickles
        -String _sauce
        +setCheese() VeggieBurgerBuilder
        +setPickles() VeggieBurgerBuilder
        +setSauce(String) VeggieBurgerBuilder
        +build() Burger
    }

    class Burger {
        <<Product>>
        +String bun
        +String patty
        +bool cheese
        +bool pickles
        +String sauce
        +getDescription() String
    }

    class BurgerDirector {
        <<Director>>
        +makeFullyLoaded(BurgerBuilder) Burger
        +makeCheeseLover(BurgerBuilder) Burger
    }

    BurgerBuilder <|.. ClassicBurgerBuilder : implements
    BurgerBuilder <|.. VeggieBurgerBuilder : implements
    ClassicBurgerBuilder ..> Burger : creates
    VeggieBurgerBuilder ..> Burger : creates
    BurgerDirector --> BurgerBuilder : uses
```
