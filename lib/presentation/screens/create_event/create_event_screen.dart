import 'package:flutter/material.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:database_repository/database_repository.dart';
import 'package:fox_radar/presentation/presentation.dart';

/*
  CreateEventScreen

  Implemented by a modalBottomSheet, the CreateEventScreen decides whether
  the form is being used to update an existing event or create a new event.
 */
class CreateEventScreen extends StatelessWidget {
  /// Fills the form with the event model's data,
  /// and assumes the user wants to update an event.
  ///
  /// Leave null, if the user is creating a new event.
  final EventModel? initialEventModel;

  const CreateEventScreen({Key? key, this.initialEventModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CreateEventFormAction formAction = CreateEventFormAction.create;
    CreateEventState initialState = CreateEventInvalid(EventModel.nullConstructor());

    /// User wants to UPDATE an event.
    ///
    /// Give the [CreateEventBloc] the initial event model and set
    /// the form action [formAction] to CreateEventFormAction.update.
    if (this.initialEventModel != null) {
      formAction = CreateEventFormAction.update;
      initialState = CreateEventValid(this.initialEventModel!);
    }

    /// User wants to CREATE an event.
    ///
    /// Give the [CreateEventBloc] a blank event model and set
    /// the form action [formAction] to CreateEventFormAction.create.
    return MultiBlocProvider(
      providers: [
        BlocProvider<DeviceImagesBloc>(create: (parentContext) => DeviceImagesBloc()),
        BlocProvider<CreateEventPageViewCubit>(create: (parentContext) => CreateEventPageViewCubit()),
        BlocProvider<CreateEventBloc>(
          create: (parentContext) {
            return CreateEventBloc(
              initialCreateEventState: initialState,
              db: RepositoryProvider.of<DatabaseRepository>(parentContext),
            );
          },
        ),
      ],
      child: CreateEventBody(createEventFormAction: formAction),
    );
  }
}
