import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:database_repository/database_repository.dart';
import 'package:communitytabs/presentation/presentation.dart';

class DropdownEventsFilter extends StatefulWidget {
  @override
  _DropdownEventsFilterState createState() => _DropdownEventsFilterState();
} // DropdownEventsFilter

class _DropdownEventsFilterState extends State<DropdownEventsFilter> {
  final filters = ["Starts", "Ends", "A-Z"];
  String dropdownValue;

  List<EventModel> sortEventModels({@required List<EventModel> events, @required String sortKey}) {
    switch (sortKey) {
      case 'Starts': 
        events.sort((a, b) => a.rawStartDateAndTime.compareTo(b.rawStartDateAndTime));
        break;
      case 'Ends':
        // Events with no end date should be listed first, using 0 should ensure that.  
        events.sort((a, b) => a.rawEndDateAndTime.compareTo(b.rawEndDateAndTime ?? 0));
        break;
      case 'A-Z':
        events.sort((a, b) => a.title.compareTo(b.title));
        break;
      default:
        events.sort((a, b) => a.title.compareTo(b.title));
        break;
    }// switch

    return events;
  }//sortList

  @override
  void initState() {
    super.initState();
    this.dropdownValue = this.filters[0];
  } // initState

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 10.0,
      alignedDropdown: true,
      child: DropdownButton<String>(
        value: this.dropdownValue,
        icon: const Icon(Icons.keyboard_arrow_down, size: 20.0, color: cWhite70),
        elevation: 12,
        isDense: true,
        dropdownColor: Color.fromRGBO(33, 33, 33, 1.0),
        underline: Container(),
        selectedItemBuilder: (context) {
          return this.filters.map((String value) {
            return Text(value, style: TextStyle(fontSize: 14.0, color: cWhite100));
          }).toList();
        },
        onChanged: (String sortKey) async {

          // TODO: Listen to PinnedEventsBloc to retrieve
          //       the list or maybe just add pass the to this list?
          // this.sortEventModels(
          //   sortKey: sortKey,
          //   events: BlocProvider.of<PinnedEventsBloc>(context),
          // );

          setState(() {
            this.dropdownValue = sortKey;
          });
        },
        items: this.filters.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(
              child: Text(
                value,
                style: TextStyle(fontSize: 14.0, color: cWhite100),
              ),
            ),
          );
        }).toList(),
      ),
    );
  } // build
} // _DropdownEventsFilterState
