# Flutter StatefulWidget & State - Komplette Erklärung

## Inhaltsverzeichnis
1. [StatelessWidget vs StatefulWidget](#1-statelesswidget-vs-statefulwidget)
2. [Warum zwei Klassen? Die Trennung verstehen](#2-warum-zwei-klassen-die-trennung-verstehen)
3. [Was erbt was? extends erklärt](#3-was-erbt-was-extends-erklärt)
4. [Der komplette Flow: Was passiert bei setState()](#4-der-komplette-flow-was-passiert-bei-setstate)
5. [Parent-Rebuilds: Der wahre Grund für die Trennung](#5-parent-rebuilds-der-wahre-grund-für-die-trennung)
6. [Widgets sind billig - Flutters Design-Philosophie](#6-widgets-sind-billig---flutters-design-philosophie)
7. [Best Practice: Wie strukturiere ich meine Widgets?](#7-best-practice-wie-strukturiere-ich-meine-widgets)
8. [Zusammenfassung: Die goldene Regel](#8-zusammenfassung-die-goldene-regel)

---

## 1. StatelessWidget vs StatefulWidget

### StatelessWidget
- Hat **keinen internen Zustand**, der sich ändern kann
- Wird **einmal gebaut** und bleibt so (außer der Parent (Bestellseite) rebuilt es)
- Perfekt für **statische UI-Elemente**: Labels, Icons, Layouts

```dart
class MeinLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Ich bin statisch und ändere mich nie");
  }
}
```

### StatefulWidget
- Hat einen **veränderlichen Zustand** (`State`)
- Kann sich **selbst neu bauen** wenn `setState()` aufgerufen wird
- Für **interaktive Elemente**: Buttons die sich ändern, Formulare, Counter

```dart
class BestellButton extends StatefulWidget {
  @override
  State<BestellButton> createState() => _BestellButtonState();
}

class _BestellButtonState extends State<BestellButton> {
  String buttonText = "Bestellen";

  void bestellen() {
    setState(() {
      buttonText = "Bestellt";  // Triggert Rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: bestellen,
      child: Text(buttonText),
    );
  }
}
```

### Wann brauche ich was?

| Szenario | Widget-Typ |
|----------|------------|
| Button-Text ändert sich nach Klick | `StatefulWidget` |
| Navigation zu anderer Seite | `StatelessWidget` reicht |
| Counter erhöht sich | `StatefulWidget` |
| Statisches Label anzeigen | `StatelessWidget` |
| Checkbox wird angehakt | `StatefulWidget` |

---

## 2. Warum zwei Klassen? Die Trennung verstehen

### Das häufigste Missverständnis

**Frage:** "Warum ist StatefulWidget unveränderlich? Kann ich es nicht gleich Stateless nennen?"

**Antwort:** Der Unterschied liegt nicht darin, ob die Klasse selbst veränderlich ist, sondern **was sie kann**:

| Widget-Typ | Kann State erstellen? | Hat Zugriff auf `setState()`? |
|------------|----------------------|-------------------------------|
| `StatelessWidget` | Nein | Nein |
| `StatefulWidget` | **Ja** | **Ja** (über State-Klasse) |

### Die zwei Klassen und ihre Aufgaben

```dart
// Klasse 1: Das Widget (macht fast NICHTS)
class BestellButton extends StatefulWidget {
  @override
  State<BestellButton> createState() => _BestellButtonState();

  // Das ist ALLES! Keine build() Methode, kein Zustand!
}

// Klasse 2: Der State (macht ALLES)
class _BestellButtonState extends State<BestellButton> {
  String buttonText = "Bestellen";  // Zustand

  @override
  Widget build(BuildContext context) {  // UI bauen
    return ElevatedButton(
      onPressed: () => setState(() => buttonText = "Bestellt"),
      child: Text(buttonText),
    );
  }
}
```

### Analogie: Bilderrahmen mit Schublade

- **StatelessWidget** = Ein Bilderrahmen (zeigt nur an, kann nichts speichern)
- **StatefulWidget** = Ein Bilderrahmen **mit Schublade** (die Schublade ist der `State`)

Der Rahmen selbst ändert sich nicht - aber er **hat** eine Schublade, in der du Sachen ändern kannst.

---

## 3. Was erbt was? extends erklärt

### Die Vererbungshierarchie

```dart
// StatefulWidget erbt von StatefulWidget-Basisklasse
class MeinButton extends StatefulWidget {
  @override
  State<MeinButton> createState() => _MeinButtonState();  // Von StatefulWidget geerbt
}

// State erbt von State<T>-Basisklasse
class _MeinButtonState extends State<MeinButton> {
  void klick() {
    setState(() { });  // Von State geerbt!
  }
}
```

### Wer bekommt was?

| Klasse | Erbt von | Bekommt dadurch |
|--------|----------|-----------------|
| `MeinButton` | `StatefulWidget` | `createState()` Methode |
| `_MeinButtonState` | `State<MeinButton>` | `setState()`, `build()`, `widget` Zugriff |

### Visualisiert

```
StatefulWidget          State<T>
     │                      │
     │ extends              │ extends
     ▼                      ▼
 MeinButton ──erstellt──► _MeinButtonState
                               │
                               ├── setState()  ← geerbt von State
                               ├── build()     ← geerbt von State
                               └── widget      ← Zugriff auf MeinButton
```

**Wichtig:** `setState()` ist in der **State-Klasse**, nicht im StatefulWidget!

---

## 4. Der komplette Flow: Was passiert bei setState()

### Alles passiert IN der State-Klasse

```dart
class _BestellButtonState extends State<BestellButton> {
  // 1. ZUSTAND (Variable)
  String buttonText = "Bestellen";

  // 2. ZUSTAND ÄNDERN
  void klick() {
    setState(() {
      buttonText = "Bestellt";
    });
  }

  // 3. UI BAUEN (auch in der State-Klasse!)
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: klick,
      child: Text(buttonText),  // Liest direkt die Variable
    );
  }
}
```

### Der Flow Schritt für Schritt

```
SCHRITT 1: Start
─────────────────
_BestellButtonState
  buttonText = "Bestellen"
        │
        ▼
  build() erzeugt:
  [Button: "Bestellen"]  ← User sieht das


SCHRITT 2: User klickt
──────────────────────
setState(() {
  buttonText = "Bestellt";  ← State ändert sich
});


SCHRITT 3: Rebuild
──────────────────
_BestellButtonState
  buttonText = "Bestellt"   ← State ist jetzt "Bestellt"
        │
        ▼
  build() wird NEU aufgerufen:
  [Button: "Bestellt"]  ← User sieht neuen Text
```

### Visualisiert als Diagramm

```
┌─────────────────────────────────────────────────────┐
│  _BestellButtonState (ALLES hier drin!)             │
│                                                     │
│  ┌───────────────┐                                  │
│  │ buttonText =  │ ← Zustand (bleibt bei Rebuild)   │
│  │ "Bestellen"   │                                  │
│  └───────┬───────┘                                  │
│          │                                          │
│          │ User klickt                              │
│          ▼                                          │
│  ┌───────────────┐                                  │
│  │ setState()    │ ← Ändert buttonText              │
│  │ buttonText =  │    zu "Bestellt"                 │
│  │ "Bestellt"    │                                  │
│  └───────┬───────┘                                  │
│          │                                          │
│          │ Triggert                                 │
│          ▼                                          │
│  ┌───────────────┐                                  │
│  │ build()       │ ← Wird NEU aufgerufen            │
│  │               │    Liest buttonText              │
│  │ return Text(  │    Baut neues UI                 │
│  │  buttonText)  │                                  │
│  └───────────────┘                                  │
│          │                                          │
└──────────┼──────────────────────────────────────────┘
           │
           ▼
    ┌─────────────┐
    │ UI (Screen) │ ← Das was der User sieht
    │ "Bestellt"  │    (außerhalb der Klasse)
    └─────────────┘
```

### Wichtig zu verstehen

- Der State wird **nur** geändert, wenn **du selbst** `setState()` aufrufst
- `setState()` ruft automatisch `build()` auf
- `build()` liest den aktuellen State und baut das UI daraus

---

## 5. Parent-Rebuilds: Der wahre Grund für die Trennung

### Das Kernproblem

**Frage:** "Warum kann nicht alles in einer Klasse sein?"

**Antwort:** Weil Widgets von **außen** (Parent) neu erstellt werden können!

### Beispiel: Bestellseite mit Button

```dart
class BestellSeite extends StatefulWidget { ... }

class _BestellSeiteState extends State<BestellSeite> {
  int anzahl = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Anzahl: $anzahl"),
        BestellButton(),  // ← Wird bei JEDEM setState() NEU erstellt!
        ElevatedButton(
          onPressed: () => setState(() => anzahl++),
          child: Text("Mehr"),
        ),
      ],
    );
  }
}
```

### Was passiert wenn "Mehr" geklickt wird?

```
setState() in _BestellSeiteState
        │
        ▼
build() wird aufgerufen
        │
        ▼
BestellButton()  ← NEUES Widget-Objekt wird erstellt!
```

Flutter erstellt ein **komplett neues** `BestellButton()` Objekt.

### OHNE Trennung: State wäre verloren!

```dart
// HYPOTHETISCH - wenn alles in einer Klasse wäre
class BestellButton extends StatefulWidget {
  String buttonText = "Bestellt";  // Zustand im Widget
}

// Bei Rebuild durch Parent:
BestellButton()  // NEUES Objekt → buttonText = "Bestellen" wieder! 💥
```

**Der Zustand wäre weg!**

### MIT Trennung: State bleibt erhalten

```dart
class BestellButton extends StatefulWidget { }  // Leere Hülle

class _BestellButtonState extends State<BestellButton> {
  String text = "Bestellt";  // Hier sicher!
}
```

```
Parent macht setState()
        │
        ▼
BestellButton() ← Neues Widget-Objekt (OK, ist billig)
        │
        │ Flutter schaut: "Gibt's schon einen State für diesen Widget-Typ?"
        │
        ▼
_BestellButtonState ← JA! Alter State wird WIEDERVERWENDET!
  buttonText = "Bestellt"  ✓ Zustand erhalten!
```

### Visualisiert: Widget neu, State bleibt

```
BestellButton() NEU     →    _BestellButtonState BLEIBT
BestellButton() NEU     →    _BestellButtonState BLEIBT
BestellButton() NEU     →    _BestellButtonState BLEIBT
                                text = "Bestellt" ✓
```

### Mehrere Widgets auf einer Seite

```dart
class _BestellSeiteState extends State<BestellSeite> {
  int anzahl = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Anzahl: $anzahl"),   // Widget 1
        BestellButton(),            // Widget 2 (hat eigenen State)
        WarenkorbButton(),          // Widget 3 (hat eigenen State)
      ],
    );
  }
}
```

### Wenn `anzahl` sich ändert:

```
setState(() => anzahl = 2) in _BestellSeiteState
        │
        ▼
build() von _BestellSeiteState wird aufgerufen
        │
        ▼
┌───────────────────────────────────────────────────────┐
│                                                       │
│  Text("Anzahl: 2")      ← NEU gebaut, zeigt "2"       │
│                                                       │
│  BestellButton()        ← Neues Widget-Objekt, ABER:  │
│       │                                               │
│       └► _BestellButtonState ← GESCHÜTZT!             │
│          buttonText = "Bestellt" bleibt               │
│                                                       │
│  WarenkorbButton()      ← Neues Widget-Objekt, ABER:  │
│       │                                               │
│       └► _WarenkorbButtonState ← GESCHÜTZT!           │
│          items = 3 bleibt                             │
│                                                       │
└───────────────────────────────────────────────────────┘
```

---

## 6. Widgets sind billig - Flutters Design-Philosophie

### Warum wirft Flutter Widgets weg?

**Frage:** "Warum darf das Widget-Objekt weggeworfen werden? Kann man es nicht einfach behalten?"

**Antwort:** Das ist eine bewusste Design-Entscheidung für **Performance**.

### Flutter's Philosophie

```dart
// Bei jedem build() werden ALLE Widgets neu erstellt
@override
Widget build(BuildContext context) {
  return Column(          // Neu
    children: [
      Text("Hallo"),      // Neu
      BestellButton(),    // Neu
      Icon(Icons.star),   // Neu
    ],
  );
}
```

Flutter macht das **absichtlich** so!

### Warum nicht alles behalten und updaten?

```dart
// Stell dir vor: Widget ändert sich
build() {
  return BestellButton(farbe: rot);   // Vorher
}

build() {
  return BestellButton(farbe: blau);  // Nachher - neue Farbe!
}
```

Wenn Flutter das alte Widget **behalten** würde, müsste es:
1. Checken was sich geändert hat
2. Nur die Unterschiede updaten
3. Komplizierte Vergleichslogik haben

Stattdessen sagt Flutter: **"Wirf alles weg, bau neu, ist schneller!"**

### Die Trennung ermöglicht das Beste aus beiden Welten

```
┌─────────────────────────────────────────────┐
│  Widget (billig, wird weggeworfen)          │
│  - Konfiguration (Farbe, Text, etc.)        │
│  - Kann sich ändern → einfach neu bauen     │
└─────────────────────────────────────────────┘
                    │
                    │ verbunden mit
                    ▼
┌─────────────────────────────────────────────┐
│  State (teuer, wird behalten)               │
│  - User-Eingaben                            │
│  - Netzwerk-Daten                           │
│  - Muss überleben                           │
└─────────────────────────────────────────────┘
```

### Was gehört wo?

```dart
class BestellButton extends StatefulWidget {
  final Color farbe;  // ← Kann weggeworfen werden (kommt vom Parent)

  @override
  State<BestellButton> createState() => _BestellButtonState();
}

class _BestellButtonState extends State<BestellButton> {
  String text = "Bestellt";   // ← Wird behalten!
  int klicks = 5;             // ← Wird behalten!
  bool aktiv = true;          // ← Wird behalten!
}
```

### Warum speichert das Kind Daten vom Parent? - Parent übergibt bei jedem Rebuild neu - Alles außerhalb der State Klasse und im StatefulWidget wird somit gerebuildet im Kind, alte Parameter des Objekts verschwinden

Das Parent-Widget (z.B. Bestellseite) legt Eigenschaften wie Farbe fest und übergibt sie bei **jedem Rebuild neu**:

```dart
// Parent-Widget (Bestellseite)
class _BestellSeiteState extends State<BestellSeite> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BestellButton(farbe: Colors.red),   // ← Parent sagt: "Sei rot!"
      ],
    );
  }
}
```

```dart
// Kind-Widget (BestellButton) - empfängt die Farbe
class BestellButton extends StatefulWidget {
  final Color farbe;  // ← Speichert was vom Parent kam

  BestellButton({required this.farbe});  // ← Konstruktor empfängt es

  @override
  State<BestellButton> createState() => _BestellButtonState();
}

class _BestellButtonState extends State<BestellButton> {
  String text = "Bestellen";

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.farbe,  // ← Zugriff auf Parent-Wert mit "widget."
      ),
      onPressed: () => setState(() => text = "Bestellt"),
      child: Text(text),
    );
  }
}
```

### Was passiert bei Parent-Rebuild?

```dart
// Parent gibt immer den Wert vor
BestellButton(farbe: Colors.red)  // Parent sagt: "rot"

// Bei Rebuild:
BestellButton(farbe: Colors.red)  // Parent sagt wieder: "rot" (neues Objekt, gleicher Wert)

// Oder Parent ändert es:
BestellButton(farbe: Colors.blue) // Parent sagt jetzt: "blau" (neues Objekt, neuer Wert)
```

### Visualisiert:

```
VORHER:                              NACHHER (Parent Rebuild):
───────                              ────────────────────────
BestellButton (Objekt A)             BestellButton (Objekt B) ← NEUES Objekt!
  farbe = rot  → VERSCHWINDET          farbe = blau ← NEU vom Parent

_BestellButtonState                  _BestellButtonState ← GLEICHER State!
  text = "Bestellt" ✓                  text = "Bestellt" ✓ BLEIBT
```

### Der Unterschied: Wer bestimmt den Wert?

| Variable | Wo | Wer bestimmt | Bei Rebuild |
|----------|-----|--------------|-------------|
| `farbe` | StatefulWidget | **Parent** bestimmt | Parent übergibt neu |
| `text` | State | **Widget selbst** bestimmt | Bleibt erhalten |

**Kurz:**
- `farbe` kommt von **außen** (Parent übergibt bei jedem Rebuild neu) → gehört ins Widget
- `text` kommt von **innen** (Widget verwaltet es selbst) → gehört in den State

### Bei Rebuild:

```
StatefulWidget              State
──────────────              ─────
farbe = rot   → WEG         text = "Bestellt"  → BLEIBT
farbe = blau  → NEU         klicks = 5         → BLEIBT
                            aktiv = true       → BLEIBT
```

---

## 7. Best Practice: Wie strukturiere ich meine Widgets?

### Option 1: Alles in EINEM State (einfacher, aber weniger effizient)

```dart
class BestellSeite extends StatefulWidget {
  @override
  State<BestellSeite> createState() => _BestellSeiteState();
}

class _BestellSeiteState extends State<BestellSeite> {
  // Alle Zustände hier
  String button1Text = "Bestellen";
  String button2Text = "In Warenkorb";
  int anzahl = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => setState(() => button1Text = "Bestellt"),
          child: Text(button1Text),
        ),
        ElevatedButton(
          onPressed: () => setState(() => button2Text = "Im Warenkorb"),
          child: Text(button2Text),
        ),
      ],
    );
  }
}
```

**Problem:** Bei `setState()` wird die GANZE Seite neu gebaut.

### Option 2: Jeder Button eigener State (besser)

```dart
// Bestellseite - kann sogar Stateless sein!
class BestellSeite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BestellButton(),    // Hat eigenen State
        WarenkorbButton(),  // Hat eigenen State
      ],
    );
  }
}

// Jeder Button verwaltet sich selbst
class BestellButton extends StatefulWidget {
  @override
  State<BestellButton> createState() => _BestellButtonState();
}

class _BestellButtonState extends State<BestellButton> {
  String text = "Bestellen";

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => setState(() => text = "Bestellt"),
      child: Text(text),
    );
  }
}
```

### Unterschied bei Klick:

| Ansatz | Bei Klick auf Button 1 |
|--------|------------------------|
| Option 1 (ein State) | Ganze Seite wird rebuilt |
| Option 2 (getrennte States) | Nur Button 1 wird rebuilt |

### Empfohlene Struktur

```
BestellSeite (StatelessWidget - nur Layout)
    │
    ├── BestellButton (StatefulWidget - eigener State)
    │       └── _BestellButtonState
    │
    ├── WarenkorbButton (StatefulWidget - eigener State)
    │       └── _WarenkorbButtonState
    │
    └── AnzahlWidget (StatefulWidget - eigener State)
            └── _AnzahlWidgetState
```

### Jedes Widget ist eine eigene Insel

```
BestellSeite              ← Weiß von nichts, macht nichts
    │
    ├── BestellButton
    │       │
    │       └── _BestellButtonState
    │               │
    │               └── setState() ← Nur HIER passiert was
    │                       │
    │                       ▼
    │                   build() ← Nur DIESE build() läuft
    │
    └── WarenkorbButton   ← Unberührt, keine Ahnung
```

`setState()` ruft nur die `build()` Methode der **eigenen** State-Klasse auf.

---

## 8. Zusammenfassung: Die goldene Regel

### Die eine Regel die alles erklärt

> **Alles in der State-Klasse wird geschützt.**
> **Alles außerhalb (im StatefulWidget) kann weggeworfen werden.**

```dart
class BestellButton extends StatefulWidget {
  // HIER: Kann weggeworfen werden
  final Color farbe;

  @override
  State<BestellButton> createState() => _BestellButtonState();
}

class _BestellButtonState extends State<BestellButton> {
  // HIER: Geschützt, überlebt Rebuilds
  String text = "Bestellt";
  int klicks = 5;
}
```

### Warum existiert die Trennung?

| Grund | Erklärung |
|-------|-----------|
| Parent-Rebuilds | Widgets werden von außen neu erstellt, State muss überleben |
| Performance | Widgets wegwerfen ist schneller als vergleichen |
| Einfachheit | Keine komplizierte Update-Logik nötig |

### Wann StatefulWidget, wann StatelessWidget?

| Frage | Antwort |
|-------|---------|
| Ändert sich was durch User-Interaktion auf DIESEM Widget? | `StatefulWidget` |
| Zeigt das Widget nur statische Daten? | `StatelessWidget` |
| Navigiert das Widget nur woanders hin? | `StatelessWidget` reicht |

### Der komplette Rebuild-Flow

```
1. setState() wird aufgerufen
         │
         ▼
2. State-Variable wird geändert
         │
         ▼
3. build() wird neu aufgerufen
         │
         ▼
4. build() liest die State-Variablen
         │
         ▼
5. Neues UI wird angezeigt
         │
         ▼
6. Alle Kind-Widget-Objekte werden neu erstellt
         │
         ▼
7. Aber: Alle Kind-States bleiben erhalten!
```

---

## Glossar

| Begriff | Bedeutung |
|---------|-----------|
| **Widget** | UI-Baustein in Flutter |
| **State** | Veränderlicher Zustand eines Widgets |
| **setState()** | Methode um State zu ändern und Rebuild zu triggern |
| **build()** | Methode die das UI baut |
| **Rebuild** | Neuaufbau des UI durch erneuten Aufruf von build() |
| **Parent** | Das übergeordnete Widget |
| **Child/Kind** | Ein Widget das in einem anderen Widget enthalten ist |