import 'package:encuesta/models/field.dart';
import 'package:flutter/material.dart';

class DialogFieldEditSurvey extends StatefulWidget {
  final Field field;
  const DialogFieldEditSurvey({Key? key, required this.field})
      : super(key: key);
  @override
  State<DialogFieldEditSurvey> createState() =>
      _DialogFieldEditSurveyState(field: field);
}

class _DialogFieldEditSurveyState extends State<DialogFieldEditSurvey> {
  final Field field;
  _DialogFieldEditSurveyState({required this.field});

  late final TextEditingController _titleController;
  late final TextEditingController _nameController;
  late final TextEditingController _typeController;
  late bool _isRequired = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: field.title);
    _nameController = TextEditingController(text: field.name);
    _typeController = TextEditingController(text: field.type);
    _isRequired = field.isRequired;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _nameController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar campo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Título del campo',
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
          const SizedBox(
            height: 20,
          ),
          Row(children: [
            const Text('Tipo de campo'),
            const SizedBox(
              width: 10,
            ),
            DropdownButton<String>(
              value: _typeController.text,
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
                  _typeController.text = value!;
                });
              },
            )
          ])
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Field? newFields = Field(
              title: _titleController.text,
              name: _nameController.text,
              type: _typeController.text,
              isRequired: _isRequired,
            );
            Navigator.of(context).pop(newFields);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
