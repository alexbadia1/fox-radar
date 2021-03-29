import 'package:collection/collection.dart';
import 'form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';

class Highlights extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height * .0775;

    return Container(
      color: Color.fromRGBO(33, 33, 33, 1.0),
      child: Column(
        children: [
          BorderTopBottom(
            width: _width,
            height: _height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                cLeftMarginSmall(context),
                // Leading text, for hint text
                Text(
                  'Highlights',
                  style: TextStyle(fontSize: 15.0, color: cWhite100),
                ),

                Expanded(child: SizedBox()),


                Builder(builder: (context) {
                    final _createEventState =
                        context.watch<CreateEventBloc>().state;

                    /// TODO: Set limit as a constant in the Event Model
                    // Disable the "Add Highlights" Button if Highlight length is reached
                    if (_createEventState.eventModel.getHighlights.length >= 5) {
                      return Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.grey,
                          ),
                          onPressed: () {},
                        ),
                      );
                    } // if

                    return Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          /// TODO: Add CreateEventSetHighlights Event to the Create Event Bloc
                          FocusScope.of(context).unfocus();
                          if (BlocProvider.of<CreateEventBloc>(context)
                                  .state
                                  .eventModel
                                  .getHighlights
                                  .length <
                              5) {
                            BlocProvider.of<CreateEventBloc>(context)
                                .add(CreateEventAddHighlight(highlight: ''));
                          } // if
                        },
                      ),
                    );
                  }),
                cRightMarginSmall(context),
              ],
            ),
          ),
          BlocBuilder<CreateEventBloc, CreateEventState>(
            buildWhen: (previousState, currentState) {
              // Null Check
              if (previousState.eventModel.getHighlights == null) {
                if (currentState.eventModel.getHighlights == null) {
                  return false;
                } // if
                else {
                  return true;
                } // else
              } // if
              return !ListEquality().equals(
                  previousState.eventModel.getHighlights,
                  currentState.eventModel.getHighlights);
            },
            builder: (context, createEventState) {
              final _highlights = createEventState.eventModel.getHighlights;
              List<Widget> _highlightTextFieldList = [];

              for (int i = 0; i < _highlights.length; ++i) {
                _highlightTextFieldList.add(
                  BorderBottom(
                    child: Slidable(
                      enabled: true,
                      direction: Axis.horizontal,
                      actionPane: SlidableStrechActionPane(),
                      actionExtentRatio: 0.15,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: CreateEventFormTextField(
                          key: Key(_highlights[i]),
                          height: _height,
                          width: _width,
                          hintText: 'Highlight ${i + 1}',
                          initialTextValue: _highlights[i],
                          onEditingCompleteOrLostFocus: (String eventHighlight) {
                            BlocProvider.of<CreateEventBloc>(context).add(
                                CreateEventSetHighlight(
                                    highlight: eventHighlight, index: i));
                          },
                        ),
                      ),
                      secondaryActions: <Widget>[
                        Container(
                          color: Colors.red,
                          child: Center(
                            child: Builder(
                              builder: (context) {
                                return IconButton(
                                  key: UniqueKey(),
                                  icon: Icon(Icons.delete, color: Colors.white),
                                  onPressed: () {
                                    Slidable.of(context).close();
                                    BlocProvider.of<CreateEventBloc>(context).add(
                                        CreateEventSetHighlight(
                                            highlight: 'deleted', index: i));
                                    BlocProvider.of<CreateEventBloc>(context)
                                        .add(CreateEventRemoveHighlight(index: i));
                                  },
                                );
                              }
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } // for

              return ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: _highlightTextFieldList,
              );
            },
          ),
        ],
      ),
    );
  } // build
} // Highlights
