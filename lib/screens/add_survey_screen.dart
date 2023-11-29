import 'package:encuesta/models/survey.dart';
import 'package:encuesta/services/firebase_services.dart';
import 'package:flutter/material.dart';

class AddSurveyScreen extends StatefulWidget {
  const AddSurveyScreen({Key? key}) : super(key: key);

  @override
  _AddSurveyScreenState createState() => _AddSurveyScreenState();
}

class _AddSurveyScreenState extends State<AddSurveyScreen> {
  bool _isRequired = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<Field> _fields = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Agregar encuesta'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la encuesta',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción de la encuesta',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Campos de la encuesta: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                _fields.isNotEmpty
                    ? Column(
                        children: _fields.map((field) {
                          return ListTile(
                            title: Text('Titulo: ${field.title}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nombre: ${field.name}'),
                                Text('Tipo: ${field.type}'),
                                Text('¿Es requerido?: ${field.isRequired}'),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    : const Text(
                        'Aún no hay campos en esta encuesta',
                        style: TextStyle(fontSize: 16),
                      ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      _openAddFieldDialog(context);
                      print(_fields.map((e) => e.title));
                    },
                    child: const Text('Agregar campo')),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: _createSurvey,
                    child: const Text('Crear encuesta'))
              ],
            ),
          ),
        ));
  }

  void _openAddFieldDialog(BuildContext context) async {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _titleController = TextEditingController();
    String type;
    Field? newField = await showDialog<Field>(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: const Text('Agregar campo'),
              content: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del campo',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título del campo',
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
                  Row(
                    children: [
                      const Text('Tipo de campo'),
                      const SizedBox(
                        width: 10,
                      ),
                      DropdownButton<String>(
                        value: 'Texto',
                        items: ['Texto', 'Numero', 'Fecha']
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        onChanged: (String? value) {},
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
                        type: type = 'Texto');
                    Navigator.of(context).pop(newFields);
                  },
                  child: const Text('Agregar'),
                ),
              ],
            ),
          );
        });
    if (newField != null) {
      setState(() {
        _fields.add(newField);
      });
    }
  }

  Future<void> _createSurvey() async {
    String name = _nameController.text.trim();
    String description = _descriptionController.text.trim();

    if (name.isNotEmpty && description.isNotEmpty && _fields.isNotEmpty) {
      Survey survey = Survey(
        name: name,
        description: description,
        fields: _fields,
      );

      await FirebaseServices().createSurvey(survey);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Encuesta creada exitosamente'),
        ),
      );

      Navigator.pop(
          context); // Puedes redirigir a la pantalla de inicio o hacer otras acciones después de crear la encuesta
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Por favor, complete todos los campos y agregue al menos un campo'),
        ),
      );
    }
  }
}
