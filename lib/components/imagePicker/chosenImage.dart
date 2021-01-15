import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/selectedImageModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class SelectedImage extends StatefulWidget {
  @override
  _SelectedImageState createState() => _SelectedImageState();
}

class _SelectedImageState extends State<SelectedImage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  // final _picker = ImagePicker();
  //
  // Future getImage() async {
  //   final imageModel = Provider.of<SelectedImageModel>(context, listen: false);
  //   PickedFile image = await _picker.getImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     final bytes = await image.readAsBytes();
  //     imageModel.setImageBytes(
  //         newImageBytes: bytes, newRelativePath: image.path);
  //   }
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   final imageModel = Provider.of<SelectedImageModel>(context, listen: false);
  //   double _sWidth = MediaQuery.of(context).size.width;
  //   double _sHeight = MediaQuery.of(context).size.height;
  //   return Stack(
  //     children: <Widget>[
  //       Consumer<SelectedImageModel>(
  //         builder: (context, selectedImageModel, child) {
  //           return selectedImageModel.getImageBytes() == null
  //               ? AspectRatio(
  //                   aspectRatio: 16 / 9,
  //                   child: Container(
  //                     color: cBackground,
  //                   ))
  //               : AspectRatio(
  //                   aspectRatio: 16 / 9,
  //                   child: Container(
  //                     color: cBackground,
  //                     height: double.infinity,
  //                     width: double.infinity,
  //                     child: Image.memory(
  //                       selectedImageModel.getImageBytes(),
  //                       fit: selectedImageModel.getCover()
  //                           ? BoxFit.cover
  //                           : BoxFit.contain,
  //                     ),
  //                   ),
  //                 );
  //         },
  //       ),
  //       Positioned(
  //         right: _sWidth * .04,
  //         bottom: _sHeight * .02,
  //         width: _sWidth * .4,
  //         height: _sHeight * .045,
  //         child: Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(20),
  //             color: Color.fromRGBO(0, 0, 0, .6),
  //           ),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: <Widget>[
  //               GestureDetector(
  //                 child: Padding(
  //                   padding: EdgeInsets.fromLTRB(_sWidth * .02, 0, 0, 0),
  //                   child: Icon(
  //                     Icons.crop,
  //                     color: cWhite100,
  //                   ),
  //                 ),
  //                 onTap: () async {
  //                   print(imageModel.getRelativePath());
  //                   File croppedFile = await ImageCropper.cropImage(
  //                     sourcePath: imageModel.getRelativePath(),
  //                     aspectRatioPresets: Platform.isAndroid
  //                         ? [
  //                             CropAspectRatioPreset.square,
  //                             CropAspectRatioPreset.ratio3x2,
  //                             CropAspectRatioPreset.original,
  //                             CropAspectRatioPreset.ratio5x4,
  //                             CropAspectRatioPreset.ratio16x9
  //                           ]
  //                         : [
  //                             CropAspectRatioPreset.original,
  //                             CropAspectRatioPreset.square,
  //                             CropAspectRatioPreset.ratio3x2,
  //                             CropAspectRatioPreset.ratio4x3,
  //                             CropAspectRatioPreset.ratio5x3,
  //                             CropAspectRatioPreset.ratio5x4,
  //                             CropAspectRatioPreset.ratio7x5,
  //                             CropAspectRatioPreset.ratio16x9
  //                           ],
  //                     androidUiSettings: AndroidUiSettings(
  //                         hideBottomControls: false,
  //                         toolbarTitle: 'Cropper',
  //                         toolbarWidgetColor: cWhite100,
  //                         toolbarColor: cCard,
  //                         activeControlsWidgetColor: Colors.blueAccent,
  //                         initAspectRatio: CropAspectRatioPreset.original,
  //                         lockAspectRatio: false),
  //                     iosUiSettings: IOSUiSettings(
  //                       minimumAspectRatio: 1.0,
  //                     ),
  //                   );
  //                   if (croppedFile != null) {
  //                     imageModel.setImageBytes(
  //                         newImageBytes: croppedFile.readAsBytesSync(),
  //                         newRelativePath: croppedFile.path);
  //                   }
  //                 },
  //               ),
  //               VerticalDivider(
  //                 thickness: _sWidth * .005,
  //                 color: cWhite25,
  //               ),
  //               GestureDetector(
  //                 onTap: getImage,
  //                 child: Padding(
  //                   padding: EdgeInsets.fromLTRB(0, 0, _sWidth * .02, 0),
  //                   child: Center(
  //                     child: Text(
  //                       'From Device',
  //                       style: TextStyle(color: cWhite100, fontSize: 16.0),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       Positioned(
  //         left: _sWidth * .04,
  //         bottom: _sHeight * .008,
  //         width: _sWidth * .1,
  //         height: _sHeight * .075,
  //         child: GestureDetector(
  //           child: Container(
  //             decoration: BoxDecoration(
  //                 color: Color.fromRGBO(0, 0, 0, .6), shape: BoxShape.circle),
  //             child: Consumer<SelectedImageModel>(
  //                 builder: (context, selectedImageModel, child) {
  //               return Icon(
  //                 selectedImageModel.getCover()
  //                     ? Icons.photo_size_select_actual
  //                     : Icons.photo_size_select_small,
  //                 color: cWhite100,
  //               );
  //             }),
  //           ),
  //           onTap: () async {
  //             imageModel.setCover(!imageModel.getCover());
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
