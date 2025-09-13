import 'package:flutter/material.dart';

Widget buildInput(
  String label, {
  bool obscureText = false,
  TextEditingController? controller,
  String? Function(String?)? validator,
}) {
  return Container(
    margin: const EdgeInsets.only(top: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.blue.shade100),
      boxShadow: [
        BoxShadow(
          color: Colors.blue.shade50,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        hintText: label,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: InputBorder.none,
      ),
    ),
  );
}
