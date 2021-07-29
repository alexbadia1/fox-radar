import 'package:flutter/material.dart';
import 'package:database_repository/database_repository.dart';
import 'package:communitytabs/presentation/presentation.dart';

// TODO: Add documentation

typedef OnUploadCanceledCallback = void Function();
typedef OnUploadSuccessCallback = void Function();

class UploadProgressCardDescription extends StatelessWidget {
  final double uploadProgress;
  final String eventTitle;
  final String uploadMessage;

  const UploadProgressCardDescription({
    Key key,
    @required this.uploadProgress,
    @required this.eventTitle,
    @required this.uploadMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          LinearProgressIndicator(
            value: this.uploadProgress ?? 0.0,
            backgroundColor: cWhite70,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
          SizedBox(height: 10.0),
          Text(
            'Event: ${this.eventTitle}' ?? 'New Event',
            style: TextStyle(color: cWhite70, fontSize: 12.0),
          ),
          SizedBox(height: 5.0),
          Text(
            'Task: ${this.uploadMessage}' ?? 'Task: Uploading...',
            style: TextStyle(color: cWhite70, fontSize: 12.0),
          ),
        ],
      ),
    );
  }
} // UploadProgressCardDescription

class UploadProgressCard extends StatelessWidget {
  final EventModel eventModel;
  final double uploadProgress;
  final String msg;
  final bool cancelButtonEnabled;
  final OnUploadCanceledCallback onUploadCanceledCallback;
  final OnUploadSuccessCallback onUploadSuccessCallback;

  const UploadProgressCard(
      {Key key,
      @required this.uploadProgress,
      @required this.msg,
      @required this.onUploadCanceledCallback,
      @required this.cancelButtonEnabled,
      @required this.onUploadSuccessCallback,
      @required this.eventModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenPaddingBottom = MediaQuery.of(context).padding.bottom;
    final screenInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    final screenPaddingTop = MediaQuery.of(context).padding.top;

    final _realHeight = screenHeight -
        screenPaddingTop -
        screenPaddingBottom +
        screenInsetsBottom;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: BorderTopBottom(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: double.infinity,
            minHeight: _realHeight * .12,
              maxHeight: _realHeight * .15
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Image.memory(
                    this.eventModel.imageBytes,
                    fit: this.eventModel.imageFitCover
                        ? BoxFit.cover
                        : BoxFit.contain),
              ),
              Expanded(
                flex: 9,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UploadProgressCardDescription(
                      eventTitle: this.eventModel.title,
                      uploadProgress: this.uploadProgress,
                      uploadMessage: this.msg,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Builder(builder: (buttonContext) {
                      if (this.cancelButtonEnabled) {
                        return IconButton(
                            color: Colors.redAccent,
                            icon: Icon(Icons.cancel),
                            onPressed: this.onUploadCanceledCallback);
                      } // if
                      else {
                        return IconButton(
                            color: cIlearnGreen,
                            icon: Icon(Icons.check),
                            onPressed: this.onUploadSuccessCallback);
                      } // else
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }// build
}// UploadProgressCard
