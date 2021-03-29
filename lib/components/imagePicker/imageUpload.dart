import 'package:communitytabs/buttons/nextOrCreateButton.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/selectedImageModel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

class UploadImage extends StatefulWidget {
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  // final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://maristcommunitytabs.appspot.com');
  // StorageUploadTask _uploadTask;
  //
  // void upload() {
  //   final ClubEventData event = Provider.of<ClubEventData>(context, listen: false);
  //   final SelectedImageModel imageData = Provider.of<SelectedImageModel>(context, listen: false);
  //   String filePath = 'events/${event.getImagePath}.jpg';
  //
  //   _uploadTask = _storage.ref().child(filePath).putData(imageData.getImageBytes());
  // }
  @override
  Widget build(BuildContext context) {

    // if(_uploadTask != null) {
    //   return StreamBuilder<StorageTaskEvent>(
    //     stream: _uploadTask.events,
    //     builder: (context, snapshot){
    //       var event = snapshot?.data?.snapshot;
    //
    //       double progressPercent = event != null ? event.bytesTransferred / event.totalByteCount : 0;
    //
    //       return Center(
    //         child: Container(
    //           width: MediaQuery.of(context).size.width * .1,
    //           height: MediaQuery.of(context).size.height * .04,
    //           color: Color.fromRGBO(0, 0, 0, .6),
    //           child: Column(
    //             children: <Widget>[
    //               CircularProgressIndicator(
    //                 valueColor: AlwaysStoppedAnimation<Color>(cWhite100),
    //                 strokeWidth: 3,
    //                 value: progressPercent,
    //               ),
    //               Text('${(progressPercent * 100).toStringAsFixed(2)} %'),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // } else {
    //   return NextOrCreateButton(uploadImageCallback: upload,);
    // }
  }
}
