import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/club_event_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class SlidableHighlightList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ClubEventData>(
      builder: (context, myHighlights, child) {
        List<Widget> highlightsWidgets = [];
        for (int index = 0;
            index < myHighlights.getHighlights.length;
            ++index) {
          print('Current List being used: ' +
              myHighlights.getHighlights.toString());
          highlightsWidgets.add(SlidableHighlightTextFormField(index: index));
        }
        return ListView(
          primary: false,
          shrinkWrap: true,
          children: highlightsWidgets,
        );
      },
    );
  }
}

class SlidableHighlightTextFormField extends StatefulWidget {
  final int index;
  SlidableHighlightTextFormField({this.index}) : super(key: ValueKey(index),);

  @override
  _SlidableHighlightTextFormFieldState createState() =>
      _SlidableHighlightTextFormFieldState();
}

class _SlidableHighlightTextFormFieldState extends State<SlidableHighlightTextFormField> {
  @override
  Widget build(BuildContext context) {
    ClubEventData myHighlights = Provider.of<ClubEventData>(context);
    double _textFormFieldWidth = MediaQuery.of(context).size.width;
    double _textFormFieldHeight = MediaQuery.of(context).size.height * .07;
    TextEditingController _controller = new TextEditingController(text: myHighlights.getHighlights[this.widget.index],);
    return Slidable(
        enabled: true,
        direction: Axis.horizontal,
        actionPane: SlidableStrechActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
          height: _textFormFieldHeight,
          width: _textFormFieldWidth,
          decoration:
              BoxDecoration(color: cCard, border: Border(bottom: cBorder)),
          child: Row(
            children: <Widget>[
              cLeftMarginMedium(context),
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  key: Key(myHighlights.getHighlights[this.widget.index]),
                  onEditingComplete: () {
                    List<String> tempList = myHighlights.getHighlights;
                    _controller.text.trim().isEmpty
                        ? tempList[this.widget.index] = ''
                        : tempList[this.widget.index] = _controller.text;
                    myHighlights.setHighlights(tempList);
                    myHighlights.applyChanges();
                    print('Highlight List after a textfield has been edited: ' +
                        myHighlights.getHighlights.toString());
                  },
                  autofocus: false,
                  style: TextStyle(color: cWhite100),
                  textInputAction: TextInputAction.done,
                  decoration: cAddEventTextFormFieldDecoration.copyWith(
                      hintText: 'HightLight ' + (this.widget.index).toString()),
                  onChanged: (value) {
                  },
                ),
              ),
              cRightMarginSmall(context)
            ],
          ),
        ),
        secondaryActions: <Widget>[
          DeleteHighlightButton(index: this.widget.index)
        ]);
  }
}

class DeleteHighlightButton extends StatelessWidget {
  final int index;
  DeleteHighlightButton({this.index});
  @override
  Widget build(BuildContext context) {
    ClubEventData newEvent = Provider.of<ClubEventData>(context);
    return Container(
      color: Colors.red,
      child: Center(
        child: IconButton(
          icon: Icon(Icons.delete, color: Colors.white),
          onPressed: () {
            Slidable.of(context).close();
            List<String> tempList = newEvent.getHighlights;
            tempList.removeAt(index);
            newEvent.setHighlights(tempList);
            newEvent.applyChanges();
            print('Highlight list after a highlight is removed: ' +
                newEvent.getHighlights.toString());
          },
        ),
      ),
    );
  }
}
