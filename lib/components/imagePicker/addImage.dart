import 'dart:io';
import 'dart:typed_data';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/club_event_data.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:communitytabs/data/selectedImageModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
// import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'chosenImage.dart';

class AddImage extends StatefulWidget {
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  // File pickedImage;
  // // final _picker = ImagePicker();
  // List<Widget> _mediaList = [];
  // int currentPage = 0;
  // int lastPage;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _fetchFirstImage();
  //   _fetchNewMedia();
  // }
  //
  // _handleScrollEvent(ScrollNotification scroll) {
  //   if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
  //     if (currentPage != lastPage) {
  //       _fetchNewMedia();
  //     }
  //   }
  // }

  // Future _fetchFirstImage() async {
  //   final imageModel = Provider.of<SelectedImageModel>(context, listen: false);
  //   // var hasPermission = await PhotoManager.requestPermission();
  //   if (hasPermission) {
  //     //Get Albums, onlyAll == true only gets One Album which is the Recent Album by default
  //     List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
  //         onlyAll: true, type: RequestType.image);
  //
  //     // Get photos
  //     List<AssetEntity> photos =
  //     await albums[0].getAssetListRange(start: 0, end: 1);
  //
  //     File tempFile = await photos[0].originFile;
  //     String fPath = tempFile.path;
  //     Uint8List fBytes = tempFile.readAsBytesSync();
  //
  //     imageModel.setImageBytes(newImageBytes: fBytes, newRelativePath: fPath);
  //   } else {
  //     // Open android/ios applicaton's setting to get permission
  //     PhotoManager.openSetting();
  //   }
  //
  // }
  //
  // Future _fetchNewMedia() async {
  //   final imageModel = Provider.of<SelectedImageModel>(context, listen: false);
  //   var hasPermission = await PhotoManager.requestPermission();
  //   if (hasPermission) {
  //     //Get Albums, onlyAll == true only gets One Album which is the Recent Album by default
  //     List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
  //         onlyAll: true, type: RequestType.image);
  //
  //     // Get photos
  //     List<AssetEntity> photos =
  //         await albums[0].getAssetListPaged(currentPage, 60);
  //
  //     List<Widget> temp = [];
  //     for (var photo in photos) {
  //       temp.add(
  //         FutureBuilder(
  //           future: Future.wait([photo.thumbDataWithSize(200, 200), photo.originFile]),
  //           builder: (BuildContext context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.done) {
  //               File tempFile = snapshot.data[1];
  //               String tempFilePath = tempFile.path;
  //
  //               return GestureDetector(
  //                 onTap: () {
  //                   print('I was pressed');
  //                   imageModel.setCover(false);
  //                   imageModel.setImageBytes(newImageBytes: snapshot.data[0], newRelativePath: tempFilePath);
  //                 },
  //                 child: Image.memory(
  //                   snapshot.data[0],
  //                   fit: BoxFit.cover,
  //                 ),
  //               );
  //             }
  //             return Container();
  //           },
  //         ),
  //       );
  //     }
  //
  //     setState(() {
  //       _mediaList.addAll(temp);
  //       currentPage++;
  //     });
  //   } else {
  //     // Open android/ios applicaton's setting to get permission
  //     PhotoManager.openSetting();
  //   }
  // }
  //
  // Future getImage() async {
  //   final imageModel = Provider.of<SelectedImageModel>(context, listen: false);
  //   PickedFile image = await _picker.getImage(source: ImageSource.camera);
  //   if (image != null) {
  //   final bytes = await image.readAsBytes();
  //   imageModel.setImageBytes(newImageBytes: bytes, newRelativePath: image.path);
  //   }
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   ClubEventData clubEventData = Provider.of<ClubEventData>(context);
  //   ExpansionTiles expansionTiles = Provider.of<ExpansionTiles>(context);
  //   return Column(children: <Widget>[
  //     SelectedImage(),
  //     Padding(
  //       padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
  //       child: ListTile(
  //         leading: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             CircleAvatar(
  //               backgroundColor: Colors.redAccent,
  //             ),
  //           ],
  //         ),
  //         title: Text(
  //           clubEventData.getTitle,
  //           textAlign: TextAlign.start,
  //           style: TextStyle(color: cWhite100),
  //         ),
  //         subtitle: RichText(
  //           text: TextSpan(children: [
  //             TextSpan(
  //                 text: clubEventData.getLocation + '\n',
  //                 style: TextStyle(color: cWhite70, fontSize: 10.0)),
  //             TextSpan(
  //                 text: DateFormat('E, MMMM d, y').format(expansionTiles.data[0].getHeaderDateValue()),
  //                 style: TextStyle(color: cWhite70, fontSize: 10.0)),
  //             TextSpan(text: ' - '),
  //             TextSpan(
  //                 text: DateFormat.jm().format(expansionTiles.data[0].getHeaderDateValue()),
  //                 style: TextStyle(color: cWhite70, fontSize: 10.0))
  //           ]),
  //         ),
  //         trailing: Icon(Icons.more_vert, color: cWhite70),
  //       ),
  //     ),
  //     Expanded(
  //       flex: 7,
  //       child: Container(
  //         decoration: BoxDecoration(
  //           border: Border(top: BorderSide(color: Colors.black, width: MediaQuery.of(context).size.height * .0025)),
  //         ),
  //         child: NotificationListener<ScrollNotification>(
  //           onNotification: (ScrollNotification scroll) {
  //             _handleScrollEvent(scroll);
  //             return;
  //           },
  //           child: GridView.builder(
  //             physics: BouncingScrollPhysics(),
  //             scrollDirection: Axis.horizontal,
  //             shrinkWrap: true,
  //             itemCount: _mediaList.length,
  //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 2,
  //               mainAxisSpacing: 2.0,
  //               crossAxisSpacing: MediaQuery.of(context).size.height * .0025,
  //               childAspectRatio: 1.1,
  //             ),
  //             itemBuilder: (BuildContext context, int index) {
  //               return _mediaList[index];
  //             },
  //           ),
  //         ),
  //       ),
  //     ),
  //     Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: <Widget>[
  //         RawMaterialButton(
  //           onPressed: () {},
  //           child: Text('Gallery',
  //               style: TextStyle(color: true ? cWhite100 : cWhite70)),
  //         ),
  //         RawMaterialButton(
  //           child: Text('Camera',
  //               style: TextStyle(color: false ? cWhite100 : cWhite70)),
  //           onPressed: getImage,
  //         ),
  //       ],
  //     ),
  //     SizedBox(
  //       height: MediaQuery.of(context).size.height * .0325,
  //     ),
  //   ]);
  // }
}
