import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';


class AdvancedForm extends StatefulWidget {
  const AdvancedForm({super.key});

  @override
  State<AdvancedForm> createState() => _AdvancedFormState();
}

class _AdvancedFormState extends State<AdvancedForm> {
  // Date Picker variables
  DateTime? _dueDate;
  final currentDate = DateTime.now();

  // Color Picker variable
  Color _currentColor = Colors.blue;

  PlatformFile? _pickedFile;
  File? _showImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Widget'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildDatePicker(),
            const SizedBox(height: 20),
            buildColorPicker(),
          ],
        ),
      ),
    );
  }

  // ------------------ DATE PICKER ------------------
  Widget buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Date Picker",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _dueDate == null
                  ? DateFormat('dd-MM-yyyy').format(currentDate)
                  : DateFormat('dd-MM-yyyy').format(_dueDate!),
            ),

            ElevatedButton(
              onPressed: () async {
                final selectDate = await showDatePicker(
                  context: context,
                  initialDate: currentDate,
                  firstDate: DateTime(currentDate.year - 5),
                  lastDate: DateTime(currentDate.year + 5),
                );

                if (selectDate != null) {
                  setState(() {
                    _dueDate = selectDate;
                  });
                }
              },
              child: const Text("Select"),
            )
          ],
        ),
      ],
    );
  }

  // ------------------ COLOR PICKER ------------------
  Widget buildColorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Color Picker",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _currentColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black26),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Pick a color"),
                      content: SingleChildScrollView(
                        child: BlockPicker(
                          pickerColor: _currentColor,
                          onColorChanged: (color) {
                            setState(() {
                              _currentColor = color;
                            });
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Close"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("Pick Color"),
            )
          ],
        ),
      ],
    );
  }

  // ------------------ FILE PICKER ------------------



Widget buildFilePicker() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "File Picker",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              _pickedFile != null ? _pickedFile!.name : "No file selected",
            ),
          ),

          ElevatedButton(
            onPressed: () {
              _pickFile();
            },
            child: const Text("Pick File"),
          ),
        ],
      ),

      // tampilkan gambar jika ada
      if (_showImage != null) ...[
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: Image.file(_showImage!),
        ),
      ],
    ],
  );
}

Future<void> _pickFile() async {
  final result = await FilePicker.platform.pickFiles();

  if (result == null) return;

  _pickedFile = result.files.first;

  // buka file
  if (_pickedFile!.path != null) {
    _openFile(_pickedFile!.path!);
  }

  // cek jika file gambar
  if (_pickedFile!.extension == "png" ||
      _pickedFile!.extension == "jpg" ||
      _pickedFile!.extension == "jpeg") {
    _showImage = File(_pickedFile!.path!);
  }

  setState(() {});
}

void _openFile(String path) {
  OpenFile.open(path);
}

}
