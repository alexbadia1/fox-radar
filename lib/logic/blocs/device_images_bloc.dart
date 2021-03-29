import 'dart:io';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/logic/logic.dart';
import 'device_images_event.dart';
import 'device_images_state.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';

class DeviceImagesBloc extends Bloc<DeviceImagesEvent, DeviceImagesState> {
  final int paginationLimit = 10;
  DeviceImagesBloc() : super(DeviceImagesStateFetching());

  @override
  Stream<DeviceImagesState> mapEventToState(DeviceImagesEvent event) async* {
    if (event is DeviceImagesEventFetch) {
      yield* _mapDeviceImagesEventFetchToDeviceImagesState();
    }// if

    else {
      // error
    }
  }// mapEventToState

  Stream<DeviceImagesState> _mapDeviceImagesEventFetchToDeviceImagesState() async* {
    // Get the current state for later use...
    final _currentState = this.state;
    bool _maxImages = false;

    try {
      final bool hasPermission = await PhotoManager.requestPermission();

      print(hasPermission);

      if (hasPermission) {

        // No posts were fetched yet...
        if (_currentState is DeviceImagesStateFetching) {
          // Set "onlyAll == true": to only get ONE Album (Recent Album by default)
          final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: true, type: RequestType.image);

          // Get photos
          final List<AssetEntity> photos = await albums[0]?.getAssetListPaged(0, this.paginationLimit);

          // Map photos to file data type
          List<File> tempFiles = await _mapPhotosToFiles(photos: photos);

          if (tempFiles.length != this.paginationLimit) {
            _maxImages = true;
          } // if

          yield DeviceImagesStateSuccess(
              images: tempFiles,
              lastPage: 0,
              maxImages: _maxImages,
              isFetching: false);
        }// if

        // Some images were already fetched from storage, get more
        else if (_currentState is DeviceImagesStateSuccess) {
          // Set "onlyAll == true": to only get ONE Album (Recent Album by default)
          final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: true, type: RequestType.image);

          // Get photos
          final List<AssetEntity> photos = await albums[0]?.getAssetListPaged(_currentState.lastPage + 1, paginationLimit);

          // Map photos to file data type
          List<File> tempFiles = await _mapPhotosToFiles(photos: photos);

          // No images were retrieved
          if (tempFiles.isEmpty) {
            yield DeviceImagesStateSuccess(
                images: _currentState.images,
                lastPage: _currentState.lastPage,
                maxImages: true,
                isFetching: false);
          }// if

          else {
            if (tempFiles.length != this.paginationLimit) {
              _maxImages = true;
            } // if

            yield DeviceImagesStateSuccess(
              images: _currentState.images + tempFiles,
              maxImages: _maxImages,
              lastPage: _currentState.lastPage + 1,
              isFetching: false,
            );
          }// else
        }// else-if

      }// if

      else {
        // Open android/ios applicaton's setting to get permission
        // App crashes in background though
        PhotoManager.openSetting();
      }//else
    }// try
    catch (e) {
      yield DeviceImagesStateFailed();

      // Open android/ios applicaton's setting to get permission
      // App crashes in background though
      PhotoManager.openSetting();
    }// catch
  }// _mapDeviceImagesEventFetchToDeviceImagesState

  Future<List<File>> _mapPhotosToFiles({@required List<AssetEntity> photos}) async {
    List<File> ans = [];
    for (int i = 0; i < photos.length; ++i) {
      ans.add(await photos[i].originFile);
    }// for

    return ans;
  }// _mapPhotosToFiles
  @override
  void onChange(Change<DeviceImagesState> change) {
    print('Device Images Bloc: $change');
    super.onChange(change);
  } // onChange

  @override
  Future<void> close() {
    print('Device Images Bloc Closed');
    return super.close();
  } // close
}
