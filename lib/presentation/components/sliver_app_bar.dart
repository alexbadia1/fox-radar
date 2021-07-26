import 'package:flutter/material.dart';
import 'package:communitytabs/presentation/presentation.dart';


class MaristSliverAppBarTitle extends StatelessWidget {
  final String title;

  const MaristSliverAppBarTitle({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(
      title,
      style: TextStyle(
          color: kHavenLightGray, fontSize: 19.0, fontWeight: FontWeight.bold),
    ));
  }
}

class MaristSliverAppBar extends StatelessWidget {
  final String title;
  final Widget action;

  Image _backgroundImage;

  MaristSliverAppBar({@required this.title, this.action}) {
    _backgroundImage = new Image.asset(
      "images/tenney.jpg",
      fit: BoxFit.fill,
    );
  } // MaristSliverAppBar

  @override
  Widget build(BuildContext context) {
    precacheImage(_backgroundImage.image, context);
    return SliverAppBar(
      foregroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      toolbarHeight: MediaQuery.of(context).size.height * 0.0725,
      elevation: 1.0,
      pinned: true,
      actions: [this.action], // Scaffold inherits drawer
      flexibleSpace: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.0725,
        child: Stack(
          children: <Widget>[
            /// TODO: Figure out how to load this faster!
            // _backgroundImage,
            Container(
              decoration: BoxDecoration(gradient: cMaristGradientWashed),
            ),
            Row(
              children: <Widget>[
                Expanded(flex: 1, child: SizedBox()),
                Expanded(flex: 4, child: MaristFoxLogo()),
                Expanded(flex: 1, child: SizedBox()),
                Expanded(
                    flex: 30,
                    child: MaristSliverAppBarTitle(title: this.title)),
                Expanded(flex: 2, child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
