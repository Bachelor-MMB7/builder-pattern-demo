# ...List.generate - Erklärung

## Der Code:
```dart
...List.generate(_createdBurgers.length, (index) {
    final burger = _createdBurgers[index];
    return ListTile(...);
})
```

---

## Was passiert Schritt für Schritt:

### 1. Ausgangslage: Burger-Liste (Daten)
```
_createdBurgers = [Burger1, Burger2, Burger3]
                      ↑         ↑        ↑
                   Objekte, keine Widgets!
```

### 2. List.generate erstellt NEUE Widget-Liste
```
List.generate liest _createdBurgers und baut daraus:

[ListTile1, ListTile2, ListTile3]   ← neue Widget-Liste
```

### 3. Spread Operator (...) entpackt die Liste
```
Vorher (Liste):     [ListTile1, ListTile2, ListTile3]
                                    ↓
                                   ...
                                    ↓
Nachher (einzeln):   ListTile1, ListTile2, ListTile3
```

### 4. children bekommt einzelne Widgets
```dart
children: [
    Card(...),
    ListTile1,    ← entpackt
    ListTile2,    ← entpackt
    ListTile3,    ← entpackt
]
```

---

## Wichtig:
- `_createdBurgers` wird **nur gelesen**, nicht verändert
- `List.generate` **erstellt** die Widget-Liste
- `...` (spread operator) **entpackt** die Liste
- Flutter's Regel: `children` akzeptiert nur einzelne Widgets, keine Listen

---

## Warum nicht einfach die Liste übergeben?
```dart
// ❌ FEHLER - Flutter akzeptiert keine Liste in children
children: [
    Card(...),
    [ListTile1, ListTile2, ListTile3],  // ← Liste in Liste = Fehler!
]

// ✅ RICHTIG - mit ... entpackt
children: [
    Card(...),
    ...List.generate(...)  // ← wird zu einzelnen Widgets entpackt
]
```