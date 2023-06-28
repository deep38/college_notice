import 'package:college_notice/utils/validators.dart';
import 'package:college_notice/widgets/text_form_field.dart';
import 'package:flutter/material.dart';

class AddDialog {
  final GlobalKey<FormState> formKey = GlobalKey();

  final BuildContext context;
  final String title;
  final String addButtonText;
  final List<String> fields;
  final Map<String, TextEditingController> controllers = {};
  Map<String, String? Function(String?)>? validators;
  final void Function(Map<String, dynamic>) onSubmit;

  AddDialog({
    required this.context,
    this.title = "Add",
    this.addButtonText = "Add",
    required this.fields,
    required this.onSubmit,
    this.validators,
  }) {
    validators ??= {};
    for (var i = 0; i < fields.length; i++) {
      controllers.putIfAbsent(fields[i], () => TextEditingController());
      validators?.putIfAbsent(fields[i], () => Validator.requiredField);
    }
  }

  void show() {
    int fieldNo = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...fields.map(
                    (field) {
                      fieldNo++;
                      return AppTextFormField(
                        label: field,
                        controller: controllers[field],
                        validator: validators?[field],
                        autofocus: fieldNo == 1,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                      );
                    },
                  ).toList(),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: onAddRequest,
              child: Text(addButtonText),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void onAddRequest() {
    if (formKey.currentState?.validate() ?? false) {
      Map<String, dynamic> data = {};
      for (var field in fields) {
        data.putIfAbsent(field, () => controllers[field]?.text);
        controllers[field]?.clear();
      }
      onSubmit(data);
      Navigator.pop(context);
    }
  }
}
