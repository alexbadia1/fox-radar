import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:communitytabs/presentation/presentation.dart';
import 'package:photo_manager/photo_manager.dart';

class CreateEventImage extends StatefulWidget {
  @override
  _CreateEventImageState createState() => _CreateEventImageState();
} // CreateEventImage

class _CreateEventImageState extends State<CreateEventImage>
    with WidgetsBindingObserver {
  File pickedImage;
  ImagePicker picker;
  AppLifecycleState prevAppState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pickedImage = null;
    picker = ImagePicker();

    BlocProvider.of<DeviceImagesBloc>(context).add(DeviceImagesEventFetch());
  } // initState

  @override
  Widget build(BuildContext createEventImageContext) {
    final screenHeight = MediaQuery.of(createEventImageContext).size.height;
    final screenWidth = MediaQuery.of(createEventImageContext).size.width;
    final screenPaddingBottom =
        MediaQuery.of(createEventImageContext).padding.bottom;
    final screenInsetsBottom =
        MediaQuery.of(createEventImageContext).viewInsets.bottom;
    final screenPaddingTop = MediaQuery.of(createEventImageContext).padding.top;

    final _realHeight = screenHeight -
        screenPaddingTop -
        screenPaddingBottom +
        screenInsetsBottom;

    return Column(children: <Widget>[
      SelectedImage(),
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
            BlocProvider.of<CreateEventBloc>(context)
                    .state
                    ?.eventModel
                    ?.title ??
                '[Event Title]',
            textAlign: TextAlign.start,
            style: TextStyle(color: cWhite100),
          ),
          subtitle: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: BlocProvider.of<CreateEventBloc>(context)
                          .state
                          ?.eventModel
                          ?.location ??
                      '[Location]',
                  style: TextStyle(color: cWhite70, fontSize: 10.0)),
              TextSpan(
                  text: DateFormat('E, MMMM d, y')?.format(
                          BlocProvider.of<CreateEventBloc>(context)
                              .state
                              ?.eventModel
                              ?.rawStartDateAndTime) ??
                      '[Start Date]',
                  style: TextStyle(color: cWhite70, fontSize: 10.0)),
              TextSpan(text: ' - '),
              TextSpan(
                  text: DateFormat.jm()?.format(
                          BlocProvider.of<CreateEventBloc>(context)
                              .state
                              ?.eventModel
                              ?.rawStartDateAndTime) ??
                      "[Start Time]",
                  style: TextStyle(color: cWhite70, fontSize: 10.0))
            ]),
          ),
          trailing: Icon(Icons.more_vert, color: cWhite70),
        ),
      ),
      Expanded(
        flex: 11,

        /// Container added for a black bottom border
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black,
                width: MediaQuery.of(context).size.height * .0025,
              ),
            ),
          ),

          /// Name: NotificationListener
          ///
          /// Description: Automatically retrieves device images when
          ///              nearing the end of the list, using pagination.
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scroll) {
              final state =
                  BlocProvider.of<DeviceImagesBloc>(createEventImageContext)
                      .state;
              if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent >
                  0.33) {
                // Only try to retrieve more images, iff
                // images were already successfully retrieved.
                if (state is DeviceImagesStateSuccess) {
                  if (!state.maxImages) {
                    BlocProvider.of<DeviceImagesBloc>(createEventImageContext)
                        .add(DeviceImagesEventFetch());
                  } // if
                } // if
              } // if
              return;
            },
            child: Builder(builder: (deviceImageContext) {
              final deviceImagesBlocState =
                  deviceImageContext.watch<DeviceImagesBloc>().state;

              /// Access to the devices photos was denied prompt
              /// the user to open settings to give permission.
              if (deviceImagesBlocState is DeviceImagesStateDenied) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Access to Device\'s Photos Denied!',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: cWhite70,
                        ),
                      ),
                      cVerticalMarginSmall(createEventImageContext),
                      GestureDetector(
                        onTap: () {
                          PhotoManager.openSetting();
                        },
                        child: Text(
                          'OPEN SETTINGS',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } // if

              else if (deviceImagesBlocState is DeviceImagesStateFailed) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Failed to Retrieve Device Images!',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: cWhite70,
                        ),
                      ),
                      cVerticalMarginSmall(createEventImageContext),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<DeviceImagesBloc>(context)
                              .add(DeviceImagesEventFetch());
                        },
                        child: Text(
                          'RETRY',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } // if

              else if (deviceImagesBlocState is DeviceImagesStateFetching) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: _realHeight * .03,
                        width: screenWidth * .05,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(cWhite70),
                          strokeWidth: 2.25,
                        ),
                      ),
                      cVerticalMarginSmall(context),
                      Text(
                        'Fetching Device Images...',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: cWhite70,
                        ),
                      ),
                    ],
                  ),
                );
              } // if

              else if (deviceImagesBlocState is DeviceImagesStateSuccess) {
                return Container(
                  alignment: Alignment.topLeft,
                  child: GridView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: deviceImagesBlocState.images.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2.0,
                        crossAxisSpacing:
                            MediaQuery.of(context).size.height * .0025,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (BuildContext gridListContext, int index) {
                        final Uint8List _imageBytes = deviceImagesBlocState
                            .images[index]
                            .readAsBytesSync();
                        return GestureDetector(
                          onTap: () {
                            BlocProvider.of<CreateEventBloc>(gridListContext)
                                .add(CreateEventSetImage(
                                    imageBytes: _imageBytes));
                            BlocProvider.of<CreateEventBloc>(context).add(
                                CreateEventSetImageFitCover(fitCover: false));
                            BlocProvider.of<CreateEventBloc>(gridListContext)
                                .add(CreateEventSetImagePath(
                                    imagePath: deviceImagesBlocState
                                        .images[index].path));
                          },
                          child: Image.memory(
                            _imageBytes,
                            fit: BoxFit.cover,
                          ),
                        );
                      }),
                );
              } // else-if

              else {
                return Text("Hmm.. something went wrong");
              } // else
            }),
          ),
        ),
      ),
      Expanded(
        flex: 2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: BorderTop(
                child: RawMaterialButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Text('Gallery', style: TextStyle(color: cWhite100)),
                ),
              ),
            ),
            BorderLeft(child: SizedBox()),
            Expanded(
              child: BorderTop(
                child: RawMaterialButton(
                  child: Text('Camera', style: TextStyle(color: cWhite70)),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    try {
                      PickedFile image = await this
                          .picker
                          .getImage(source: ImageSource.camera);
                      if (image != null) {
                        final bytes = await image.readAsBytes();
                        BlocProvider.of<CreateEventBloc>(context)
                            .add(CreateEventSetImage(imageBytes: bytes));
                        BlocProvider.of<CreateEventBloc>(context).add(
                            CreateEventSetImagePath(imagePath: image.path));
                        BlocProvider.of<CreateEventBloc>(context)
                            .add(CreateEventSetImageFitCover(fitCover: false));
                      } // if
                    } // try

                    /// Error opening the camera
                    catch (platformException) {
                      PlatformException e =
                          platformException as PlatformException;

                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('Error Accessing Camera'),
                          content: Text(e.message ?? ''),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK',
                                  style: TextStyle(color: Colors.blueAccent)),
                            ),
                          ],
                        ),
                      );
                    } // catch
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * .0325,
      ),
    ]);
  } // build

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When app is resumed, try to fetch images from the device
    if (prevAppState != null) {
      if (prevAppState == AppLifecycleState.paused) {
        if (state == AppLifecycleState.resumed) {
          BlocProvider.of<DeviceImagesBloc>(context)
              .add(DeviceImagesEventFetch());
        }// if
      } // if
    } // if

    // Record previous App State
    prevAppState = state;

    super.didChangeAppLifecycleState(state);
  } // didChangeAppLifecycleState

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  } // dispose
} // _CreateEventImageState
