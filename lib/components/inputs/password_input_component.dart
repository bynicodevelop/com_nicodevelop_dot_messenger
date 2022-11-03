import "package:com_nicodevelop_dotmessenger/widgets/input_decorator_widget.dart";
import "package:flutter/material.dart";

class PasswordInputComponent extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  final String label;
  final String placeholder;

  const PasswordInputComponent({
    super.key,
    required this.controller,
    this.validator,
    this.label = "Password",
    this.placeholder = "Enter your password",
  });

  @override
  State<PasswordInputComponent> createState() => _PasswordInputComponentState();
}

class _PasswordInputComponentState extends State<PasswordInputComponent> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return InputDecoratorWidget(
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.placeholder,
          suffixIcon: IconButton(
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(
              () => _obscureText = !_obscureText,
            ),
          ),
        ),
        validator: widget.validator,
        keyboardType: TextInputType.visiblePassword,
        obscureText: _obscureText,
      ),
    );
  }
}
