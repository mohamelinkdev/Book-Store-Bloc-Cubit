import 'dart:io';
import 'package:book_store/core/constants/values_manager.dart';
import 'package:book_store/core/constants/font_manger.dart';
import 'package:book_store/features/images_picker/domain/usecases/upload_multiple_images_usecase.dart';
import 'package:book_store/features/images_picker/presentation/view_models/upload_cubit.dart';
import 'package:book_store/features/images_picker/presentation/view_models/upload_event.dart';
import 'package:book_store/features/images_picker/presentation/model/upload_state.dart';
import 'package:book_store/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:book_store/features/images_picker/data/datasources/remote_storage_datasource.dart';
import 'package:book_store/features/images_picker/data/repositories/storage_repository_impl.dart';
import 'package:book_store/features/images_picker/domain/repositories/storage_repository.dart';

class UploadImagesScreen extends StatelessWidget {
  const UploadImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IRemoteStorageDataSource>(
          create: (_) => RemoteStorageDatasource(),
        ),
        RepositoryProvider<StorageRepository>(
          create: (context) =>
              StorageRepositoryImpl(context.read<IRemoteStorageDataSource>()),
        ),
        RepositoryProvider<UploadMultipleImagesUseCase>(
          create: (context) =>
              UploadMultipleImagesUseCase(context.read<StorageRepository>()),
        ),
      ],
      child: BlocProvider(
        create: (context) =>
            UploadCubit(context.read<UploadMultipleImagesUseCase>()),
        child: const _UploadImagesContent(),
      ),
    );
  }
}

class _UploadImagesContent extends StatelessWidget {
  const _UploadImagesContent();

  @override
  Widget build(BuildContext context) {
    final uploadState = context.watch<UploadCubit>().state;
    final bloc = context.read<UploadCubit>();
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<UploadCubit, UploadState>(
      listenWhen: (previous, current) => current.isUploadSuccess && !previous.isUploadSuccess,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.uploadComplete)),
        );
        Navigator.pop(context);
      },
      child: Scaffold(
      appBar: AppBar(
        title: Text(l10n.newUpload),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: uploadState.isUploading
                ? null
                : () async {
                    final picker = ImagePicker();
                    final pickedFiles = await picker.pickMultiImage();
                    if (pickedFiles.isNotEmpty) {
                      final files = pickedFiles
                          .map((xFile) => File(xFile.path))
                          .toList();
                      bloc.add(AddFilesEvent(files));
                    }
                  },
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: uploadState.isUploading
                ? null
                : () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (pickedFile != null) {
                      bloc.add(AddFileEvent(File(pickedFile.path)));
                    }
                  },
          ),
        ],
      ),
      body: uploadState.selectedLocalFiles.isEmpty
          ? Center(child: Text(l10n.useIconsToPickImages))
          : Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(AppPadding.p8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppSize.s8,
                          mainAxisSpacing: AppSize.s8,
                        ),
                    itemCount: uploadState.selectedLocalFiles.length,
                    itemBuilder: (context, index) {
                      final file = uploadState.selectedLocalFiles[index];
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(AppSize.s8),
                              child: Image.file(file, fit: BoxFit.cover),
                            ),
                          ),
                          if (!uploadState.isUploading)
                            Positioned(
                              top: AppSize.s4,
                              right: AppSize.s4,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                  size: AppSize.s32,
                                ),
                                onPressed: () => bloc.add(RemoveLocalFileEvent(file)),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppPadding.p16),
                    child: SizedBox(
                      width: double.infinity,
                      height: AppSize.s50,
                      child: ElevatedButton(
                        onPressed: uploadState.isUploading
                            ? null
                            : () {
                                bloc.add(UploadAllSelectedEvent());
                              },
                        child: uploadState.isUploading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                l10n.uploadAllSelectedImages,
                                style: const TextStyle(fontSize: FontSize.s16),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    ),
    );
  }
}
