import 'package:encuesta/models/answer.dart';

class Response {
  final String surveyCode;
  final List<Answer> answers;

  Response({
    required this.surveyCode,
    required this.answers,
  });
}
