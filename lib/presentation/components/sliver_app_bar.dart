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
      style: TextStyle(color: kHavenLightGray, fontSize: 19.0, fontWeight: FontWeight.bold),
    ));
  }
}

class MaristSliverAppBar extends StatelessWidget {
  final String title;
  final Widget action;
  final IconData icon;
  final Function onIconPressed;

  Image _backgroundImage;

  MaristSliverAppBar({@required this.title, this.action, this.icon, this.onIconPressed}) {
    _backgroundImage = new Image.asset(
      "images/tenney.jpg",
      fit: BoxFit.fill,
    );
  } // MaristSliverAppBar

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = MediaQuery.of(context).size.height * 0.0725;
    final double safePaddingTop = WidgetsBinding.instance.window.padding.top / WidgetsBinding.instance.window.devicePixelRatio;

    precacheImage(_backgroundImage.image, context);
    return SliverAppBar(
      foregroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      toolbarHeight: appBarHeight,
      elevation: 1.0,
      pinned: true,
      actions: [this.action],
      flexibleSpace: Container(
        width: double.infinity,
        height:  appBarHeight + safePaddingTop,
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
                Expanded(
                  flex: 4,
                  child: this.icon != null
                      ? Padding(
                          padding: EdgeInsets.only(top: safePaddingTop),
                          child: IconButton(
                            onPressed: this.onIconPressed,
                            icon: Icon(this.icon, color: kHavenLightGray),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: safePaddingTop),
                          child: MaristFoxLogo(),
                        ),
                ),
                Expanded(flex: 1, child: SizedBox()),
                Expanded(
                  flex: 30,
                  child: Padding(
                    padding: EdgeInsets.only(top: safePaddingTop),
                    child: MaristSliverAppBarTitle(title: this.title),
                  ),
                ),
                Expanded(flex: 2, child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
