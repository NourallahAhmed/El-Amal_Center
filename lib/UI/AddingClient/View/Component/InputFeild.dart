import 'package:flutter/material.dart';

class InputFeild extends StatelessWidget {
  const InputFeild({
    Key? key,
    required this.hint,
    required this.iconData,
    required this.txtController,
    required this.keyType,
    required this.label,
  }) : super(key: key);

  final String hint;
  final IconData iconData;
  final TextEditingController txtController;
  final TextInputType keyType;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            keyboardType: keyType,
            controller: txtController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              labelText: label,
              prefixIcon: Icon(iconData),
            ),

          )

      ),
    );
  }
}