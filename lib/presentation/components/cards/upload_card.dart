import 'package:flutter/material.dart';
import 'package:communitytabs/presentation/presentation.dart';

// TODO: Add documentation

typedef OnUploadCanceledCallback = void Function();

class UploadProgressCard extends StatelessWidget {
  final double uploadProgress;
  final String msg;
  final OnUploadCanceledCallback onUploadCanceledCallback;
  final bool cancelButtonEnabled;

  const UploadProgressCard(
      {Key key,
      @required this.uploadProgress,
      @required this.msg,
      @required this.onUploadCanceledCallback,
      @required this.cancelButtonEnabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(33, 33, 33, 1.0),
        border: Border(
          top: BorderSide(
            color: Color.fromRGBO(61, 61, 61, 1.0),
          ),
        ),
      ),
      child: Padding(
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
          title: LinearProgressIndicator(
            value: this.uploadProgress ?? 0.0,
            backgroundColor: cWhite70,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
          subtitle: Text(
            this.msg ?? 'Uploading...',
            style: TextStyle(color: cWhite70, fontSize: 10.0),
          ),
          trailing: IconButton(
            color: cWhite70,
            icon: Icon(Icons.cancel),
            onPressed:
                this.cancelButtonEnabled ? this.onUploadCanceledCallback : null,
          ),
        ),
      ),
    );
  }
}
