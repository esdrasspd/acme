import 'package:encuesta/models/field.dart';
import 'package:flutter/material.dart';

class AddQuestionDialog extends StatefulWidget {
  const AddQuestionDialog({super.key});

  @override
  State<AddQuestionDialog> createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<AddQuestionDialog> {
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();

  // States
  bool _isRequired = false;
  String? type;

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: const Text('Agregar campo'),
        content: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titulo del campo',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del campo',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text('Tipo de campo'),
                const SizedBox(
                  width: 10,
                ),
                DropdownButton<String>(
                  value: type,
                  items: ['Texto', 'Numero', 'Fecha']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      type = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text('¿Es requerido?'),
                const SizedBox(
                  width: 10,
                ),
                Checkbox(
                  value: _isRequired,
                  onChanged: (bool? value) {
                    setState(() {
                      _isRequired = value ?? false;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Field? newFields = Field(
                name: _nameController.text.trim(),
                title: _titleController.text.trim(),
                isRequired: _isRequired,
                type: type!,
              );
              Navigator.of(context).pop(newFields);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
