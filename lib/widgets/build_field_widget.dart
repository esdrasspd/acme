import 'package:encuesta/models/field.dart';
import 'package:flutter/material.dart';

Widget buildFieldWidget(BuildContext context, Field field,
    Map<String, TextEditingController> controllersMap) {
  TextEditingController controller = controllersMap[field.name]!;
  Widget fieldWidget;

  switch (field.type) {
    case 'Texto':
      fieldWidget = buildTextField(field, controller);
      break;
    case 'Numero':
      fieldWidget = buildNumberField(field, controller);
      break;
    case 'Fecha':
      fieldWidget = buildDateField(context, field, controller);
      break;
    default:
      fieldWidget = Text('Tipo de campo no reconocido: ${field.type}');
      break;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Titulo: ${field.title}'),
      const SizedBox(height: 10),
      fieldWidget,
      SizedBox(height: 20),
    ],
  );
}

Widget buildTextField(Field field, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    decoration: const InputDecoration(
      labelText: 'Ingrese su respuesta',
    ),
  );
}

Widget buildNumberField(Field field, TextEditingController controller) {
  return TextFormField(
    keyboardType: TextInputType.number,
    controller: controller,
    decoration: const InputDecoration(
      labelText: 'Ingrese su respuesta.',
    ),
  );
}

Widget buildDateField(
    BuildContext context, Field field, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    decoration: const InputDecoration(
      labelText: 'Ingrese su respuesta.',
    ),
    onTap: () async {
      DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
      if (date != null) {
        controller.text = date.toString();
      }
    },
  );
}
