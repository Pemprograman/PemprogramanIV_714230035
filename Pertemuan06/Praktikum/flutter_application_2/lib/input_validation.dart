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

  // VALIDASI EMAIL
  String? _validateEmail(String? value) {
    const String pattern =
        "[a-zA-Z0-9+._%-+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+";
    final RegExp regex = RegExp(pattern);

    if (value!.isEmpty) return "Email wajib diisi";
    if (!regex.hasMatch(value)) return "Tolong inputkan email yang valid!";
    return null;
  }

  // VALIDASI NAMA
  String? _validateNama(String? value) {
    if (value!.length < 3) return "Masukkan setidaknya 3 karakter";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Validation')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // EMAIL
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                    decoration: const InputDecoration(
                      hintText: 'Write your email here...',
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      fillColor: Color.fromARGB(255, 222, 254, 255),
                      filled: true,
                    ),
                  ),
                ),

                // NAMA
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: _controllerNama,
                    validator: _validateNama,
                    decoration: const InputDecoration(
                      hintText: 'Write your name here...',
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      fillColor: Color.fromARGB(255, 222, 254, 255),
                      filled: true,
                    ),
                  ),
                ),

                ElevatedButton(
                  child: const Text("Submit"),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Hasil Input"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Email : ${_controllerEmail.text}"),
                              Text("Nama : ${_controllerNama.text}"),
                            ],
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please complete the form")),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerNama.dispose();
    super.dispose();
  }
}
