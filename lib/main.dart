import 'package:flutter/material.dart';
import 'builder_pattern/builder_pattern_export.dart';
import 'theme/dracula_colors.dart';

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
  final List<Burger> _createdBurgers = [];
  final BurgerDirector _director = BurgerDirector();
  bool _isVeggie = false;  // Classic oder Veggie Builder
  String _lastRecipe = 'makeFullyLoaded';  // Für dynamische Code-Preview

  // UI needs to be updated, therefore setState
  void _addBurger(Burger burger) {
    setState(() {
      _createdBurgers.add(burger);
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
                          onSelected: (_) => setState(() => _isVeggie = false),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Veggie Burger'),
                          selected: _isVeggie,
                          onSelected: (_) => setState(() => _isVeggie = true),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // === 2. Mit Director (vordefinierte Rezepte) ===
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2. Director - Vordefinierte Rezepte',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Der Director steuert den Builder für dich:',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    // Code Preview - ändert sich dynamisch je nach geklicktem Button
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: DraculaColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: DraculaStyles.normal,
                          children: [
                            // Zeile 1: var director = BurgerDirector();
                            TextSpan(text: 'var', style: DraculaStyles.keyword),
                            const TextSpan(text: ' director = '),
                            TextSpan(text: 'BurgerDirector', style: DraculaStyles.className),
                            const TextSpan(text: '();\n'),
                            // Zeile 2: var burger = director.makeXXX(
                            TextSpan(text: 'var', style: DraculaStyles.keyword),
                            const TextSpan(text: ' burger = director.'),
                            TextSpan(text: _lastRecipe, style: DraculaStyles.method),
                            const TextSpan(text: '(\n'),
                            // Zeile 3: Builder
                            const TextSpan(text: '    '),
                            TextSpan(
                              text: _isVeggie ? 'VeggieBurgerBuilder' : 'ClassicBurgerBuilder',
                              style: DraculaStyles.className,
                            ),
                            const TextSpan(text: '()\n'),
                            // Zeile 4: );
                            const TextSpan(text: ');'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _lastRecipe = 'makeFullyLoaded');
                            final builder = _isVeggie ? VeggieBurgerBuilder() : ClassicBurgerBuilder();
                            final burger = _director.makeFullyLoaded(builder);
                            _addBurger(burger);
                            _showSnackBar('Director: Fully Loaded!');
                          },
                          child: const Text('Fully Loaded'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _lastRecipe = 'makeCheeseLover');
                            final builder = _isVeggie ? VeggieBurgerBuilder() : ClassicBurgerBuilder();
                            final burger = _director.makeCheeseLover(builder);
                            _addBurger(burger);
                            _showSnackBar('Director: Cheese Lover!');
                          },
                          child: const Text('Cheese Lover'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // === 3. Erstellte Burger ===
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Erstellte Burger (${_createdBurgers.length})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (_createdBurgers.isEmpty)
                      Text(
                        'Noch keine Burger erstellt.',
                        style: TextStyle(color: Theme.of(context).colorScheme.outline),
                      )
                    else
                      // 1. List.generate erstellt eine Liste von Widgets aus _createdBurgers
                      // 2. Der ... Spread-Operator entpackt diese Liste
                      // 3. Die einzelnen ListTile-Widgets werden in children eingefügt
                      ...List.generate(_createdBurgers.length, (index) {
                        final burger = _createdBurgers[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: Text('${index + 1}'),
                          ),
                          title: Text(burger.getDescription()),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              setState(() => _createdBurgers.removeAt(index));
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