import 'package:encuesta/models/survey.dart';
import 'package:encuesta/services/firebase_services.dart';
import 'package:flutter/material.dart';

class DialogDeletSurvey extends StatefulWidget {
  final Survey survey;
  const DialogDeletSurvey({Key? key, required this.survey}) : super(key: key);

  @override
  State<DialogDeletSurvey> createState() => _DialogDeletSurveyState();
}

class _DialogDeletSurveyState extends State<DialogDeletSurvey> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmación'),
      content: const Text('¿Estás seguro de eliminar esta encuesta?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            FirebaseServices().deleteSurvey(widget.survey);
            setState(() {
              Navigator.pushReplacementNamed(context, '/home');
            });
          },
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}
