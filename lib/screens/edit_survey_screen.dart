import 'package:encuesta/models/survey.dart';
import 'package:encuesta/services/firebase_services.dart';
import 'package:encuesta/widgets/dialog_field_edit_survey.dart';
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
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
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
                                onTap: () {
                                  _showFieldEditDialog(field);
                                },
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
                  onPressed: () {
                    _saveChanges();
                  },
                  child: const Text('Actualizar'),
                ),
              ],
            ),
          ),
        ));
  }

  void _showFieldEditDialog(Field originalField) async {
    Field? editedField = (await showDialog<Field>(
        context: context,
        builder: (BuildContext context) {
          return DialogFieldEditSurvey(field: originalField);
        }))!;
    if (editedField != null) {
      setState(() {
        widget.survey.fields.remove(originalField);
        widget.survey.fields.add(editedField);
        print(widget.survey.fields.toString());
      });
    }
  }

  Future<void> _saveChanges() async {
    String name = _nameController.text.trim();
    String description = _descriptionController.text.trim();
    Survey survey = Survey(
      id: widget.survey.id,
      name: name,
      description: description,
      fields: widget.survey.fields,
    );

    await FirebaseServices().updateSurvey(survey);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Encuesta actualizada con éxito.'),
      ),
    );

    Navigator.pushNamed(context, '/home');
  }
}
