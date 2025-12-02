import 'package:flutter/material.dart';
import 'builder_pattern/builder_pattern_export.dart';

void main() {
  runApp(const BuilderPatternDemoApp());
}

// Stateless because no reloading of the page is needed, no changes of UI or button text
class BuilderPatternDemoApp extends StatelessWidget {

  // fragen
  const BuilderPatternDemoApp({super.key});

  // Erstellung UI-Objekt
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Builder Pattern Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const BurgerBuilderPage(),
    );
  }
}

// Start screen erbt State von StatefulWidget, um State zu erstellen
class BurgerBuilderPage extends StatefulWidget {
  const BurgerBuilderPage({super.key});

  @override
  State<BurgerBuilderPage> createState() => _BurgerBuilderPageState();
}

class _BurgerBuilderPageState extends State<BurgerBuilderPage> {
  // State-Variablen
  bool _isVeggie = false;
  bool _cheese = false;
  bool _onions = false;
  String _sauce = 'Ketchup';
  final List<Burger> _createdBurgers = [];
  final BurgerDirector _director = BurgerDirector();

  // Manuell Burger bauen (ohne Director)
  Burger _buildBurgerManually() {
    final builder = _isVeggie ? VeggieBurgerBuilder() : ClassicBurgerBuilder();
    if (_cheese) builder.setCheese();
    if (_onions) builder.setOnions();
    builder.setSauce(_sauce);
    return builder.build();
  }

  // Code Preview für manuelles Bauen
  String _getCodePreview() {
    final builderName = _isVeggie ? 'VeggieBurgerBuilder' : 'ClassicBurgerBuilder';
    final methods = <String>[];
    if (_cheese) methods.add('.setCheese()');
    if (_onions) methods.add('.setOnions()');
    methods.add('.setSauce("$_sauce")');

    return 'var builder = $builderName();\n'
           'var burger = builder\n'
           '    ${methods.join('\n    ')}\n'
           '    .build();';
  }

  // UI needs to be updated, therefore setState
  void _addBurger(Burger burger) {
    setState(() {
      _createdBurgers.add(burger); // fügt den erstellten Burger der Liste hinzu
    });
  }

