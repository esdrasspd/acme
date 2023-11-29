import 'package:encuesta/models/field.dart';

class Survey {
  final String? id;
  final String name;
  final String description;
  final List<Field> fields;
  final String? link;
  final String? code;

  Survey({
    this.id,
    required this.name,
    required this.description,
    required this.fields,
    this.link,
    this.code,
  });
}
