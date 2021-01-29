import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import  'fetch_image_state.dart';
import 'package:flutter/material.dart';
import 'package:database_repository/database_repository.dart';

class FetchImageCubit extends Cubit<FetchImageState> {
  final DatabaseRepository db;
  FetchImageCubit({@required this.db}) : super(FetchImageInitial());

  void fetchImage({@required String path}) async {
    Uint8List _bytes;
    try {
      _bytes = await db.getImageFromStorage(path: path);
      emit(FetchImageSuccess(imageBytes: _bytes));
    }// try
    catch (error) {
      emit(FetchImageFailure());
    }// catch
    return;
  }// fetchImage

  @override
  void onChange(Change<FetchImageState> change) {
    print('Fetch Image Cubit: $change');
    super.onChange(change);
  }// onChange
}// FetchImageCubit
