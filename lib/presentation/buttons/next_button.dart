import 'package:flutter/material.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef OnTapCallbackCutsomNextButton = void Function();

class CustomNextButton extends StatelessWidget {
  final OnTapCallbackCutsomNextButton onClose;

  const CustomNextButton({Key key, @required this.onClose}) : super(key: key);

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
                    'Next', style: TextStyle(fontSize: 16, color: Colors.grey)),
                onTap: null,
              );
            }
            else {
              return GestureDetector(
                child: Text(
                    'Next', style: TextStyle(fontSize: 16, color: Colors.blueAccent)),
                onTap: onClose,
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
}
