class Survey {
  final String? id;
  final String name;
  final String description;
  final List<Field> fields;

  Survey({
    this.id,
    required this.name,
    required this.description,
    required this.fields,
  });
}

class Field {
  final String name;
  final String title;
  final bool isRequired;
  final String type;

  Field({
    required this.name,
    required this.title,
    required this.isRequired,
    required this.type,
  });
}
