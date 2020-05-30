import 'package:communitytabs/Screens/categoryScreen.dart';
import 'package:communitytabs/colors/marist_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomNavigationItem extends StatelessWidget {
  final String option;
  final IconData icon;
  final String nextPage;
  final LinearGradient gradient;
  CustomNavigationItem({this.gradient, this.option, this.icon, this.nextPage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0),
      child: Container(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
            FlatButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                //TODO: Add a Slide-In-Right transition to the specified Category Page
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      CategoryScreen(
                    namedRoute: nextPage,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Container(
                        width: MediaQuery.of(context).size.width * .2,
                        child: Text(
                          option,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: kHavenLightGray),
                        )),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .1,
                  ),
                  Container(
                      child: Center(child: Icon(icon, color: kHavenLightGray))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
