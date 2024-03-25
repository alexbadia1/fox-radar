import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class UpdateProfileEvent extends Equatable {
  const UpdateProfileEvent();
}

class UpdateProfileEventSetImage extends UpdateProfileEvent {
  final Uint8List imageBytes;
  const UpdateProfileEventSetImage(this.imageBytes);

  @override
  List<Object?> get props => [this.imageBytes];
}

/// Resets the ProfileBloc, readying it for another upload
///
/// Call this after ProfileStateFailed and ProfileStateSuccess
class UpdateProfileEventReset extends UpdateProfileEvent {
  @override
  List<Object?> get props => [];
}