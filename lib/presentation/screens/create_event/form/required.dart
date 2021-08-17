import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:communitytabs/presentation/presentation.dart';

class Required extends StatelessWidget {
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
          BorderTopBottom(
            child: CreateEventFormTextField(
                initialTextValue:
                    _currentCreateEventBlocState.eventModel.title,
                hintText: 'Title (Required)',
                height: _textFormFieldHeight,
                width: double.infinity,
                onEditingCompleteOrLostFocus: (eventDetail) {
                  BlocProvider.of<CreateEventBloc>(context)
                      .add(CreateEventSetTitle(newTitle: eventDetail));
                }),
          ),

          /// Host TextFormField
          BorderBottom(
            child: CreateEventFormTextField(
                initialTextValue:
                    _currentCreateEventBlocState.eventModel.host,
                hintText: 'Host (Required)',
                height: _textFormFieldHeight,
                width: _textFormFieldWidth,
                onEditingCompleteOrLostFocus: (eventDetail) {
                  BlocProvider.of<CreateEventBloc>(context)
                      .add(CreateEventSetHost(newHost: eventDetail));
                }),
          ),

          /// Location TextFormField and Room TextFormField
          BorderBottom(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 6,

                  /// Location TextFormField
                  child: CreateEventFormTextField(
                    initialTextValue:
                        _currentCreateEventBlocState.eventModel.location,
                    hintText: 'Location (Required)',
                    height: _textFormFieldHeight,
                    width: _textFormFieldWidth,
                    onEditingCompleteOrLostFocus: (eventDetail) {
                      BlocProvider.of<CreateEventBloc>(context).add(
                          CreateEventSetLocation(newLocation: eventDetail));
                    },
                  ),
                ),
                /// Room TextFormField
                Expanded(
                  flex: 4,
                  child: CreateEventFormTextField(
                    initialTextValue:
                        _currentCreateEventBlocState.eventModel.room,
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
          ),
        ],
      ),
    );
  } // build
} // CreateEventFormRequired
