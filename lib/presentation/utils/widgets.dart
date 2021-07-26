import 'package:flutter/material.dart';
import 'package:loading_fixed/loading.dart';
import 'package:loading_fixed/indicators/indicators.dart';
import 'package:communitytabs/presentation/presentation.dart';

class LoadingWidget extends StatelessWidget {
  final double size;
  final Color color;
  LoadingWidget({this.size, this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .65,
      child: Center(
        child: FixedLoadingWidget(
          indicator: BallSpinFadeLoaderIndicator(),
          size: size ?? 55.0,
          color: color ?? Color.fromRGBO(255, 255, 255, .50),
        ),
      ),
    );
  } // build
} // LoadingWidget

typedef OnWaitForUploadCallback = Function(void);
typedef OnCancelUploadCallback = Function(void);

class UploadSnackBar extends StatelessWidget {
  final OnCancelUploadCallback onCancelUploadCallback;

  const UploadSnackBar(
      {Key key,
      @required this.onCancelUploadCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .30,
      color: Color.fromRGBO(24, 24, 24, 1.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: const Text(
                'An event is already currently being upload. Please wait for, or cancel, that event!',
                style: TextStyle(fontSize: 16.0, color: cWhite70),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        child: Text(
                          'CANCEL CURRENT UPLOAD',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.redAccent,
                          ),
                        ),
                        onPressed: () {
                          this.onCancelUploadCallback(0);
                          Navigator.pop(context);
                        }// onCancel
                      ),
                      TextButton(
                        child: Text(
                          'I CAN WAIT',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueAccent,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
