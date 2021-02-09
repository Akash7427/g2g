import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(
    BuildContext context, String label, String hint) {
  return InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
          borderRadius: BorderRadius.circular(4)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(4)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(4)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(4)),
      labelText: label,
      labelStyle: TextStyle(color: Color(0xFF17477A),fontWeight: FontWeight.bold),
      contentPadding: EdgeInsets.all(8),
      hintText: hint,
      hintStyle: TextStyle(
        color: Theme.of(context).focusColor.withOpacity(0.7),
        fontWeight: FontWeight.bold
      ),
      errorMaxLines: 3);
}
