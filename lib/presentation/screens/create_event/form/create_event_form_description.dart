import 'package:flutter/material.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'form.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';

class CreateEventFormDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height * .2;
    final _currentCreateEventBlocState = BlocProvider.of<CreateEventBloc>(context).state;
    return Container(
      width: _width,
      height: _height,
      child: Row(
        children: <Widget>[
          /// Description TextFormField
          Expanded(
           child: CreateEventFormTextField(
               initialTextValue:
               _currentCreateEventBlocState.eventModel.getSummary,
               hintText: 'Description',
               height: _width,
               width: _height,
               onEditingCompleteOrLostFocus: (eventDetail) {
                 BlocProvider.of<CreateEventBloc>(context).add(CreateEventSetDescription(newDescription: eventDetail));
               }),
          ),
          cRightMarginSmall(context),
        ],
      ),
    );
  }// build
}// CreateEventFormDescription