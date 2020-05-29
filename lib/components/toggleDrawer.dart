import 'package:communitytabs/colors/marist_color_scheme.dart';
import 'package:communitytabs/data/IconsStateProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoverContainer extends StatelessWidget {
  final openDrawerCallback;
  CoverContainer({this.openDrawerCallback});
  @override
  Widget build(BuildContext context) {
    return Consumer<IconStateProvider>(builder: (context, iconState, child) {
      return iconState.showDrawer
          ? Container(
              child: IconButton(
                onPressed: () {
                  print('Drawer Icon Pressed');
                  return openDrawerCallback(2);
                  },
                color: kHavenLightGray,
                icon: Icon(Icons.dehaze),
              ),
            )
          : Container();
    });
  }
}
