import 'package:flutter/material.dart';

class MyFormValidation extends StatefulWidget {
  const MyFormValidation({super.key});

  @override
  State<MyFormValidation> createState() => _MyFormValidationState();
}

class _MyFormValidationState extends State<MyFormValidation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerNama = TextEditingController();

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerNama.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    const pattern =
        "[a-zA-Z0-9+._%-+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+";
    final reg = RegExp(pattern);

    if (value!.isEmpty) return 'Email wajib diisi';
    if (!reg.hasMatch(value)) return 'Email tidak valid!';
    return null;
  }

  String? _validateNama(String? value) {
    if (value!.length < 3) return 'Minimal 3 karakter';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Validation')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    filled: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: _controllerNama,
                  validator: _validateNama,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    filled: true,
                  ),
                ),
              ),
              ElevatedButton(
                child: const Text("Submit"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Text(
                        'Email: ${_controllerEmail.text}\n'
                        'Name: ${_controllerNama.text}',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
