import 'package:encuesta/models/answer.dart';
import 'package:encuesta/models/response.dart';
import 'package:encuesta/models/survey.dart';
import 'package:encuesta/services/firebase_services.dart';
import 'package:encuesta/widgets/build_field_widget.dart';
import 'package:flutter/material.dart';

class FillSurveyScreen extends StatefulWidget {
  final Survey survey;
  const FillSurveyScreen({Key? key, required this.survey}) : super(key: key);
  @override
  _FillSurveyScreenState createState() => _FillSurveyScreenState();
}

class _FillSurveyScreenState extends State<FillSurveyScreen> {
  Map<String, TextEditingController> _controllersMap = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.survey.fields.forEach((field) {
      _controllersMap[field.name] = TextEditingController();
    });
  }

  @override
  void dispose() {
    _controllersMap.forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Llenar encuesta'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                  ...widget.survey.fields.map((field) =>
                      buildFieldWidget(context, field, _controllersMap)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _createResponse();
                    },
                    child: const Text('Guardar su respuesta'),
                  ),
                ]),
          ),
        ));
  }

  Future<void> _createResponse() async {
    String surveyCode = widget.survey.code!;

    List<Answer> _answers = [];

    bool allFieldsFilled = true;

    widget.survey.fields.forEach((field) {
      String fieldName = field.name;
      TextEditingController controller = _controllersMap[fieldName]!;

      String textAnswer = controller.text;

      if (field.isRequired && textAnswer.isEmpty) {
        allFieldsFilled = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Por favor complete los campos requeridos!'),
          ),
        );
        return;
      }

      Answer answer = Answer(fieldName: fieldName, value: textAnswer);
      _answers.add(answer);
    });

    if (allFieldsFilled) {
      Response response = Response(surveyCode: surveyCode, answers: _answers);

      await FirebaseServices().saveResponses(response);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Respuesta guardada!'),
        ),
      );
    }
  }
}
