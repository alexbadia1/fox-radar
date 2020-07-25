import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/categoryPanels.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  var _categoryExpansionPanelListKey = UniqueKey();
  List<Widget> categoryWidgets = [];
  List<String> categories = [
    'Academic',
    'Club Sports',
    'College Sports',
    'Culture',
    'Fraternity',
    'Free Food',
    'Intramural',
    'Marist Dining',
    'Media & Publication',
    'Movies & Theatre',
    'Music & Dance',
    'Occasions',
    'Politcal',
    'Religion',
    'Rushes',
    'Spiritual',
    'Sorority',
  ];

  @override
  Widget build(BuildContext context) {
    categoryWidgets = [];
    for (int i = 0; i < categories.length; ++i) {
      categoryWidgets.add(Center(child: Text(categories[i], style: TextStyle(color: cWhite100)),));
    }
    CategoryPanels _categoryPanelsModelAndController =
        Provider.of<CategoryPanels>(context);
    List<ExpansionPanel> _categoryPanelsList = [
      ExpansionPanel(
        isExpanded:
            _categoryPanelsModelAndController.getCategoryPanels()[0].isExpanded,
        canTapOnHeader: !_categoryPanelsModelAndController
            .getCategoryPanels()[0]
            .isExpanded,
        headerBuilder: (BuildContext context, bool isExpanded) {
          return CategoryHeaderLabel();
        },
        body: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * .175,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: TextStyle(color: Colors.white))),
                child: CupertinoPicker(
                  backgroundColor: Color.fromRGBO(0, 0, 0, .9325),
                  itemExtent: 40.0,
                  children: categoryWidgets,
                  onSelectedItemChanged: (value) {
                    _categoryPanelsModelAndController.tempCategory = categories[value];
                  },
                ),
              ),
            ),
            CategoryButtons(),
          ],
        ),
      ),
    ];

    return Container(
      width: MediaQuery.of(context).size.width,
      child: ExpansionPanelList(
        key: this._categoryExpansionPanelListKey,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _categoryPanelsModelAndController
                    .getCategoryPanels()[index]
                    .isExpanded =
                !_categoryPanelsModelAndController
                    .getCategoryPanels()[index]
                    .isExpanded;
          });
        },
        children: _categoryPanelsList,
      ),
    );
  }
}

class CategoryHeaderLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double pWidth = MediaQuery.of(context).size.width;
    double pHeight = MediaQuery.of(context).size.height;
    return Container(
      height: pHeight * .07,
      width: pWidth,
      decoration: BoxDecoration(
          color: cCard, border: Border(top: cBorder, bottom: cBorder)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: pWidth * .05),
              Text('Category',
                  style: TextStyle(color: cWhite100, fontSize: 16.0)),
            ],
          ),
          Row(
            children: <Widget>[
              CategoryChoiceLabel(),
              SizedBox(width: pWidth * .05),
            ],
          )
        ],
      ),
    );
  }
}

class CategoryChoiceLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryPanels>(
        builder: (context, categoryPanelModelAndController, child) {
      return Text(
          categoryPanelModelAndController.getCategoryPanels()[0].categoryPicked,
          style: TextStyle(color: cWhite100, fontSize: 16.0));
    });
  }
}


class CategoryButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CategoryPanels _categoryPanelsModelAndController =
    Provider.of<CategoryPanels>(context);
    return Container(
      decoration: BoxDecoration(
          color: cCard,
          border:
          Border(bottom: BorderSide(width: .25, color: Color.fromRGBO(255, 255, 255, .7)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FlatButton(
            child: Text('Cancel', style: TextStyle(color: cWhite100)),
            onPressed: () {
              _categoryPanelsModelAndController.getCategoryPanels()[0].isExpanded = false;
              _categoryPanelsModelAndController.updateCategoryPanelState();
            },
          ),
          FlatButton(
            child: Text('Confirm', style: TextStyle(color: Colors.blueAccent)),
            onPressed: () {
              _categoryPanelsModelAndController.getCategoryPanels()[0].isExpanded = false;
              _categoryPanelsModelAndController.getCategoryPanels()[0].categoryPicked = _categoryPanelsModelAndController.tempCategory;
              _categoryPanelsModelAndController.updateCategoryPanelState();
            },
          ),
        ],
      ),
    );
  }
}