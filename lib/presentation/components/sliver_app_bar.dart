import 'package:communitytabs/buttons/maristFoxLogo.dart';
import 'file:///C:/Users/18454/AndroidStudioProjects/Marist_Community_Tabs/lib/presentation/buttons/searchButton.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:flutter/material.dart';

class MaristSliverAppBarTitle extends StatelessWidget {
  final String title;
  const MaristSliverAppBarTitle({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(
          title,
          style: TextStyle(color: kHavenLightGray, fontSize: 19.0, fontWeight: FontWeight.bold),
        )
    );
  }
}


class MaristSliverAppBar extends StatelessWidget {
  final String title;
  const MaristSliverAppBar({@required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      pinned: true,
      flexibleSpace: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.0725,
        child: Stack(
          children: <Widget>[
            Image(
                width: double.infinity,
                height: 100.0,
                image: ResizeImage(
                  AssetImage("images/tenney.jpg"),
                  width: 500,
                  height: 100,
                ),
                fit: BoxFit.fill),
            Container(
              decoration: BoxDecoration(gradient: cMaristGradientWashed),
            ),
            Row(
              children: <Widget>[
                Expanded(flex: 1, child: SizedBox()),
                Expanded(flex: 4, child: MaristFoxLogo()),
                Expanded(flex: 1, child: SizedBox()),
                Expanded(flex: 30, child: MaristSliverAppBarTitle(title: this.title)),
                Expanded(flex: 3, child: SearchButton()),
                Expanded(flex: 2, child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
