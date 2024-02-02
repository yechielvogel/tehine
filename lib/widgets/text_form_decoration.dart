import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.onChanged,
    this.onFieldSubmitted,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,    
      onSaved: onSaved,
      cursorColor: Colors.grey[850],
      decoration: InputDecoration(
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.background,
          ),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[850]),
        fillColor: Colors.grey[350],
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.grey[350] ?? Colors.grey,
            width: 3.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.grey[350] ?? Colors.grey,
            width: 3.0,
          ),
        ),
        errorStyle: TextStyle(
          color: Colors.grey[350],
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.grey[350] ?? Colors.grey,
            width: 3.0,
          ),
        ),
      ),
      style: TextStyle(color: Colors.grey[850]),
    );
  }
}
