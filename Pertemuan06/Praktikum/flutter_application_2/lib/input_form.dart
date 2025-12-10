import 'package:flutter/material.dart';

class MyInputForm extends StatefulWidget {
  const MyInputForm({super.key});

  @override
  State<MyInputForm> createState() => _MyInputFormState();
}

class _MyInputFormState extends State<MyInputForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerNama = TextEditingController();

  final List<Map<String, dynamic>> _myDataList = [];
  Map<String, dynamic>? editedData;

  // VALIDASI EMAIL
  String? _validateEmail(String? value) {
    const String pattern =
        "[a-zA-Z0-9+._%-+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+";
    final RegExp regex = RegExp(pattern);

    if (value!.isEmpty) return "Email wajib diisi";
    if (!regex.hasMatch(value)) return "Email tidak valid";
    return null;
  }

  // VALIDASI NAMA
  String? _validateNama(String? value) {
    if (value!.length < 3) return "Minimal 3 karakter";
    return null;
  }

  void _addData() {
    final data = {
      'name': _controllerNama.text,
      'email': _controllerEmail.text,
    };

    setState(() {
      if (editedData != null) {
        editedData!['name'] = data['name'];
        editedData!['email'] = data['email'];
        editedData = null;
      } else {
        _myDataList.add(data);
      }

      _controllerNama.clear();
      _controllerEmail.clear();
    });
  }

  void _editData(Map<String, dynamic> data) {
    setState(() {
      _controllerEmail.text = data['email'];
      _controllerNama.text = data['name'];
      editedData = data;
    });
  }

  void _deleteData(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Data"),
        content: const Text("Apakah anda yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              setState(() => _myDataList.remove(data));
              Navigator.of(context).pop();
            },
            child: const Text("Hapus"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Input')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // EMAIL
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          controller: _controllerEmail,
                          validator: _validateEmail,
                          decoration: const InputDecoration(
                            hintText: 'Write your email here...',
                            labelText: 'Email',
                            border: OutlineInputBorder(),
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
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),

                      ElevatedButton(
                        child: Text(editedData != null ? "Update" : "Submit"),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _addData();
                          }
                        },
                      ),

                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          "List Data",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // LISTVIEW
            Expanded(
              child: ListView.builder(
                itemCount: _myDataList.length,
                itemBuilder: (_, index) {
                  final data = _myDataList[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Text("ULBI"),
                    ),
                    title: Text(data['name']),
                    subtitle: Text(data['email']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editData(data),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteData(data),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
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
