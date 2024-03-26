import 'dart:async';
import 'dart:typed_data';
import 'package:fox_radar/logic/logic.dart';
import 'package:authentication_repository/authentication_repository.dart';

/*
  ProfileBloc

  This Bloc is meant to handle any updates to the user's profile.
  Such as changing the profile image, or changing the password.
 */
class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final UserModel userModel;
  UpdateProfileBloc(this.userModel)
      : super(UpdateProfileStateReady(oldImageBytes: userModel.imageBytes)) {
    on<UpdateProfileEventSetImage>(_mapProfileEventSetImageToState);
  }

  void _mapProfileEventSetImageToState(
    UpdateProfileEventSetImage event,
    Emitter<UpdateProfileState> emitter,
  ) async {
    Uint8List imageBytes = event.imageBytes;

    final currState = this.state;

    emitter(UpdateProfileStateUpdating());

    await Future.delayed(Duration(seconds: 3));

    // yield UpdateProfileStateSuccess(imageBytes);
    //
    // await Future.delayed(Duration(seconds: 3));

    emitter(
      UpdateProfileStateFailed(
        oldImageBytes: currState.imageBytes,
        newImageBytes: imageBytes,
      ),
    );

    await Future.delayed(Duration(seconds: 3));
  }

  @override
  void onChange(Change<UpdateProfileState> change) {
    super.onChange(change);
  }
}
