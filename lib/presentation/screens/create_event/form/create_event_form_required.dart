import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/presentation/screens/create_event/form/form.dart';

class CreateEventFormRequired extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _formSectionOneWidth = MediaQuery.of(context).size.width;
    double _textFormFieldWidth = MediaQuery.of(context).size.width;
    double _textFormFieldHeight = MediaQuery.of(context).size.height * .07;

    final _currentCreateEventBlocState =
        BlocProvider.of<CreateEventBloc>(context).state;
    return Container(
      width: _formSectionOneWidth,
      child: Column(
        children: <Widget>[
          /// Title TextFormField
          CreateEventFormTextField(
              initialTextValue:
                  _currentCreateEventBlocState.eventModel.getTitle,
              hintText: 'Title (Required)',
              height: _textFormFieldHeight,
              width: _textFormFieldWidth,
              onEditingCompleteOrLostFocus: (eventDetail) {
                BlocProvider.of<CreateEventBloc>(context)
                    .add(CreateEventSetTitle(newTitle: eventDetail));
              }),

          /// Host TextFormField
          CreateEventFormTextField(
              initialTextValue: _currentCreateEventBlocState.eventModel.getHost,
              hintText: 'Host (Required)',
              height: _textFormFieldHeight,
              width: _textFormFieldWidth,
              onEditingCompleteOrLostFocus: (eventDetail) {
                BlocProvider.of<CreateEventBloc>(context)
                    .add(CreateEventSetHost(newHost: eventDetail));
              }),

          /// Location TextFormField and Room TextFormField
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 6,

                /// Location TextFormField
                child: CreateEventFormTextField(
                  initialTextValue:
                      _currentCreateEventBlocState.eventModel.getLocation,
                  hintText: 'Location (Required)',
                  height: _textFormFieldHeight,
                  width: _textFormFieldWidth,
                  onEditingCompleteOrLostFocus: (eventDetail) {
                    BlocProvider.of<CreateEventBloc>(context)
                        .add(CreateEventSetLocation(newLocation: eventDetail));
                  },
                ),
              ),
              Expanded(child: SizedBox()),

              /// Room TextFormField
              Expanded(
                flex: 4,
                child: CreateEventFormTextField(
                  initialTextValue:
                      _currentCreateEventBlocState.eventModel.getRoom,
                  hintText: 'Room',
                  height: _textFormFieldHeight,
                  width: _textFormFieldWidth,
                  onEditingCompleteOrLostFocus: (eventDetail) {
                    BlocProvider.of<CreateEventBloc>(context)
                        .add(CreateEventSetRoom(newRoom: eventDetail));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  } // build
} // CreateEventFormRequired
