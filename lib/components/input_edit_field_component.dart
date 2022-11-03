import "package:com_nicodevelop_dotmessenger/widgets/input_decorator_widget.dart";
import "package:flutter/material.dart";

class InputEditFieldComponent extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  final Function() onSave;

  const InputEditFieldComponent({
    Key? key,
    required this.label,
    required this.controller,
    required this.onSave,
  }) : super(key: key);

  @override
  State<InputEditFieldComponent> createState() =>
      _InputEditFieldComponentState();
}

class _InputEditFieldComponentState extends State<InputEditFieldComponent> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    if (widget.controller.text.isNotEmpty && !_isEditing) {
      return Row(
        children: [
          Expanded(
            child: Text(
              widget.controller.text,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          IconButton(
              onPressed: () => setState(() => _isEditing = !_isEditing),
              icon: const Icon(
                Icons.edit,
              )),
        ],
      );
    }

    return InputDecoratorWidget(
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          suffixIcon: IconButton(
            onPressed: () {
              widget.onSave();
              setState(() => _isEditing = !_isEditing);
            },
            icon: const Icon(
              Icons.save,
            ),
          ),
        ),
      ),
    );
  }
}
