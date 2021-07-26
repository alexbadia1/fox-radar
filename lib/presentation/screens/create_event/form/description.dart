import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:communitytabs/presentation/presentation.dart';

class Description extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height * .15;
    final _currentCreateEventBlocState = BlocProvider.of<CreateEventBloc>(context).state;
    return BorderTopBottom(
      width: _width,
      height: _height,
      child: Row(
        children: <Widget>[
          /// Description TextFormField
          Expanded(
           child: CreateEventFormTextField(
             keyboardType: TextInputType.multiline,
               maxLines: 5,
               minLines: 3,
               initialTextValue:
               _currentCreateEventBlocState.eventModel.description,
               hintText: 'Description',
               height: _width,
               width: _height,
               onEditingCompleteOrLostFocus: (eventDetail) {
                 BlocProvider.of<CreateEventBloc>(context).add(CreateEventSetDescription(newDescription: eventDetail));
               })
          ),
        ],
      ),
    );
  }// build
}// CreateEventFormDescription