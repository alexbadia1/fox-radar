import 'package:authentication_repository/authentication_repository.dart';
import 'package:database_repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:communitytabs/presentation/presentation.dart';

class CreateEventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SlidingUpPanelState _slidingUpPanelState =
        context.watch<SlidingUpPanelCubit>().state;

    // Sliding Up Panel Closed
    // Show a blank container, background isn't white to avoid white flicker when closing the panel
    if (_slidingUpPanelState is SlidingUpPanelClosed) {
      return Container(color: cBackground);
    } // if

    // Sliding Up Panel Open
    // Show a the actual event form
    else if (_slidingUpPanelState is SlidingUpPanelOpen) {
      CreateEventFormAction formAction = CreateEventFormAction.create;
      CreateEventState initialState =
          CreateEventInvalid(EventModel.nullConstructor());

      // User wants to update an existing event.
      //
      // Must change the initial state
      // and form action of the [CreateEventBloc].
      if (_slidingUpPanelState.initialEventModel != null) {
        formAction = CreateEventFormAction.update;
        initialState = CreateEventValid(_slidingUpPanelState.initialEventModel);
      } // if

      return MultiBlocProvider(
        providers: [
          BlocProvider<CreateEventBloc>(
            create: (parentContext) {
              // User is creating a new event
              return CreateEventBloc(
                initialCreateEventState: initialState,
                db: RepositoryProvider.of<DatabaseRepository>(parentContext),
                accountID: RepositoryProvider.of<AuthenticationRepository>(
                        parentContext)
                    .getUserModel()
                    .userID,
              );
            },
          ),
          BlocProvider<CreateEventPageViewCubit>(
              create: (parentContext) => CreateEventPageViewCubit()),
          BlocProvider<DeviceImagesBloc>(
              create: (parentContext) => DeviceImagesBloc()),
        ],
        child: CreateEventBody(createEventFormAction: formAction),
      );
    } // else-if

    else {
      return Container(
          child: Center(
              child: Text(
                  'Sliding Up Panel Cubit did not return a state that is either open or closed!')));
    } // else
  }
}
