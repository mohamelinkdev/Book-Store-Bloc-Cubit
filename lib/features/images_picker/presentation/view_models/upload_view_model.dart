import 'dart:io';
import 'package:book_store/features/images_picker/domain/usecases/upload_multiple_images_usecase.dart';
import 'package:book_store/features/images_picker/presentation/model/upload_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadViewModel extends Cubit<UploadState> {
  final UploadMultipleImagesUseCase _uploadMultipleImagesUseCase;

  UploadViewModel(this._uploadMultipleImagesUseCase) : super(UploadState());

  void addFiles(List<File> files) {
    if (files.isNotEmpty) {
      emit(state.copyWith(
        selectedLocalFiles: [...state.selectedLocalFiles, ...files],
      ));
    }
  }

  void addFile(File file) {
    emit(state.copyWith(
      selectedLocalFiles: [...state.selectedLocalFiles, file],
    ));
  }

  void removeLocalFile(File fileToRemove) {
    final updatedList = state.selectedLocalFiles
        .where((file) => file.path != fileToRemove.path)
        .toList();
    emit(state.copyWith(selectedLocalFiles: updatedList));
  }

  Future<bool> uploadAllSelected() async {
    if (state.selectedLocalFiles.isEmpty) return false;

    emit(state.copyWith(isUploading: true));

    try {
      await _uploadMultipleImagesUseCase.execute(state.selectedLocalFiles);
      emit(UploadState(isUploading: false, selectedLocalFiles: []));
      return true;
    } catch (e) {
      emit(state.copyWith(isUploading: false));
      return false;
    }
  }
}
