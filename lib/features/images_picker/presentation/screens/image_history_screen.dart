import 'package:book_store/core/constants/values_manager.dart';
import 'package:book_store/features/images_picker/domain/entities/uploaded_image.dart';
import 'package:book_store/features/images_picker/domain/usecases/get_image_history_usecase.dart';
import 'package:book_store/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'upload_images_screen.dart';

class ImageHistoryScreen extends StatelessWidget {
  const ImageHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final getImageHistoryUseCase = context.read<GetImageHistoryUseCase>();

    return Scaffold(
      body: StreamBuilder<List<UploadedImage>>(
        stream: getImageHistoryUseCase.execute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(l10n.errorLoadingHistory));
          }

          final images = snapshot.data ?? [];

          if (images.isEmpty) {
            return Center(child: Text(l10n.noImagesFoundInHistory));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(AppPadding.p8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppSize.s8,
              mainAxisSpacing: AppSize.s8,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.s8),
                child: Image.network(
                  images[index].url,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UploadImagesScreen(),
            ),
          );
        },
      ),
    );
  }
}
