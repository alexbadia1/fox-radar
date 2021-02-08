import 'package:communitytabs/components/addEvent/form_section_time_buttons.dart';
import 'package:communitytabs/components/addEvent/slideable_expansion_panel_header.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:communitytabs/presentation/components/expansion_panel_fixed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/presentation/components/components.dart';
import 'form.dart';

class CreateEventFormTime extends StatefulWidget {
  @override
  _CreateEventFormTimeState createState() => _CreateEventFormTimeState();
}

class _CreateEventFormTimeState extends State<CreateEventFormTime> {
  var _formSectionTimeStateKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    double _formSectionTimeWidth = MediaQuery.of(context).size.width;
    double _textFormFieldHeight = MediaQuery.of(context).size.height * .07;

    /// Getting Model and Controller for the START time and END time expansion panels.
    // ExpansionTiles exPanelState = Provider.of<ExpansionTiles>(context);

    /// Resetting the list of expansion panels every time the widget is rebuilt
    /// avoids infinite stacking of expansion panels.
    // List<ExpansionPanel> _expansionPanels = [];

    /// Generating the Start Time and End Time expansion Panels.
    ///
    /// For-loop index differentiates which between the Start Time
    /// and End Time expansion panels
    ///
    /// START Time expansion panel: index == 0,
    /// END Time expansion panel: index == 1.
    // for (int index = 0; index < exPanelState.data.length; ++index) {
    //   _expansionPanels.add(
    //     ExpansionPanel(
    //       headerBuilder: (BuildContext context, bool isExpanded) {
    //         return SlidableExpansionPanelHeader(index: index);
    //       },
    //       body: Column(
    //         children: <Widget>[
    //           CustomCalenderStripWrapper(
    //             isExpanded:
    //                 BlocProvider.of<ExpansionPanelCubit>(context).state.isOpen,
    //             index: index,
    //           ),
    //           DateAndTimeButtons(index: index),
    //         ],
    //       ),
    //       isExpanded:
    //           BlocProvider.of<ExpansionPanelCubit>(context).state.isOpen,
    //       canTapOnHeader:
    //           !BlocProvider.of<ExpansionPanelCubit>(context).state.isOpen,
    //     ),
    //   );
    // }
    return Container(
      width: _formSectionTimeWidth,
      child: ExpansionPanelListFixed(
        key: _formSectionTimeStateKey,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            if (BlocProvider.of<ExpansionPanelCubit>(context).state.isOpen) {
              BlocProvider.of<ExpansionPanelCubit>(context).closeExpansionPanel();
            }// if
            else {
              BlocProvider.of<ExpansionPanelCubit>(context).openExpansionPanelToDatePicker();
            }// else
          });
        },
        children: [
          /// Start DateTime
          ExpansionPanelFixed(
            backgroundColor:  Color.fromRGBO(33, 33, 33, 1.0),
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Container(
                height: _textFormFieldHeight,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    cLeftMarginSmall(context),

                    /// Leading text, for hint text
                    ExpansionPanelTitle(
                      title: 'Starts',
                      hintText: 'Add Start Time',
                      retrieveDateTimeFromBlocCallback: (CreateEventState state) {
                        return state.eventModel.getRawStartDateAndTime;
                      },
                    ),

                    Expanded(child: SizedBox()),

                    /// Trailing text for date and time label
                    Row(
                      children: <Widget>[
                        /// Date
                        DateLabel(
                          retrieveDateTimeFromBlocCallback: (CreateEventState state) {
                            return state.eventModel.getRawStartDateAndTime;
                          },
                        ),

                        Container(width: MediaQuery.of(context).size.width * .03225),

                        /// Time
                        TimeLabel(
                          retrieveDateTimeFromBlocCallback: (CreateEventState state) {
                            return state.eventModel.getRawStartDateAndTime;
                          },
                        ),
                      ],
                    ),
                    cRightMarginSmall(context),
                  ],
                ),
              );
            },

            /// Shows when the expansion panel is expanded
            body: Column(
              children: <Widget>[
                Builder(builder: (context) {
                  final ExpansionPanelState _expansionPanelCubitState = BlocProvider.of<ExpansionPanelCubit>(context).state;

                  /// Show DatePicker
                  if (_expansionPanelCubitState is ExpansionPanelOpenShowDatePicker) {
                    return DatePicker(
                      key: UniqueKey(),
                      initialSelectedDate: DateTime.now(),
                      onDateSelectedCallback: (DateTime dateTime) {
                        BlocProvider.of<CreateEventBloc>(context).add(
                          CreateEventSetRawStartDateTime(
                              newRawStartDateTime: dateTime),
                        );
                      },
                      updateBlocCallback: (DateTime dateTime) {
                        BlocProvider.of<CreateEventBloc>(context).add(
                          CreateEventSetRawStartDateTime(
                              newRawStartDateTime: dateTime),
                        );
                      },
                    );
                  } // if

                  /// Show TimePicker
                  else if (_expansionPanelCubitState is ExpansionPanelOpenShowTimePicker) {
                    return TimePicker(
                      initialDateTime: BlocProvider.of<CreateEventBloc>(context)
                          .state
                          .eventModel
                          .getRawStartDateAndTime,
                      onDateTimeChangedCallback: (dateTime) {
                        BlocProvider.of<CreateEventBloc>(context).add(
                            CreateEventSetRawStartDateTime(
                                newRawStartDateTime: dateTime));
                      },
                    );
                  } // else-if

                  /// Show empty container, this may not be necessary
                  else {
                    return Container(
                      color: cBackground,
                      height: MediaQuery.of(context).size.height * .175,
                      width: double.infinity,
                    );
                  } // else
                }),

                /// DateTime navigation buttons
                //DateAndTimeButtons(index: index),
              ],
            ),
            isExpanded: BlocProvider.of<ExpansionPanelCubit>(context).state.isOpen,
            canTapOnHeader: !BlocProvider.of<ExpansionPanelCubit>(context).state.isOpen,
          ),
        ],
      ),
    );
  }
}
