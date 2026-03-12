import 'dart:io';

class UploadState {
  final bool isUploading;
  final bool isUploadSuccess;
  final List<File> selectedLocalFiles;
  UploadState({
    this.isUploading = false,
    this.isUploadSuccess = false,
    this.selectedLocalFiles = const [],
  });
  UploadState copyWith({
    bool? isUploading,
    bool? isUploadSuccess,
    List<File>? selectedLocalFiles,
  }) {
    return UploadState(
      isUploading: isUploading ?? this.isUploading,
      isUploadSuccess: isUploadSuccess ?? this.isUploadSuccess,
      selectedLocalFiles: selectedLocalFiles ?? this.selectedLocalFiles,
    );
  }
}
