import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:communitytabs/presentation/presentation.dart';

class CreateEventImage extends StatefulWidget {
  @override
  _CreateEventImageState createState() => _CreateEventImageState();
} // CreateEventImage

class _CreateEventImageState extends State<CreateEventImage> {
  File pickedImage;
  ImagePicker picker;

  @override
  void initState() {
    super.initState();
    pickedImage = null;
    picker = ImagePicker();

    BlocProvider.of<DeviceImagesBloc>(context).add(DeviceImagesEventFetch());
  } // initState

  @override
  Widget build(BuildContext context) {
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
                    ?.getTitle ??
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
                          ?.getLocation ??
                      '[Location]',
                  style: TextStyle(color: cWhite70, fontSize: 10.0)),
              TextSpan(
                  text: DateFormat('E, MMMM d, y')?.format(
                          BlocProvider.of<CreateEventBloc>(context)
                              .state
                              ?.eventModel
                              ?.getRawStartDateAndTime) ??
                      '[Start Date]',
                  style: TextStyle(color: cWhite70, fontSize: 10.0)),
              TextSpan(text: ' - '),
              TextSpan(
                  text: DateFormat.jm()?.format(
                          BlocProvider.of<CreateEventBloc>(context)
                              .state
                              ?.eventModel
                              ?.getRawStartDateAndTime) ??
                      "[Start Time]",
                  style: TextStyle(color: cWhite70, fontSize: 10.0))
            ]),
          ),
          trailing: Icon(Icons.more_vert, color: cWhite70),
        ),
      ),
      Expanded(
        flex: 7,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Colors.black,
                    width: MediaQuery.of(context).size.height * .0025)),
          ),
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scroll) {
              final state = BlocProvider.of<DeviceImagesBloc>(context).state;
              if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent >
                  0.33) {
                if (state is DeviceImagesStateSuccess) {
                  if (!state.maxImages) {
                    BlocProvider.of<DeviceImagesBloc>(context)
                        .add(DeviceImagesEventFetch());
                  } // if
                } // if
              } // if
              return;
            },
            child: Builder(builder: (context) {
              final deviceImagesBlocState =
                  context.watch<DeviceImagesBloc>().state;

              if (deviceImagesBlocState is DeviceImagesStateFailed) {
                return Text("Hmm.. no images");
              } // if

              else if (deviceImagesBlocState is DeviceImagesStateFetching) {
                return Text("Fetching Images");
              } // if

              else if (deviceImagesBlocState is DeviceImagesStateSuccess) {
                return GridView.builder(
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
                    itemBuilder: (BuildContext context, int index) {
                      final Uint8List _imageBytes =
                          deviceImagesBlocState.images[index].readAsBytesSync();
                      return GestureDetector(
                        onTap: () {
                          BlocProvider.of<CreateEventBloc>(context).add(
                              CreateEventSetImage(imageBytes: _imageBytes));
                          BlocProvider.of<CreateEventBloc>(context).add(
                              CreateEventSetImageFitCover(fitCover: false));
                          BlocProvider.of<CreateEventBloc>(context).add(
                              CreateEventSetImagePath(
                                  imagePath: deviceImagesBlocState
                                      .images[index].path));
                        },
                        child: Image.memory(
                          _imageBytes,
                          fit: BoxFit.cover,
                        ),
                      );
                    });
              } // else-if

              else {
                return Text("Hmm.. something went wrong");
              } // else
            }),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
            },
            child: Text('Gallery', style: TextStyle(color: cWhite100)),
          ),
          RawMaterialButton(
            child: Text('Camera', style: TextStyle(color: cWhite70)),
            onPressed: () async {
              FocusScope.of(context).unfocus();
              PickedFile image =
                  await picker.getImage(source: ImageSource.camera);
              if (image != null) {
                final bytes = await image.readAsBytes();
                BlocProvider.of<CreateEventBloc>(context)
                    .add(CreateEventSetImage(imageBytes: bytes));
                BlocProvider.of<CreateEventBloc>(context)
                    .add(CreateEventSetImagePath(imagePath: image.path));
                BlocProvider.of<CreateEventBloc>(context)
                    .add(CreateEventSetImageFitCover(fitCover: false));
              } // if
            },
          ),
        ],
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * .0325,
      ),
    ]);
  } // build
} // _CreateEventImageState
