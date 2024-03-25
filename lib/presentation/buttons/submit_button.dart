import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_radar/logic/logic.dart';

typedef OnSubmit = void Function();

class CreateEventFormSubmitButton extends StatelessWidget {
  final String text;
  final OnSubmit onSubmit;

  const CreateEventFormSubmitButton(
      {Key? key, required this.onSubmit, required this.text})
      : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * .03,
        ),
        Builder(builder: (context) {
          final CreateEventState state = context.watch<CreateEventBloc>().state;
          if (state is CreateEventInvalid) {
            return GestureDetector(
              child: Text(this.text ?? 'SUBMIT',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              onTap: null, // Disabled
            );
          } else {
            return GestureDetector(
              child: Text(this.text ?? 'SUBMIT',
                  style: TextStyle(fontSize: 16, color: Colors.blueAccent)),
              onTap: onSubmit,
            );
          }
        }),
        SizedBox(
          width: MediaQuery.of(context).size.width * .035,
        ),
      ],
    );
  } // build
} // CustomCreateButton
