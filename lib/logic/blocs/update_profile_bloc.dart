import 'dart:async';
import 'dart:typed_data';
import 'package:communitytabs/logic/logic.dart';
import 'package:authentication_repository/authentication_repository.dart';

/*
  ProfileBloc

  This Bloc is meant to handle any updates to the user's profile.
  Such as changing the profile image, or changing the password.
 */
class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final UserModel userModel;
  UpdateProfileBloc(this.userModel)
      : assert(userModel != null),
        super(UpdateProfileStateReady(oldImageBytes: userModel.imageBytes));

  @override
  Stream<UpdateProfileState> mapEventToState(UpdateProfileEvent event) async* {
    if (event is UpdateProfileEventSetImage) {
      yield* _mapProfileEventSetImageToState(event.imageBytes);
    } // if

    else {
      // Unrecognized event
    } // else
  } // mapEventToState

  Stream<UpdateProfileState> _mapProfileEventSetImageToState(Uint8List imageBytes) async* {
    final currState = this.state;

    yield UpdateProfileStateUpdating();

    await Future.delayed(Duration(seconds: 3));

    // yield UpdateProfileStateSuccess(imageBytes);
    //
    // await Future.delayed(Duration(seconds: 3));

    yield UpdateProfileStateFailed(
      oldImageBytes: currState.imageBytes,
      newImageBytes: imageBytes,
    );

    await Future.delayed(Duration(seconds: 3));
  } // _mapProfileEventSetImageToState

@override
  void onChange(Change<UpdateProfileState> change) {
    print("[Update Profile Bloc] $change");
    super.onChange(change);
  }// onChange
} // ProfileBloc
