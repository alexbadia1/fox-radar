import 'package:flutter/material.dart';
import 'package:fox_radar/presentation/presentation.dart';

//Form Text Field Decoration
const InputDecoration customTextField = InputDecoration(
  errorStyle: TextStyle(color: Colors.black),
  errorBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: Color.fromRGBO(255, 255, 255, .5),
    ),
  ),
);

const InputDecoration cAddEventTextFormFieldDecoration = InputDecoration(
  errorStyle: TextStyle(color: Colors.black),
  errorBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(255, 255, 255, .5)),
  ),
  hintStyle: TextStyle(color: cWhite25),
  border: InputBorder.none,
);

SnackBar formErrorSnackBar(BuildContext context, String message) {
  return SnackBar(
    content: Container(
      height: MediaQuery.of(context).size.height * .07,
      width: double.infinity,
      alignment: Alignment.topCenter,
      child: Text(
        message,
        style: TextStyle(color: Colors.redAccent),
      ),
    ),
  );
}