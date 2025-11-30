import 'package:flutter/material.dart';
import 'builder_pattern/builder_pattern.dart';

void main() {
  runApp(const BuilderPatternDemoApp());
}

class BuilderPatternDemoApp extends StatelessWidget {
  const BuilderPatternDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Builder Pattern Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const BurgerBuilderPage(),
    );
  }
}

class BurgerBuilderPage extends StatefulWidget {
  const BurgerBuilderPage({super.key});

  @override
  State<BurgerBuilderPage> createState() => _BurgerBuilderPageState();
}

class _BurgerBuilderPageState extends State<BurgerBuilderPage> {
  // Die verschiedenen Builder
  final List<BurgerBuilder> _builders = [
    ClassicBurgerBuilder(),
    VeggieBurgerBuilder(),
  ];

  // Der Director
  final BurgerDirector _director = BurgerDirector();

  // Aktuell ausgewählter Builder Index
  int _selectedBuilderIndex = 0;

  // Aktueller Builder
  BurgerBuilder get _currentBuilder => _builders[_selectedBuilderIndex];

  // Toppings State
  bool _cheese = false;
  bool _pickles = false;
  bool _tomato = false;
  bool _lettuce = false;
  String _sauce = 'Ketchup';

  // Liste der erstellten Burger
  final List<Burger> _createdBurgers = [];

  // Verfügbare Saucen
  final List<String> _sauces = [
    'Ketchup',
    'Mayo',
    'Senf',
    'BBQ',
    'Special Sauce',
    'Hummus',
  ];

  void _resetToppings() {
    setState(() {
      _cheese = false;
      _pickles = false;
      _tomato = false;
      _lettuce = false;
      _sauce = 'Ketchup';
    });
  }

  Burger _buildBurgerManually() {
    // Manueller Aufbau ohne Director
    final builder = _selectedBuilderIndex == 0
        ? ClassicBurgerBuilder()
        : VeggieBurgerBuilder();

    builder.reset();
    if (_cheese) builder.setCheese();
    if (_pickles) builder.setPickles();
    if (_tomato) builder.setTomato();
    if (_lettuce) builder.setLettuce();
    builder.setSauce(_sauce);

    return builder.build();
  }

  void _addBurger(Burger burger) {
    setState(() {
      _createdBurgers.add(burger);
    });
  }

  void _useDirectorRecipe(String recipeName) {
    final builder = _selectedBuilderIndex == 0
        ? ClassicBurgerBuilder()
        : VeggieBurgerBuilder();

    Burger burger;
    switch (recipeName) {
      case 'fullyLoaded':
        burger = _director.makeFullyLoaded(builder);
        break;
      case 'minimal':
        burger = _director.makeMinimal(builder);
        break;
      case 'classic':
        burger = _director.makeClassicCombo(builder);
        break;
      case 'fresh':
        burger = _director.makeFreshBurger(builder);
        break;
      default:
        return;
    }

    _addBurger(burger);
    _showSnackBar('Director hat "$recipeName" Burger erstellt!');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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
            // Builder Auswahl
            _buildBuilderSelector(),
            const SizedBox(height: 24),

            // Manueller Builder Bereich
            _buildManualBuilderSection(),
            const SizedBox(height: 24),

            // Director Bereich
            _buildDirectorSection(),
            const SizedBox(height: 24),

            // Erstellte Burger
            _buildCreatedBurgersSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBuilderSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Wähle einen Concrete Builder',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SegmentedButton<int>(
              segments: _builders.asMap().entries.map((entry) {
                final builder = entry.value;
                return ButtonSegment(
                  value: entry.key,
                  label: Text(builder.builderName),
                  icon: Icon(
                    entry.key == 0 ? Icons.restaurant : Icons.eco,
                  ),
                );
              }).toList(),
              selected: {_selectedBuilderIndex},
              onSelectionChanged: (selection) {
                setState(() {
                  _selectedBuilderIndex = selection.first;
                  _resetToppings();
                });
              },
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Basis-Zutaten (vom Builder vordefiniert):',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  Text('Brötchen: ${_currentBuilder.bunType}'),
                  Text('Patty: ${_currentBuilder.pattyType}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualBuilderSection() {
    return Card(
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
              'Hier rufst du die Builder-Methoden selbst auf:',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),

            // Toppings
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('Käse'),
                  selected: _cheese,
                  onSelected: (value) => setState(() => _cheese = value),
                ),
                FilterChip(
                  label: const Text('Gurken'),
                  selected: _pickles,
                  onSelected: (value) => setState(() => _pickles = value),
                ),
                FilterChip(
                  label: const Text('Tomaten'),
                  selected: _tomato,
                  onSelected: (value) => setState(() => _tomato = value),
                ),
                FilterChip(
                  label: const Text('Salat'),
                  selected: _lettuce,
                  onSelected: (value) => setState(() => _lettuce = value),
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
              items: _sauces.map((sauce) {
                return DropdownMenuItem(value: sauce, child: Text(sauce));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _sauce = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Code Vorschau
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _buildCodePreview(),
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      final burger = _buildBurgerManually();
                      _addBurger(burger);
                      _showSnackBar('Burger manuell erstellt!');
                    },
                    icon: const Icon(Icons.build),
                    label: const Text('builder.build()'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _resetToppings,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _buildCodePreview() {
    final builderName = _selectedBuilderIndex == 0
        ? 'ClassicBurgerBuilder'
        : 'VeggieBurgerBuilder';

    final methods = <String>[];
    if (_cheese) methods.add('.setCheese()');
    if (_pickles) methods.add('.setPickles()');
    if (_tomato) methods.add('.setTomato()');
    if (_lettuce) methods.add('.setLettuce()');
    methods.add('.setSauce("$_sauce")');

    return 'var builder = $builderName();\n'
        'var burger = builder\n'
        '    ${methods.join('\n    ')}\n'
        '    .build();';
  }

  Widget _buildDirectorSection() {
    return Card(
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
              'Der Director kennt die Rezepte und steuert den Builder:',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildDirectorButton(
                  'Fully Loaded',
                  'fullyLoaded',
                  Icons.stars,
                ),
                _buildDirectorButton(
                  'Minimal',
                  'minimal',
                  Icons.minimize,
                ),
                _buildDirectorButton(
                  'Classic Combo',
                  'classic',
                  Icons.thumb_up,
                ),
                _buildDirectorButton(
                  'Fresh',
                  'fresh',
                  Icons.spa,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
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
          ],
        ),
      ),
    );
  }

  Widget _buildDirectorButton(String label, String recipe, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () => _useDirectorRecipe(recipe),
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }

  Widget _buildCreatedBurgersSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Erstellte Burger (${_createdBurgers.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (_createdBurgers.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      setState(() => _createdBurgers.clear());
                    },
                    child: const Text('Alle löschen'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (_createdBurgers.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                child: Text(
                  'Noch keine Burger erstellt.\n'
                  'Nutze den Builder oder Director!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _createdBurgers.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final burger = _createdBurgers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      '${burger.bun}-${burger.patty} Burger',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(burger.getDescription()),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        setState(() {
                          _createdBurgers.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}