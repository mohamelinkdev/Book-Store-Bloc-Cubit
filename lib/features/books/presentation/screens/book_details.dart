import 'package:book_store/core/constants/values_manager.dart';
import 'package:book_store/features/books/data/model/book.dart';
import 'package:book_store/features/books/presentation/view_model/books_book_marked_view_model.dart';
import 'package:book_store/features/books/presentation/view_model/books_book_marked_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksBookMarkedViewModel, List<Book>>(
      builder: (context, books) {
        final isBookmarked = books.any((b) => b.id == book.id);

        return Scaffold(
          appBar: AppBar(
            title: Text(book.title),
            actions: [
              IconButton(
                icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                onPressed: () {
                  context.read<BooksBookMarkedViewModel>().add(ToggleBookmarkEvent(book));
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(book.thumbnail),
                  const SizedBox(height: AppSize.s16),
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: AppSize.s20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(book.author),
                  const SizedBox(height: AppSize.s16),
                  Text(book.description),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
