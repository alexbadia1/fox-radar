import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedImage extends StatefulWidget {
  @override
  _SelectedImageState createState() => _SelectedImageState();
}

class _SelectedImageState extends State<SelectedImage> {
  ImagePicker picker;

  @override
  void initState() {
    super.initState();
    picker = ImagePicker();
  } // initState

  Future getImageFromDeviceGallery() async {
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      BlocProvider.of<CreateEventBloc>(context)
          .add(CreateEventSetImage(imageBytes: bytes));
    } // if
  } // getImageFromDeviceGallery

  @override
  Widget build(BuildContext context) {
    double _sWidth = MediaQuery.of(context).size.width;
    double _sHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        BlocBuilder<CreateEventBloc, CreateEventState>(
          builder: (context, CreateEventState state) {
            final imageBytes = state.eventModel.getImageBytes;
            if (imageBytes != null) {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: cBackground,
                  height: double.infinity,
                  width: double.infinity,
                  child: Image.memory(
                    imageBytes,
                    fit: state.eventModel.getImageFitCover
                        ? BoxFit.cover
                        : BoxFit.contain,
                  ),
                ),
              );
            } // if

            else {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: cBackground,
                ),
              );
            } //else
          },
          buildWhen: (CreateEventState prevState, CreateEventState currState) {
            if (prevState.eventModel.getImageFitCover !=
                    currState.eventModel.getImageFitCover ||
                prevState.eventModel.getImageBytes !=
                    currState.eventModel.getImageBytes ||
                prevState.eventModel.getImagePath !=
                    currState.eventModel.getImagePath) {
              return true;
            } // if
            return false;
          },
        ),
        Positioned(
          right: _sWidth * .04,
          bottom: _sHeight * .02,
          width: _sWidth * .4,
          height: _sHeight * .045,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromRGBO(0, 0, 0, .6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(_sWidth * .02, 0, 0, 0),
                    child: Icon(
                      Icons.crop,
                      color: cWhite100,
                    ),
                  ),
                  onTap: () async {
                    File croppedFile = await ImageCropper.cropImage(
                      sourcePath: BlocProvider.of<CreateEventBloc>(context)
                          .state
                          .eventModel
                          .getImagePath,
                      aspectRatioPresets: Platform.isAndroid
                          ? [
                              CropAspectRatioPreset.square,
                              CropAspectRatioPreset.ratio3x2,
                              CropAspectRatioPreset.original,
                              CropAspectRatioPreset.ratio5x4,
                              CropAspectRatioPreset.ratio16x9
                            ]
                          : [
                              CropAspectRatioPreset.original,
                              CropAspectRatioPreset.square,
                              CropAspectRatioPreset.ratio3x2,
                              CropAspectRatioPreset.ratio4x3,
                              CropAspectRatioPreset.ratio5x3,
                              CropAspectRatioPreset.ratio5x4,
                              CropAspectRatioPreset.ratio7x5,
                              CropAspectRatioPreset.ratio16x9
                            ],
                      androidUiSettings: AndroidUiSettings(
                          hideBottomControls: false,
                          toolbarTitle: 'Cropper',
                          toolbarWidgetColor: cWhite100,
                          toolbarColor: cCard,
                          activeControlsWidgetColor: Colors.blueAccent,
                          initAspectRatio: CropAspectRatioPreset.original,
                          lockAspectRatio: false),
                      iosUiSettings: IOSUiSettings(
                        minimumAspectRatio: 1.0,
                      ),
                    );
                    if (croppedFile != null) {
                      BlocProvider.of<CreateEventBloc>(context).add(
                          CreateEventSetImage(
                              imageBytes: croppedFile?.readAsBytesSync()));
                    } // if
                  },
                ),
                VerticalDivider(
                  thickness: _sWidth * .005,
                  color: cWhite25,
                ),
                GestureDetector(
                  onTap: () => getImageFromDeviceGallery(),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, _sWidth * .02, 0),
                    child: Center(
                      child: Text(
                        'From Device',
                        style: TextStyle(color: cWhite100, fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: _sWidth * .04,
          bottom: _sHeight * .008,
          width: _sWidth * .1,
          height: _sHeight * .075,
          child: BlocBuilder<CreateEventBloc, CreateEventState>(
            builder: (context, state) {

              // Image will cover the entire card
              if (state.eventModel.getImageFitCover) {
                return GestureDetector(
                  onTap: () {
                    BlocProvider.of<CreateEventBloc>(context)
                        .add(CreateEventSetImageFitCover(fitCover: false));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, .6),
                          shape: BoxShape.circle),
                      child: Icon(Icons.photo_size_select_actual,
                          color: cWhite100)),
                );
              } // if

              // Image will shrink to fit entirely in the card
              else {
                return GestureDetector(
                    onTap: () {
                      BlocProvider.of<CreateEventBloc>(context)
                          .add(CreateEventSetImageFitCover(fitCover: true));
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, .6),
                            shape: BoxShape.circle),
                        child: Icon(Icons.photo_size_select_small,
                            color: cWhite100)));
              }
            },
            buildWhen: (CreateEventState prevState, CreateEventState currState) {
              return prevState.eventModel.getImageFitCover != currState.eventModel.getImageFitCover;
            },
          ),
        ),
      ],
    );
  }
}
