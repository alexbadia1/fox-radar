import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'fetch_image_state.dart';
import 'package:database_repository/database_repository.dart';

/**
 * 
 * TODO: FIX
 * 
 * In a list where items (and their associated Cubits) could be destroyed at 
 * any time, it's risky to have Cubits that perform asynchronous actions. When 
 * the Cubit is destroyed, any ongoing asynchronous actions could still 
 * complete and try to update the Cubit, leading to errors.
 * 
 */
class FetchImageCubit extends Cubit<FetchImageState> {
  final DatabaseRepository db;
  FetchImageCubit({required this.db}) : super(FetchImageInitial());

  void fetchImage({required String eventID}) async {
    Uint8List? _bytes;
    try {
      _bytes = await db.getImageFromStorage(eventID: eventID);

      if (_bytes != null) {
        emit(FetchImageSuccess(imageBytes: _bytes));
      } else {
        emit(FetchImageFailure());
      }
    } catch (error) {
      emit(FetchImageFailure());
    }
    return;
  }

  @override
  void onChange(Change<FetchImageState> change) {
    print('Fetch Image Cubit: $change');
    super.onChange(change);
  }
}
