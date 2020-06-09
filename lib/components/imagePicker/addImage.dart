import 'dart:io';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImage extends StatefulWidget {
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  File pickedImage;
  final _picker = ImagePicker();

  Future getImage() async {
    PickedFile image = await _picker.getImage(source: ImageSource.camera);

//    setState(() {
//      pickedImage = File(image.path);
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(flex: 2, child: Container(color: Colors.black),),
        Expanded(flex: 1, child: Container(color: Colors.greenAccent),),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RawMaterialButton(
              onPressed: () {},
              child: Text('Gallery', style: TextStyle(color: true ? cWhite100 : cWhite70)),
            ),
            RawMaterialButton(
              child: Text('Camera', style: TextStyle(color: false ? cWhite100 : cWhite70)),
              onPressed: getImage,
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .0325,),
      ]
    );
  }
}
