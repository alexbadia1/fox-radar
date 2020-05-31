import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../colors/marist_color_scheme.dart';
import '../data/IconsStateProvider.dart';

class TemporaryCloseButton extends StatefulWidget {
  @override
  _TemporaryCloseButtonState createState() => _TemporaryCloseButtonState();
}

class _TemporaryCloseButtonState extends State<TemporaryCloseButton> {
  @override
  Widget build(BuildContext context) {
    PanelController pc = Provider.of<PanelController>(context);
    return Consumer<IconStateProvider>(
      builder: (context, iconState, child) {
        return iconState.showSearch
            ? RawMaterialButton(
                onPressed: () {
                  ///TODO: Redirect to Marist website
                },
                child: Center(
                  child: Image(
                    width: MediaQuery.of(context).size.width * .1,
                    image: AssetImage('images/fox.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              )
            : Container(
              child: iconState.formStepNum > 1 ? IconButton(
                icon: Icon(Icons.chevron_left),
                color: kHavenLightGray,
                onPressed: () {
                  iconState.setFormStepNum(iconState.formStepNum - 1);
                  FocusScope.of(context).unfocus();
                  iconState.pageViewController.animateToPage(iconState.formStepNum - 1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                },
              ) : IconButton(
                  icon: Icon(Icons.close),
                  color: kHavenLightGray,
                  onPressed: () {
                    //Close Keyboard
                    FocusScope.of(context).unfocus();
                    iconState.setShowDrawer(true);
                    iconState.setShowSearch(true);
                    pc.close();
                  },
                ),
            );
      },
    );
  }
}
