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
        print('Current List being used: ' +
            myHighlights.getHighlights.toString());
        for (int index = 0;
            index < myHighlights.getHighlights.length;
            ++index) {
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
  FocusNode focusNode;
  String currentInput = '';

  @override
  void initState(){
    super.initState();
    final _myHighlights = Provider.of<ClubEventData>(context, listen: false);
    focusNode = new FocusNode();
    focusNode.addListener((){
      if(!focusNode.hasFocus){
        print('I lost focus');
        List<String> tempList = _myHighlights.getHighlights;
        print('Created temp list');
        tempList[this.widget.index] = currentInput;
        print('Added current user input to temp list');
        _myHighlights.setHighlights(tempList);
        print('Highlights updated with temp list');
        _myHighlights.applyChanges();
        print('Highlight List after a textfield has been edited: ' +
            _myHighlights.getHighlights.toString());
      }
    });
  }

  void onEditingCompleteCallback (ClubEventData myHighlights, TextEditingController controller) {
    List<String> tempList = myHighlights.getHighlights;
    controller.text.trim().isEmpty
        ? tempList[this.widget.index] = ''
        : tempList[this.widget.index] = controller.text;
    myHighlights.setHighlights(tempList);
    myHighlights.applyChanges();
    print('Highlight List after a textfield has been edited: ' +
        myHighlights.getHighlights.toString());
    focusNode.unfocus();
  }

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
                  focusNode: focusNode,
                  key: Key(myHighlights.getHighlights[this.widget.index]),
                  onEditingComplete: () => onEditingCompleteCallback(myHighlights, _controller),
                  onFieldSubmitted: (value){
                    focusNode.unfocus();
                  },
                  onChanged: (value) {
                    currentInput = value;
                  },
                  autofocus: false,
                  style: TextStyle(color: cWhite100),
                  textInputAction: TextInputAction.done,
                  decoration: cAddEventTextFormFieldDecoration.copyWith(
                      hintText: 'HightLight ' + (this.widget.index).toString()),
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
