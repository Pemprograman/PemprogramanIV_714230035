import 'package:flutter/material.dart';
import 'bottom_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: const DynamicBottomNavbar(),
    );
  }
}

class MyInput extends StatefulWidget {
  const MyInput({super.key});

  @override
  State<MyInput> createState() => _MyInputState();
}

class _MyInputState extends State<MyInput> {
  TextEditingController _controller = TextEditingController();
  bool lightOn = false;
  String? language;
  bool agree = false;

  void showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Widget')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Write your name here...',
                labelText: 'Your Name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          content: Text('Hello, ${_controller.text}'),
                        ));
              },
            ),
            const SizedBox(height: 20),

            // SWITCH
            Switch(
              value: lightOn,
              onChanged: (v) {
                setState(() {
                  lightOn = v;
                });
                showSnackbar(lightOn ? 'Light On' : 'Light Off');
              },
            ),

            // RADIO
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(
                  title: const Text('Dart'),
                  value: 'Dart',
                  groupValue: language,
                  onChanged: (val) {
                    setState(() => language = val);
                    showSnackbar("Selected: $val");
                  },
                ),
                RadioListTile(
                  title: const Text('Kotlin'),
                  value: 'Kotlin',
                  groupValue: language,
                  onChanged: (val) {
                    setState(() => language = val);
                    showSnackbar("Selected: $val");
                  },
                ),
                RadioListTile(
                  title: const Text('Swift'),
                  value: 'Swift',
                  groupValue: language,
                  onChanged: (val) {
                    setState(() => language = val);
                    showSnackbar("Selected: $val");
                  },
                ),
              ],
            ),

            // CHECKBOX
            CheckboxListTile(
              title: const Text('Agree / Disagree'),
              value: agree,
              onChanged: (val) {
                setState(() => agree = val!);
                showSnackbar(agree ? "Agree" : "Disagree");
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
