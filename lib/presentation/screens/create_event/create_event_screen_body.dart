import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:database_repository/database_repository.dart';
import 'package:communitytabs/presentation/presentation.dart';

class CreateEventBody extends StatelessWidget {
  final EventModel eventModelToUpdate;
  final CreateEventFormAction createEventFormAction;

  const CreateEventBody({Key key, @required this.createEventFormAction, this.eventModelToUpdate})
      : assert(createEventFormAction != null),
        super(key: key);

  @override
  Widget build(BuildContext parentContext) {
    final double height = MediaQuery.of(parentContext).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(24, 24, 24, 1.0),
        body: Container(
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
                      decoration: BoxDecoration(gradient: cMaristGradientWashed),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Builder(
                          builder: (BuildContext context) {
                            final createEventState = context.watch<CreateEventPageViewCubit>().state;
                            if (createEventState is CreateEventPageViewEventPhoto) {
                              return CustomBackButton(
                                  onBack: () => BlocProvider.of<CreateEventPageViewCubit>(context).animateToEventForm(),
                              );
                            } // if
                            return CustomCloseButton(
                              onClose: () {
                                // Close keyboard
                                FocusScope.of(context).unfocus();

                                // Confirm discarding event...
                                showModalBottomSheet(
                                  context: parentContext,
                                  builder: (modalContext) {
                                    return ModalConfirmation(
                                      prompt: "Are you sure you want to discard this event?",
                                      confirmText: "DISCARD",
                                      confirmColor: Colors.redAccent,
                                      onConfirm: () {
                                        BlocProvider.of<SlidingUpPanelCubit>(parentContext).closePanel();
                                        Navigator.of(modalContext).pop();
                                      },
                                      cancelText: "KEEP EDITING",
                                      cancelColor: Colors.blueAccent,
                                      onCancel: () {
                                        Navigator.of(modalContext).pop();
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                        Center(
                          child: Text(
                            'Add Event',
                            style: TextStyle(color: kHavenLightGray, fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        // UploadImage(),
                        Builder(builder: (context) {
                          final createEventState = context.watch<CreateEventPageViewCubit>().state;

                          /// Currently on the Event Photo Page
                          /// Show a "post" button in the top right.
                          if (createEventState is CreateEventPageViewEventPhoto) {
                            return CreateEventFormSubmitButton(
                              text: this.createEventFormAction == CreateEventFormAction.create ? "POST" : "UPDATE",
                              onSubmit: () {
                                // Close keyboard
                                FocusScope.of(parentContext).unfocus();

                                // Only upload event if there's an event not already being uploaded
                                if (BlocProvider.of<UploadEventBloc>(context).state is UploadEventStateUploading) {
                                  return showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: Text('Cannot Upload Event'),
                                      content: Text(
                                          'An event is already currently being upload. Please wait for that event to finish uploading before creating a new event.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text(
                                            'OK',
                                            style: TextStyle(color: Colors.blueAccent),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } // if

                                // No event is uploading
                                else {
                                  // Reset the upload event bloc
                                  BlocProvider.of<UploadEventBloc>(context).add(UploadEventReset());

                                  // Navigate to the account screen
                                  BlocProvider.of<AppPageViewCubit>(parentContext).jumpToAccountPage();

                                  // Close the sliding up panel, and destroy CreateEventBloc
                                  BlocProvider.of<SlidingUpPanelCubit>(parentContext).closePanel();

                                  // Add an upload event to upload event bloc
                                  BlocProvider.of<UploadEventBloc>(context).add(
                                    UploadEventUpload(
                                      createEventFormAction: this.createEventFormAction,
                                      newEventModel: BlocProvider.of<CreateEventBloc>(context).state.eventModel,
                                    ),
                                  );
                                } // else
                              }, // onCreate
                            );
                          } // if

                          /// Currently on the Event Form Page
                          /// Show a "next" button in the top right.
                          return CustomNextButton(
                            onClose: () {
                              FocusScope.of(parentContext).unfocus();
                              if (!BlocProvider.of<CreateEventBloc>(context).isValidEndDate()) {
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
                                BlocProvider.of<CreateEventPageViewCubit>(context).animateToEventPhoto();
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
                      controller: BlocProvider.of<CreateEventPageViewCubit>(context).createEventPageViewController,
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
    );
  }
}
