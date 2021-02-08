// import 'package:communitytabs/constants/marist_color_scheme.dart';
// import 'package:communitytabs/data/expansionTileMetadata.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:communitytabs/logic/blocs/blocs.dart';
//
// class CustomCalenderStripWrapper extends StatefulWidget {
//   final int index;
//   final bool isExpanded;
//   CustomCalenderStripWrapper({this.isExpanded, this.index});
//   @override
//   _CustomCalenderStripWrapperState createState() =>
//       _CustomCalenderStripWrapperState();
// } // CustomCalenderStripWrapper
//
// class _CustomCalenderStripWrapperState
//     extends State<CustomCalenderStripWrapper> {
//   @override
//   Widget build(BuildContext context) {
//     return this.widget.isExpanded
//         ? DateOrTimePicker(key: UniqueKey(), index: this.widget.index)
//         : Container(
//             color: cBackground,
//             height: MediaQuery.of(context).size.height * .175,
//             width: double.infinity,
//           );
//   }
// }
//
// class DateOrTimePicker extends StatelessWidget {
//   final Key key;
//   final int index;
//
//   DateOrTimePicker({this.key, this.index}): super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ExpansionTiles>(
//       builder: (context, calenderPickerState, child) {
//         if (index == 0) {
//           if (calenderPickerState.getTempStartTime() == null)
//             calenderPickerState.setTempStartTime(
//                 calenderPickerState.data[index].getHeaderTimeValue() ??
//                     DateTime.now());
//         } else {
//           if (calenderPickerState.getTempEndTime() == null)
//             calenderPickerState.setTempEndTime(
//                 calenderPickerState.data[index].getHeaderTimeValue() ??
//                     DateTime.now());
//         }
//         return index == 0
//             ? calenderPickerState.getShowAddStartTimeCalenderStrip()
//                 ? CustomCalenderStrip(index: index, key: this.key)
//                 : TimePicker(
//                     initialDateTime: BlocProvider.of<CreateEventBloc>(context)
//                         .state
//                         .eventModel
//                         .getRawStartDateAndTime,
//                     onDateTimeChangedCallback: (dateTime) {
//                       BlocProvider.of<CreateEventBloc>(context).add(
//                           CreateEventSetRawStartDateTime(
//                               newRawStartDateTime: dateTime));
//                     },
//                   )
//             : calenderPickerState.getShowAddEndTimeCalenderStrip()
//                 ? CustomCalenderStrip(index: index, key: this.key)
//                 : TimePicker(
//                     initialDateTime: BlocProvider.of<CreateEventBloc>(context)
//                         .state
//                         .eventModel
//                         .getRawStartDateAndTime,
//                     onDateTimeChangedCallback: (dateTime) {
//                       BlocProvider.of<CreateEventBloc>(context).add(
//                           CreateEventSetRawStartDateTime(
//                               newRawStartDateTime: dateTime));
//                     },
//                   );
//       },
//     );
//   }
// }
