import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';

typedef OnTapCallbackCutsomCreateButton = void Function();

class CustomCreateButton extends StatelessWidget {
  final OnTapCallbackCutsomCreateButton onCreate;

  const CustomCreateButton({Key key, @required this.onCreate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * .03,
        ),
        Builder(
            builder: (context) {
              final CreateEventState state = context
                  .watch<CreateEventBloc>()
                  .state;
              if (state is CreateEventInvalid) {
                return GestureDetector(
                  child: Text(
                      'POST', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  onTap: null,
                );
              }
              else {
                return GestureDetector(
                  child: Text(
                      'Post', style: TextStyle(fontSize: 16, color: Colors.blueAccent)),
                  onTap: onCreate,
                );
              }
            }
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .035,
        ),
      ],
    );
  } // build
}// CustomCreateButton