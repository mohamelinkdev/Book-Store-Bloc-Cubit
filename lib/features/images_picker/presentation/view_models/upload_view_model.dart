
import 'package:book_store/features/images_picker/domain/usecases/upload_multiple_images_usecase.dart';
import 'package:book_store/features/images_picker/presentation/model/upload_state.dart';
import 'package:book_store/features/images_picker/presentation/view_models/upload_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadViewModel extends Bloc<UploadEvent, UploadState> {
  final UploadMultipleImagesUseCase _uploadMultipleImagesUseCase;

  UploadViewModel(this._uploadMultipleImagesUseCase) : super(UploadState()) {
    on<AddFilesEvent>(_onAddFiles);
    on<AddFileEvent>(_onAddFile);
    on<RemoveLocalFileEvent>(_onRemoveFile);
    on<UploadAllSelectedEvent>(_onUploadAll);
  }

  void _onAddFiles(AddFilesEvent event, Emitter<UploadState> emit) {
    if (event.files.isNotEmpty) {
      emit(state.copyWith(
        selectedLocalFiles: [...state.selectedLocalFiles, ...event.files],
      ));
    }
  }

  void _onAddFile(AddFileEvent event, Emitter<UploadState> emit) {
    emit(state.copyWith(
      selectedLocalFiles: [...state.selectedLocalFiles, event.file],
    ));
  }

  void _onRemoveFile(RemoveLocalFileEvent event, Emitter<UploadState> emit) {
    final updatedList = state.selectedLocalFiles
        .where((file) => file.path != event.file.path)
        .toList();
    emit(state.copyWith(selectedLocalFiles: updatedList));
  }

  Future<void> _onUploadAll(
    UploadAllSelectedEvent event,
    Emitter<UploadState> emit,
  ) async {
    if (state.selectedLocalFiles.isEmpty) return;

    emit(state.copyWith(isUploading: true));

    try {
      await _uploadMultipleImagesUseCase.execute(state.selectedLocalFiles);
      emit(UploadState(isUploading: false, isUploadSuccess: true, selectedLocalFiles: []));
    } catch (e) {
      emit(state.copyWith(isUploading: false));
    }
  }
}
