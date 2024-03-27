import 'dart:async';
import 'package:flutter/services.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:photo_manager/photo_manager.dart';

class DeviceImagesBloc extends Bloc<DeviceImagesEvent, DeviceImagesState> {
  final int paginationLimit = 10;
  int failedAttempts = 0;
  DeviceImagesBloc() : super(DeviceImagesStateFetching()) {
    on<DeviceImagesEventFetch>(_mapDeviceImagesEventFetchToDeviceImagesState);
  }

  void _mapDeviceImagesEventFetchToDeviceImagesState(
    DeviceImagesEventFetch event,
    Emitter<DeviceImagesState> emit,
  ) async {
    // Get the current state for later use...
    final _currentState = this.state;
    bool _maxImages = false;

    // Fetch called fom fail state
    if (_currentState is DeviceImagesStateFailed) {
      emit(DeviceImagesStateFetching());
    }

    try {
      bool hasPermission = false;

      try {
        final PermissionState result =
            await PhotoManager.requestPermissionExtend();
        hasPermission = result.isAuth || result.hasAccess;
      } catch (newApiError) {
        emit(DeviceImagesStateFailed(failedAttempts: this.failedAttempts++));
      }

      if (hasPermission) {
        // No posts were fetched yet...
        if (_currentState is DeviceImagesStateFetching ||
            _currentState is DeviceImagesStateFailed ||
            _currentState is DeviceImagesStateDenied) {

          // Set "onlyAll == true": to only get ONE Album (Recent Album by default)
          final List<AssetPathEntity> albums =
              await PhotoManager.getAssetPathList(onlyAll: true);

          print(albums);

          // Get photos
          final List<AssetEntity>? photos = await albums[0]
              .getAssetListPaged(page: 0, size: this.paginationLimit);

          // Map photos to file data type
          List<Uint8List> tempFiles = await _mapPhotosToFiles(photos: photos!);
          List<String> tempFilesPaths =
              await _mapPhotosToFilePaths(photos: photos);

          if (tempFiles.length != this.paginationLimit) {
            _maxImages = true;
          }

          // Compress images
          // print("Compressing images");
          // final List<Uint8List> compressedImageBytes = await _mapFilesToCompressedUint8List(tempFiles);

          emit(
            DeviceImagesStateSuccess(
              paths: tempFilesPaths,
              images: tempFiles,
              lastPage: 0,
              maxImages: _maxImages,
              isFetching: false,
            ),
          );
        }

        // Some images were already fetched from storage, get more
        else if (_currentState is DeviceImagesStateSuccess) {
          // Set "onlyAll == true": to only get ONE Album (Recent Album by default)
          final List<AssetPathEntity> albums =
              await PhotoManager.getAssetPathList(
                  onlyAll: true, type: RequestType.image);

          // Get photos
          final List<AssetEntity>? photos = await albums[0].getAssetListPaged(
              page: _currentState.lastPage + 1, size: paginationLimit);

          // Map photos to file data type
          List<Uint8List> tempFiles = await _mapPhotosToFiles(photos: photos!);
          List<String> tempFilesPaths =
              await _mapPhotosToFilePaths(photos: photos);

          // // Compress images
          // final List<Uint8List> compressedImageBytes = await _mapFilesToCompressedUint8List(tempFiles);

          // No images were retrieved
          if (tempFiles.isEmpty) {
            emit(
              DeviceImagesStateSuccess(
                paths: _currentState.paths,
                images: _currentState.images,
                lastPage: _currentState.lastPage,
                maxImages: true,
                isFetching: false,
              ),
            );
          } else {
            if (tempFiles.length != this.paginationLimit) {
              _maxImages = true;
            }

            emit(
              DeviceImagesStateSuccess(
                paths: _currentState.paths + tempFilesPaths,
                images: _currentState.images + tempFiles,
                maxImages: _maxImages,
                lastPage: _currentState.lastPage + 1,
                isFetching: false,
              ),
            );
          }
        }
      } else {
        emit(DeviceImagesStateDenied());
      }
    } catch (err) {
      if (err is PlatformException) {
        if (err.code == 'Request for permission failed.') {
          emit(DeviceImagesStateDenied());
        }
      }

      print(err);
      emit(DeviceImagesStateFailed(failedAttempts: this.failedAttempts++));
    }
  }

  Future<List<Uint8List>> _mapPhotosToFiles(
      {required List<AssetEntity> photos}) async {
    List<Uint8List> ans = [];

    ans = await Future.microtask(() async {
      for (int i = 0; i < photos.length; ++i) {
        final Uint8List? f = await photos[i].originBytes;
        ans.add(f!);
      }

      return ans;
    });

    return ans;
  }

  Future<List<String>> _mapPhotosToFilePaths(
      {required List<AssetEntity> photos}) async {
    List<String> ans = [];

    ans = await Future.microtask(() async {
      for (int i = 0; i < photos.length; ++i) {
        final f = await photos[i].file;
        ans.add(f!.path);
      }

      return ans;
    });

    return ans;
  }

  @override
  void onChange(Change<DeviceImagesState> change) {
    print('Device Images Bloc: $change');
    super.onChange(change);
  }

  @override
  Future<void> close() {
    print('Device Images Bloc Closed');
    return super.close();
  }
}
