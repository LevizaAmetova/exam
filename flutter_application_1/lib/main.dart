import 'package:flutter/material.dart';

void main() {
  runApp(const CircleAreaApp());
}

class CircleAreaApp extends StatelessWidget {
  const CircleAreaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Площадь круга',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CircleAreaScreen(),
    );
  }
}

class CircleAreaScreen extends StatefulWidget {
  const CircleAreaScreen({super.key});

  @override
  CircleAreaScreenState createState() => CircleAreaScreenState();
}

class CircleAreaScreenState extends State<CircleAreaScreen> {
  final TextEditingController _radiusController = TextEditingController();
  final List<Map<String, dynamic>> _calculations = [];
  final _formKey = GlobalKey<FormState>();

  void _calculateArea() {
    if (_formKey.currentState!.validate()) {
      final radius = double.tryParse(_radiusController.text) ?? 0.0;
      final area = _calculateCircleArea(radius);

      setState(() {
        _calculations.insert(0, {
          'radius': radius,
          'area': area,
        });
      });

      _radiusController.clear();
    }
  }

  double _calculateCircleArea(double radius) {
    return double.parse((3.14159265359 * radius * radius).toStringAsFixed(2));
  }

  void _clearList() {
    setState(() {
      _calculations.clear();
    });
  }

  String? _validateRadius(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите радиус';
    }
    final num = double.tryParse(value);
    if (num == null) {
      return 'Введите корректное число';
    }
    if (num <= 0) {
      return 'Радиус должен быть больше 0';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Площадь круга'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _radiusController,
                decoration: const InputDecoration(
                  labelText: 'Радиус круга',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.radio_button_checked),
                  hintText: 'Введите радиус (например: 5 или 3.2)',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: _validateRadius,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _calculateArea,
                    icon: const Icon(Icons.calculate),
                    label: const Text('CALCULATE'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _clearList,
                    icon: const Icon(Icons.clear_all),
                    label: const Text('CLEAR'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'История расчетов:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _calculations.isEmpty
                  ? Center(
                      child: Text(
                        'Нет расчетов',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    )
                  : ListView.builder(
                      reverse: true, // Чтобы новые записи были сверху
                      itemCount: _calculations.length,
                      itemBuilder: (context, index) {
                        final calc = _calculations[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: const Icon(Icons.circle, color: Colors.blue),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'R = ${calc['radius']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'S = ${calc['area']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              'Площадь круга с радиусом ${calc['radius']}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Text(
                              '#${_calculations.length - index}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _radiusController.dispose();
    super.dispose();
  }
}