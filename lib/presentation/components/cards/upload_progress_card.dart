import 'package:flutter/material.dart';
import 'package:database_repository/database_repository.dart';
import 'package:communitytabs/presentation/presentation.dart';

typedef OnUploadCanceledCallback = void Function();
typedef OnUploadSuccessCallback = void Function();

class UploadProgressCardDescription extends StatelessWidget {
  /// A double between 0 and 1, showing upload progress of the events image
  final double uploadProgress;

  /// Title of the event being uploaded
  /// Shown right beneath the upload progress indicator
  final String eventTitle;

  /// Text revealing data about the current state of the
  /// upload progress. Appears directly beneath the event title.
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
  /// Text shown to the user, try to tell
  /// them something useful about the upload.
  final String msg;

  /// The Event being uploaded.
  ///
  /// Useful for showing the user that
  /// the correct event is being uploaded.
  final EventModel eventModel;

  /// A double between 0 and 1, showing upload progress of the events image
  final double uploadProgress;

  /// Whether or not to add a cancel button should be enabled.
  ///
  /// In some cases, you may want to disable the cancel,
  /// event button as in, for instance, the event completed.
  final bool cancelButtonEnabled;

  /// Function called when the canceled icon button is pressed.
  final OnUploadCanceledCallback onUploadCanceledCallback;

  /// Function called when the check mark icon button is pressed.
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
    final _realHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom +
        MediaQuery.of(context).viewInsets.bottom;

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
