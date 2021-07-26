import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:database_repository/database_repository.dart';
import 'package:communitytabs/presentation/presentation.dart';
import 'package:authentication_repository/authentication_repository.dart';

class CreateEventBody extends StatelessWidget {
  @override
  Widget build(BuildContext parentContext) {
    final double height = MediaQuery.of(parentContext).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(24, 24, 24, 1.0),
        body: MultiBlocProvider(
          providers: [
            BlocProvider<CreateEventBloc>(
              create: (parentContext) => CreateEventBloc(
                  db: RepositoryProvider.of<DatabaseRepository>(parentContext),
                  accountID: RepositoryProvider.of<AuthenticationRepository>(parentContext).getUserModel().userID,
              ),
            ),
            BlocProvider<CreateEventPageViewCubit>(
                create: (parentContext) => CreateEventPageViewCubit()),
            BlocProvider<DeviceImagesBloc>(
                create: (parentContext) => DeviceImagesBloc()),
          ],
          child: Container(
            color: Colors.transparent,
            height: MediaQuery.of(parentContext).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(parentContext).size.height * .0725,
                  child: Stack(
                    children: <Widget>[
                      Image(
                          width: double.infinity,
                          height: 100.0,
                          image: ResizeImage(
                            AssetImage("images/tenney.jpg"),
                            width: 500,
                            height: 100,
                          ),
                          fit: BoxFit.fill),
                      Container(
                        decoration:
                            BoxDecoration(gradient: cMaristGradientWashed),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Builder(
                            builder: (BuildContext context) {
                              final createEventState = context
                                  .watch<CreateEventPageViewCubit>()
                                  .state;
                              if (createEventState
                                  is CreateEventPageViewEventPhoto) {
                                return CustomBackButton(
                                    onBack: () => BlocProvider.of<
                                            CreateEventPageViewCubit>(context)
                                        .animateToEventForm());
                              } // if
                              return CustomCloseButton(
                                onClose: () {
                                  // Close keyboard
                                  FocusScope.of(context).unfocus();

                                  // Confirm discarding event...
                                  showModalBottomSheet(
                                    context: parentContext,
                                    builder: (context) => Container(
                                      color: Color.fromRGBO(31, 31, 31, 1.0),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .18,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    'Are you sure you want to discard this event?',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ),
                                          ),

                                          Expanded(
                                            flex: 2,
                                            child: FlatButton(
                                              minWidth: double.infinity,
                                              onPressed: () {
                                                Navigator.of(parentContext).pop();
                                                BlocProvider.of<
                                                            SlidingUpPanelCubit>(
                                                    parentContext)
                                                    .closePanel();
                                              },
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Discard',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),

                                          Expanded(
                                            flex: 2,
                                            child: FlatButton(
                                              minWidth: double.infinity,
                                              onPressed: () {
                                                Navigator.of(parentContext).pop();
                                              },
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Keep Editing',
                                                  style: TextStyle(
                                                      color: Colors.blueAccent),
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Bottom Margin
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          Center(
                            child: Text(
                              'Add Event',
                              style: TextStyle(
                                  color: kHavenLightGray,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          // UploadImage(),
                          Builder(builder: (context) {
                            final createEventState =
                                context.watch<CreateEventPageViewCubit>().state;

                            /// Currently on the Event Photo Page
                            /// Show a "post" button in the top right.
                            if (createEventState
                                is CreateEventPageViewEventPhoto) {
                              return CustomCreateButton(
                                onCreate: () {
                                  // Close keyboard
                                  FocusScope.of(parentContext).unfocus();

                                  // Navigate to the account screen
                                  BlocProvider.of<AppPageViewCubit>(parentContext).jumpToAccountPage();

                                  // Close the sliding up panel, and destroy CreateEventBloc
                                  BlocProvider.of<SlidingUpPanelCubit>(parentContext).closePanel();

                                  // Add an upload event to upload event bloc
                                  BlocProvider.of<UploadEventBloc>(context).add(
                                    UploadEventUpload(
                                      newEventModel:
                                          BlocProvider.of<CreateEventBloc>(
                                                  context)
                                              .state
                                              .eventModel,
                                    ),
                                  );
                                }, // onCreate
                              );
                            } // if

                            /// Currently on the Event Form Page
                            /// Show a "next" button in the top right.
                            return CustomNextButton(
                              onClose: () {
                                FocusScope.of(parentContext).unfocus();
                                if (!BlocProvider.of<CreateEventBloc>(context)
                                    .isValidEndDate()) {
                                  // Show error message for invalid end date
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: SizedBox(
                                        height: height * .06,
                                        child: const Text(
                                          'The event cannot end before the event starts',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  );
                                } // if

                                // Continue to event photo
                                else {
                                  // Dismiss Keyboard
                                  FocusScope.of(context).unfocus();

                                  // Advance Page Index
                                  BlocProvider.of<CreateEventPageViewCubit>(
                                          context)
                                      .animateToEventPhoto();
                                } // else
                              },
                            );
                          }),
                        ],
                      )
                    ],
                  ),
                ),

                // Actual Body of the Create Event Form
                Expanded(
                  child: Builder(
                    builder: (context) {
                      // Logic for controlling the Create Event Page View
                      // is stored in the "CreateEventPageViewBlock"
                      return PageView(
                        controller:
                            BlocProvider.of<CreateEventPageViewCubit>(context)
                                .createEventPageViewController,
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          CreateEventForm(),
                          CreateEventImage(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
