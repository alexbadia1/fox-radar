import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class UpdateProfileState extends Equatable {
  final Uint8List imageBytes;
  const UpdateProfileState(this.imageBytes);
} // ProfileState

/// Profile bloc is ready
class UpdateProfileStateReady extends UpdateProfileState {
  final Uint8List oldImageBytes;
  UpdateProfileStateReady({@required this.oldImageBytes}) : super(oldImageBytes);

  @override
  List<Object> get props => [];
} // ProfileStateReady

/// Make sure the UI shows a loading widget in
/// place of the CircleAvatar as the image uploads.
///
/// Also, maybe disable the close button?
///
/// Also tell the user if an image is already being uploaded.
class UpdateProfileStateUpdating extends UpdateProfileState {
  UpdateProfileStateUpdating() : super(null);

  @override
  List<Object> get props => [];
} // ProfileStateUpdating

/// Show a snackbar saying the upload failed.
///
/// Let the user "try again" via the snack bar.
///
/// On snackbar dismissal, return back to ProfileStateReady
class UpdateProfileStateFailed extends UpdateProfileState {
  final Uint8List oldImageBytes;
  final Uint8List newImageBytes;
  UpdateProfileStateFailed({@required this.oldImageBytes, @required this.newImageBytes}) : super(oldImageBytes);

  @override
  List<Object> get props => [this.imageBytes];
} // ProfileStateFailed

/// Show a snackbar saying the upload succeeded.
///
/// On snackbar dismissal, return back to ProfileStateReady
class UpdateProfileStateSuccess extends UpdateProfileState {
  final Uint8List imageBytes;
  UpdateProfileStateSuccess(this.imageBytes) : super(imageBytes);

  @override
  List<Object> get props => [this.imageBytes];
} // ProfileStateSuccess