  void _showSnackBar(String message) {
    // Start from here -> .of(context) searches upwards the tree for the
    // ScaffoldMessenger in Scaffold and tells it to show the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // context = "Hier bin ich im Widget-Baum" (meine aktuelle Position)
  // Flutter übergibt context automatisch an build()
  // Mit .of(context) sucht Flutter von dieser Position nach oben im Baum
  // z.B. Theme.of(context) sucht das nächste Theme oberhalb
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Builder Pattern Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === 1. Builder Auswahl ===
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1. Wähle einen Builder',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('Classic Burger'),
                          selected: !_isVeggie,
                          // Wenn _isVeggie = false (Classic aktiv):
                          // !false = true → Classic ist BLAU ✓
                          onSelected: (_) => setState(() {
                            _isVeggie = false;
                            _cheese = false;
                            _onions = false;
                            _sauce = 'Ketchup';
                          }),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Veggie Burger'),
                          selected: _isVeggie,
                          onSelected: (_) => setState(() {
                            _isVeggie = true;
                            _cheese = false;
                            _onions = false;
                            _sauce = 'Ketchup';
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // === 2. Manuell bauen (ohne Director) ===
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2. Manuell bauen (ohne Director)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Du rufst die Builder-Methoden selbst auf:',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    // Toppings
                    Wrap(
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('Käse'),
                          selected: _cheese, // sagt aktuellen Status (true/false), Flutter merkt der Chip wurde angeklickt und führt onSelected aus
                          onSelected: (val) => setState(() => _cheese = val), // val wird von Flutter berechnet und übergibt das Gegenteil (true/false), setState ruft sofort danach build() neu auf
                        ),
                        FilterChip(
                          label: const Text('Zwiebeln'),
                          selected: _onions,
                          onSelected: (val) => setState(() => _onions = val),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Sauce Dropdown
                    DropdownButtonFormField<String>(
                      value: _sauce,
                      decoration: const InputDecoration(
                        labelText: 'Sauce',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Ketchup', 'Mayo', 'BBQ'].map((sauce) {
                        return DropdownMenuItem(value: sauce, child: Text(sauce)); // map() startet eine Schleife und erstellt für jede Sauce ein DropdownMenuItem
                      }).toList(), // toList() wandelt das Ergebnis von map() in eine Liste um

                      // value = die Sauce die der User ausgewählt hat (Flutter erkennt/ermittelt den Klick und gibt den Wert des angeklickten Items zurück)
                      // Wenn nicht null, speichere den ausgewählten Wert in _sauce.
                      onChanged: (value) {
                        if (value != null) setState(() => _sauce = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    // Code Preview
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getCodePreview(),
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ),
                    // builder.build() Button
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        FilledButton.icon( // Button für die builder.build() Methode
                          onPressed: () {
                            final burger = _buildBurgerManually(); // baut den Burger manuell
                            _addBurger(burger);                       // fügt den erstellten Burger der Liste hinzu
                            _showSnackBar('Burger manuell erstellt!');
                          },
                          icon: const Icon(Icons.build),
                          label: const Text('builder.build()'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _cheese = false;
                              _onions = false;
                              _sauce = 'Ketchup';
                            });
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // === 3. Mit Director ===
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3. Mit Director (vordefinierte Rezepte)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Der Director steuert den Builder für dich:',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    // Code Preview
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'var director = BurgerDirector();\n'
                        'var burger = director.makeFullyLoaded(\n'
                        '    ClassicBurgerBuilder()\n'
                        ');',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.cyanAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final builder = _isVeggie
                                ? VeggieBurgerBuilder()
                                : ClassicBurgerBuilder();
                            final burger = _director.makeFullyLoaded(builder);
                            _addBurger(burger);
                            _showSnackBar('Director: Fully Loaded!');
                          },
                          child: const Text('Fully Loaded'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final builder = _isVeggie
                                ? VeggieBurgerBuilder()
                                : ClassicBurgerBuilder();
                            final burger = _director.makeMinimal(builder);
                            _addBurger(burger);
                            _showSnackBar('Director: Minimal!');
                          },
                          child: const Text('Minimal'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // === 4. Erstellte Burger ===
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Erstellte Burger (${_createdBurgers.length})', // Anzahl der erstellten Burger
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_createdBurgers.isEmpty)
                      Text(
                        'Noch keine Burger erstellt.',
                        style: TextStyle(color: Theme.of(context).colorScheme.outline),
                      )
                    /// List.generate geht automatisch durch alle Burger in der Liste und generiert für jeden erstellten Burger ein ListTile
                    // List.generate(3, (index) { ... })
                      //                 ↓
                      // Durchgang 1: index = 0 → _createdBurgers[0] → Baue ListTile für Burger an Position 0
                      // Durchgang 2: index = 1 → _createdBurgers[1] → Baue ListTile für Burger an Position 1
                      // Durchgang 3: index = 2 → _createdBurgers[2] → Baue ListTile für Burger an Position 2
                      // ... (spread operator) packt alle generierten ListTiles hier aus
                    else
                      ...List.generate(_createdBurgers.length, (index) { // .. sorgt dafür dass die Liste der ListTile-Widgets ([Widget, Widget, Widget],  // ← Flutter sagt eine Liste mit ListTiles ist kein Widget! -> Fehler) hier "ausgepackt" wird. Flutter's Regel ist einfach: children = nur Widgets, keine Listen. So wurde es designed.
                        // List.generate baut jedes einzelne ListTile komplett fertig → ... packt sie aus der Liste aus damit die ListTile Widgets nicht mehr in einer Liste verpackt sind → children zeigt sie an.
                        // die ListTiles wurden dann schon alle gebaut und müssen nur noch ausgepackt werden durch ... weil sie noch in einer Liste sind und Flutter nur Widgets in children akzeptiert
                        // nun sind sie in children als einzelne Widgets vorhanden und children zeigt sie an


                        final burger = _createdBurgers[index]; // Hole den Burger an der aktuellen Position → _createdBurgers[0]
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: Text('${index + 1}'), // Nummerierung der Burger
                          ),
                          title: Text(burger.getDescription()), // Zeige die Beschreibung des Burgers an
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              setState(() => _createdBurgers.removeAt(index)); // Zum Objekt wurde noch an der gegebenen Position ein LöschButton hinzugefügt
                            },
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}