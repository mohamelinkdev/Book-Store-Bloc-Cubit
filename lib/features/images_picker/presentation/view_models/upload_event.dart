import 'dart:io';

sealed class UploadEvent {}

class AddFilesEvent extends UploadEvent {
  final List<File> files;
  AddFilesEvent(this.files);
}

class AddFileEvent extends UploadEvent {
  final File file;
  AddFileEvent(this.file);
}

class RemoveLocalFileEvent extends UploadEvent {
  final File file;
  RemoveLocalFileEvent(this.file);
}

class UploadAllSelectedEvent extends UploadEvent {}
