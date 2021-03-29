import 'package:communitytabs/buttons/previousOrCloseButton.dart';
import 'package:communitytabs/components/imagePicker/imageUpload.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';

class AddEventAppBar extends StatefulWidget {
  @override
  _AddEventAppBarState createState() => _AddEventAppBarState();
}

class _AddEventAppBarState extends State<AddEventAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * .0725,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // PreviousOrCloseButton(),
                Center(
                  child: Text(
                    'Add Event',
                    style: TextStyle(color: kHavenLightGray, fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                // UploadImage(),
              ],
            )
          ],
        ),
    );
  }
}
