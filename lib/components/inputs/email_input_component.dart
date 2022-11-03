import "package:com_nicodevelop_dotmessenger/widgets/input_decorator_widget.dart";
import "package:flutter/material.dart";

class EmailInputComponent extends StatelessWidget {
  final TextEditingController controller;

  final String? Function(String? value)? validator;

  final String label;
  final String placeholder;

  const EmailInputComponent({
    super.key,
    required this.controller,
    this.validator,
    this.label = "Email",
    this.placeholder = "Enter your email",
  });

  @override
  Widget build(BuildContext context) {
    return InputDecoratorWidget(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
        ),
        keyboardType: TextInputType.emailAddress,
        validator: validator,
      ),
    );
  }
}
