import 'package:book_store/features/books/data/model/book.dart';
import 'package:book_store/features/books/presentation/view_model/books_book_marked_view_model.dart';
import 'package:book_store/features/books/presentation/screens/book_details.dart';
import 'package:book_store/features/books/presentation/widgets/book_list_item.dart';
import 'package:book_store/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookMarkScreen extends StatelessWidget {
  const BookMarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<BooksBookMarkedViewModel, List<Book>>(
      builder: (context, books) {
        if (books.isEmpty) {
          return Center(child: Text(l10n.noBookmarks));
        }
        return ListView.builder(
          itemCount: books.length,
          itemBuilder: (_, index) {
            final book = books[index];

            return BookListItem(
              book: book,
              isBookmarked: true,
              onBookmarkTap: () =>
                  context.read<BooksBookMarkedViewModel>().toggle(book),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book)),
                );
              },
            );
          },
        );
      },
    );
  }
}
