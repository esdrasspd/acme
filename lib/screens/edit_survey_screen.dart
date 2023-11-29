import 'package:encuesta/models/survey.dart';
import 'package:flutter/material.dart';

class EditSurveyScreen extends StatefulWidget {
  final Survey survey;
  const EditSurveyScreen({Key? key, required this.survey}) : super(key: key);

  @override
  _EditSurveyScreenState createState() => _EditSurveyScreenState();
}

class _EditSurveyScreenState extends State<EditSurveyScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.survey.name);
    _descriptionController =
        TextEditingController(text: widget.survey.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Editar encuesta'),
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
                const SizedBox(
                  height: 20,
                ),
                widget.survey.fields.isNotEmpty
                    ? Column(
                        children: widget.survey.fields.map((field) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text('Titulo: ${field.title}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nombre: ${field.name}'),
                                    Text('Tipo: ${field.type}'),
                                    Text('¿Es requerido?: ${field.isRequired}'),
                                  ],
                                ),
                                onTap: () {},
                              ),
                              const Divider(),
                            ],
                          );
                        }).toList(),
                      )
                    : const Text('No hay campos en esta encuesta'),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        ));
  }

  void _showFieldEditDialog(Field field) {
    TextEditingController _titleController =
        TextEditingController(text: field.title);
    TextEditingController _nameController =
        TextEditingController(text: field.name);
    TextEditingController _typeController =
        TextEditingController(text: field.type);
    TextEditingController _isRequiredController =
        TextEditingController(text: field.isRequired.toString());
    showDialog(
      context: context,
      builder: (context) {
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
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(
                  labelText: 'Tipo del campo',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _isRequiredController,
                decoration: const InputDecoration(
                  labelText: '¿Es requerido?',
                ),
              ),
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
                Navigator.pop(
                    context,
                    Field(
                      title: _titleController.text,
                      name: _nameController.text,
                      type: _typeController.text,
                      isRequired:
                          _isRequiredController.text == 'true' ? true : false,
                    ));
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
