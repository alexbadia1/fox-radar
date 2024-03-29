import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fox_radar/presentation/presentation.dart';
import 'package:database_repository/database_repository.dart';

class ImageUploadProgress extends StatelessWidget {
  final EventModel eventModel;
  int bytesTransferred = 0;
  int totalBytes = 0;
  String msg = '';

  ImageUploadProgress({Key? key, required this.eventModel}) : super(key: key);

  /// Name: _bytesTransferred
  ///
  /// Description: Shows upload progress as current MB / total MB
  ///
  /// Returns: _bytesTransferred
  String _bytesTransferred({required int bytesTransferred, required int totalByteCount}) {
    double curr = (bytesTransferred / 1024.0) / 1000; // Current MB sent
    double total = (totalByteCount / 1024.0) / 1000; // Total MB
    return '${curr.toStringAsFixed(2)}/${total.toStringAsFixed(2)}';
  }

  /// Name: _uploadProgress
  ///
  /// Description: Normalizes the upload progress between 0 and 1
  ///
  /// Returns: Upload progress between 0 and 1
  double _uploadProgress({required int bytesTransferred, required int totalByteCount}) {
    print('bytes transfered $bytesTransferred');
    print('total bytes $totalByteCount');
    if (totalByteCount <= 0) {
      return 0.0;
    }
    double rawProgress = (bytesTransferred / totalByteCount);

    if (rawProgress < 0) {
      return 0.0;
    }

    if (rawProgress > 1) {
      return 1.0;
    }

    return rawProgress;
  }

  @override
  Widget build(BuildContext context) {
    final UploadEventState uploadState = context.watch<UploadEventBloc>().state;

    /// Nothing is uploading, don't show anything for upload progress
    if (uploadState is UploadEventStateInitial) {
      return SizedBox(height: 0, width: 0);
    }

    /// Show upload progress with a stream builder
    else if (uploadState is UploadEventStateUploading) {
      // ONly show upload progress for image, otherwise assume event uploaded complete
      if (uploadState.uploadTask == null) {
        BlocProvider.of<UploadEventBloc>(context).add(UploadEventComplete());
        return SizedBox(height: 0, width: 0);
      }
      return StreamBuilder(
        stream: uploadState.uploadTask.snapshotEvents,
        builder: (BuildContext context, AsyncSnapshot<TaskSnapshot> snapshot) {
          // No data, task hasn't started
          if (!snapshot.hasData) {
            this.bytesTransferred = 0;
            this.totalBytes = 0;
            this.msg = 'Uploading...';
          } else {
            // Get bytes transferred and total bytes
            this.bytesTransferred = snapshot.data?.bytesTransferred ?? 0;
            this.totalBytes = snapshot.data?.totalBytes ?? 0;

            if (snapshot.data?.state == null) {
              this.msg = 'App Error';
            } else if (snapshot.data?.state == TaskState.error) {
              this.msg = 'Error';
            } else if (snapshot.data?.state == TaskState.canceled) {
              this.msg = 'Canceled';
            } else if (snapshot.data?.state == TaskState.paused) {
              this.msg = 'Paused';
            } else if (snapshot.data?.state == TaskState.success) {
              this.msg = 'Success';
              BlocProvider.of<UploadEventBloc>(context).add(
                  UploadEventComplete()
              );
            } else {
              // Data is uploading
              //
              // Show progress byte transferred out of total bytes
              this.msg = this._bytesTransferred(
                bytesTransferred: bytesTransferred,
                totalByteCount: totalBytes,
              );
            }
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: CustomListTile(
              leading: this.eventModel.imageBytes != null ? Image.memory(
                this.eventModel.imageBytes as Uint8List,
                fit: this.eventModel.imageFitCover ?? this.eventModel.defaultImageFitCover ? BoxFit.cover : BoxFit.contain,
              ) : ErrorWidget.withDetails(message: "this.eventModel.imageBytes was null"),
              title: LinearProgressIndicator(
                value: _uploadProgress(bytesTransferred: this.bytesTransferred, totalByteCount: this.totalBytes) ?? 0.0,
                backgroundColor: cWhite70,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
              subtitle: Text(
                'Event: ${this.eventModel.title}' ?? 'New Event',
                style: TextStyle(color: cWhite70, fontSize: 12.0),
              ),
              description: Text(
                'Task: ${this.msg}' ?? 'Task: Uploading...',
                style: TextStyle(color: cWhite70, fontSize: 12.0),
              ),
              trailing: Builder(builder: (buttonContext) {
                if (this.msg != 'Success') {
                  // Cancel the upload using the Block Event
                  return IconButton(
                    color: Colors.redAccent,
                    icon: Icon(Icons.cancel),
                    onPressed: () => BlocProvider.of<UploadEventBloc>(context).add(UploadEventCancel()),
                  );
                }
                else {
                  // Allow the user press the check mark to reload
                  // the account events and reset the UploadBloc to initial state.
                  return IconButton(
                      color: cIlearnGreen,
                      icon: Icon(Icons.check),
                      onPressed: () => BlocProvider.of<UploadEventBloc>(context).add(UploadEventReset()));
                }
              }),
            ),
          );
        },
      );
    } else {
      /// Invalid upload state, don't show anything for upload progress
      return SizedBox(
        height: 0,
        width: 0,
      );
    }
  } // build
}
