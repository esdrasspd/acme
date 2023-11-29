import 'package:encuesta/models/survey.dart';
import 'package:encuesta/screens/edit_survey_screen.dart';
import 'package:flutter/material.dart';

class DetailSurveyScreen extends StatelessWidget {
  final Survey survey;
  const DetailSurveyScreen({Key? key, required this.survey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de la encuesta'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  '${survey.name}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                subtitle: Text(
                  survey.description,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
              survey.fields.isNotEmpty
                  ? Column(
                      children: survey.fields.map((field) {
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
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        );
                      }).toList(),
                    )
                  : const Text('La encuesta no contiene campos'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditSurveyScreen(survey: survey)));
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
