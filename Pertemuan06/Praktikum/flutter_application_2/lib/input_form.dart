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

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerNama.dispose();
    super.dispose();
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
      _controllerNama.text = data['name'];
      _controllerEmail.text = data['email'];
      editedData = data;
    });
  }

  void _deleteData(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Data'),
        content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _myDataList.remove(data);
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    const pattern =
        "[a-zA-Z0-9+._%-+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+";
    final regExp = RegExp(pattern);

    if (value!.isEmpty) return 'Email wajib diisi';
    if (!regExp.hasMatch(value)) return 'Tolong inputkan email valid!';
    return null;
  }

  String? _validateNama(String? value) {
    if (value!.length < 3) return 'Minimal 3 karakter';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Input')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controllerEmail,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  filled: true,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerNama,
                validator: _validateNama,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  filled: true,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: Text(editedData != null ? "Update" : "Submit"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) _addData();
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'List Data',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _myDataList.length,
                  itemBuilder: (context, index) {
                    final data = _myDataList[index];
                    return ListTile(
                      leading: const CircleAvatar(child: Text('ULBI')),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
