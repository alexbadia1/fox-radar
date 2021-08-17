import 'package:flutter/material.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:communitytabs/presentation/presentation.dart';

class DropdownEventsFilter extends StatefulWidget {
  @override
  _DropdownEventsFilterState createState() => _DropdownEventsFilterState();
} // DropdownEventsFilter

class _DropdownEventsFilterState extends State<DropdownEventsFilter> {
  final filters = [SORT_KEY_START_DATE_TIME, SORT_KEY_ALPHABETICAL];
  String dropdownValue;

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
        onChanged: (String sortKey) {
          BlocProvider.of<PinnedEventsBloc>(context).add(PinnedEventsEventSort(sortKey));
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
