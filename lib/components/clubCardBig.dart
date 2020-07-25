import 'dart:io';
import 'dart:typed_data';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/club_event_data.dart';
import 'package:communitytabs/screens/event.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';

class ClubBigCard extends StatefulWidget {
  final ClubEventData newEvent;
  ClubBigCard({this.newEvent});

  @override
  _ClubBigCardState createState() => _ClubBigCardState();
}

class _ClubBigCardState extends State<ClubBigCard> with AutomaticKeepAliveClientMixin {
  Uint8List globalImageBytes;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    Directory _imageCache = Provider.of<Directory>(context);
    FirebaseStorage _firebaseStorage = Provider.of<FirebaseStorage>(context);
    ClubEventData _myEvent = widget.newEvent;
    String _eventTitle = _myEvent.getTitle ?? '[Event Title]';
    String _eventLocation = _myEvent.getLocation ?? '[Event Location]';
    String _eventStartDate = _myEvent.getStartDate ?? '[Event Start Date]';
    String _eventStartTime = _myEvent.getStartTime ?? '[Event Start Time]';
    bool _eventImageFitCover = _myEvent.getImageFitCover ?? true;
    String pathVariable = widget.newEvent.getTitle +
        widget.newEvent.getHost +
        widget.newEvent.getLocation;
    String filePath = 'events/$pathVariable.jpg';
    final File imageFile = File('${_imageCache.path}/$filePath');
    Widget image;

    /// TODO: Maintain the directory.
    if (imageFile.existsSync()) {
      // Show the cached image
      image = FutureBuilder(
        future: imageFile.readAsBytes(),
        builder: (context, imageBytes) {
          if (imageBytes.hasData) {
            print('Local File was found using the path: ${imageFile.path}');
            print('Local File bytes: ' + imageBytes.data.toString());
            globalImageBytes = imageBytes.data;
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child: Image.memory(
                  imageBytes.data,
                  fit: _eventImageFitCover ? BoxFit.cover : BoxFit.contain,
                ),
              ),
            );
          } else {
            print('Retrieving file from cache');
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: LoadingWidget(),
            );
          }
        },
      );
    } else {
      //Create the file path
      imageFile.createSync(recursive: true);
      // Download the image
      image = FutureBuilder(
        future: _firebaseStorage.ref().child(filePath).getData(4194304),
        builder: (context, dataFromFirebaseStorage) {
          if (dataFromFirebaseStorage.hasData) {
            print('Showing Uint8List recieved: ${dataFromFirebaseStorage.data}');
            // Put image in cache
            print('Putting data in cache at: ${imageFile.path}');
            imageFile.writeAsBytesSync(dataFromFirebaseStorage.data);
            globalImageBytes = dataFromFirebaseStorage.data;
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child: Image.memory(
                  dataFromFirebaseStorage.data,
                  fit: _eventImageFitCover ? BoxFit.cover : BoxFit.contain,
                ),
              ),
            );
          } else {
            print('No data received from firebase yet...');
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: LoadingWidget(),
            );
          }
        },
      );
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                EventDetails(
              myEvent: _myEvent,
              imageBytes: globalImageBytes
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      child: Column(
        children: <Widget>[
          image,
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.redAccent,
                  ),
                ],
              ),
              title: Text(
                _eventTitle,
                textAlign: TextAlign.start,
                style: TextStyle(color: cWhite100),
              ),
              subtitle: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: _eventLocation + '\n',
                      style: TextStyle(color: cWhite70, fontSize: 10.0)),
                  TextSpan(
                      text: _eventStartDate,
                      style: TextStyle(color: cWhite70, fontSize: 10.0)),
                  TextSpan(text: ' - '),
                  TextSpan(
                      text: _eventStartTime,
                      style: TextStyle(color: cWhite70, fontSize: 10.0))
                ]),
              ),
              trailing: Icon(Icons.more_vert, color: cWhite70),
            ),
          ),
        ],
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}

//          FutureBuilder(
//              future: _getLocalImagePath(),
//              builder: (context, localImageFilePathExist) {
//                if (localImageFilePathExist.hasData) {
//                  if (!Directory(localImageFilePathExist.data).existsSync()) {
//                    print('Could Not Find Path: ' + localImageFilePathExist.data);
//                    print('Getting image from Firebase Storage instead...');
//                    return FutureBuilder(
//                      future: _firebaseStorage.ref().child(filePath).getData(4194304),
//                      builder: (context, dataFromFirebaseStorage) {
//                        if (dataFromFirebaseStorage.hasData) {
//                          print('Showing Uint8List recieved: ${dataFromFirebaseStorage.data}');
//
//                          // Put image in cache
//                          print('Putting data in cache at: ${imageFile.path}');
//                          imageFile.writeAsBytesSync(dataFromFirebaseStorage.data);
//                          return AspectRatio(
//                            aspectRatio: 16 / 9,
//                            child: Container(
//                              color: Colors.black,
//                              child: Image.memory(
//                                dataFromFirebaseStorage.data,
//                                fit: _eventImageFitCover
//                                    ? BoxFit.cover
//                                    : BoxFit.contain,
//                              ),
//                            ),
//                          );
//                        } else {
//                          print('No data received from firebase yet...');
//                          return AspectRatio(
//                            aspectRatio: 16 / 9,
//                            child: LoadingWidget(),
//                          );
//                        }
//                      },
//                    );
//                  } else {
//                    // Retrieve the data from the cache
//                    print('Directory found was: ${localImageFilePathExist.data}');
//                    print('Trying to get image from cache...');
//                    return FutureBuilder(
//                      future: _defaultCacheManager.getFileFromCache('${localImageFilePathExist.data}'),
//                      builder: (context, future) {
//                        if (future.hasData) {
//                          print('File was found using the path: ${localImageFilePathExist.data}');
//                          FileInfo fileInfo = future.data as FileInfo;
//                          return AspectRatio(
//                            aspectRatio: 16 / 9,
//                            child: Container(
//                              color: Colors.black,
//                              child: Image.memory(
//                                fileInfo.file.readAsBytesSync(),
//                                fit: _eventImageFitCover
//                                    ? BoxFit.cover
//                                    : BoxFit.contain,
//                              ),
//                            ),
//                          );
//                        } else {
//                          print('File could not be retrieved from cache');
//                          return Center(child: Text(
//                              'Image File path could not be found...'),
//                          );
//                        }
//                      },
//                    );
//                  }
//                }
//                else {
//                  print('Waiting for result from cache');
//                  return AspectRatio(
//                    aspectRatio: 16 / 9,
//                    child: LoadingWidget(),
//                  );
//                }
//              },
//          ),
//          this.widget.imageData == null
//              ? AspectRatio(
//                  aspectRatio: 16 / 9, child: Center(child: LoadingWidget()))
//              : AspectRatio(
//                  aspectRatio: 16 / 9,
//                  child: Container(
//                    color: Colors.black,
//                    child: Image.memory(
//                      this.widget.imageData,
//                      fit: _eventImageFitCover ? BoxFit.cover : BoxFit.contain,
//                    ),
//                  ),
//                ),