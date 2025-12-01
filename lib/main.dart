import 'package:flutter/material.dart';
import 'builder_pattern/builder_pattern_export.dart';

void main() {
  runApp(const BuilderPatternDemoApp());
}

// Stateless because no reloading of the page is needed, no changes of UI or button text
// Button-Text ändert sich von "Bestellen" → "Bestellt ✓"
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
  final List<BurgerBuilder> _builders = [
    ClassicBurgerBuilder(),
    VeggieBurgerBuilder(),
  ];

  final BurgerDirector _director = BurgerDirector();

  int _selectedBuilderIndex = 0;

  BurgerBuilder get _currentBuilder => _builders[_selectedBuilderIndex];

  bool _cheese = false;
  bool _onions = false;
  String _sauce = 'Ketchup';

  final List<Burger> _createdBurgers = [];

  final List<String> _sauces = ['Ketchup', 'Mayo', 'BBQ'];

  void _resetToppings() {
    setState(() {
      _cheese = false;
      _onions = false;
      _sauce = 'Ketchup';
    });
  }

  Burger _buildBurgerManually() {
    final builder = _selectedBuilderIndex == 0
        ? ClassicBurgerBuilder()
        : VeggieBurgerBuilder();

    builder.reset();
    if (_cheese) builder.setCheese();
    if (_onions) builder.setOnions();
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
            _buildBuilderSelector(),
            const SizedBox(height: 24),
            _buildManualBuilderSection(),
            const SizedBox(height: 24),
            _buildDirectorSection(),
            const SizedBox(height: 24),
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
                  label: const Text('Zwiebeln'),
                  selected: _onions,
                  onSelected: (value) => setState(() => _onions = value),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
    if (_onions) methods.add('.setOnions()');
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
                _buildDirectorButton('Fully Loaded', 'fullyLoaded', Icons.stars),
                _buildDirectorButton('Minimal', 'minimal', Icons.minimize),
                _buildDirectorButton('Classic Combo', 'classic', Icons.thumb_up),
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
