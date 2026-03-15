import 'package:book_store/core/widgets/empty_state.dart';
import 'package:book_store/core/widgets/error_state.dart';
import 'package:book_store/core/widgets/loading_state.dart';
import 'package:book_store/core/widgets/search_bar.dart';
import 'package:book_store/features/books/data/model/book.dart';
import 'package:book_store/features/books/presentation/models/book_list_state.dart';
import 'package:book_store/features/books/presentation/view_model/book_list_viewmodel.dart';
import 'package:book_store/features/books/presentation/view_model/books_book_marked_view_model.dart';
import 'package:book_store/features/books/presentation/screens/book_details.dart';
import 'package:book_store/features/books/presentation/widgets/books_list_view.dart';
import 'package:book_store/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<BookListViewModel>().loadBooks();
    }
  }

  void _onSearch(String query) {
    context.read<BookListViewModel>().search(query);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        AppSearchBar(onSearch: _onSearch, hintText: l10n.searchBooksHint),
        Expanded(
          child: BlocBuilder<BookListViewModel, BooksListState>(
            builder: (context, booksState) {
              return BlocBuilder<BooksBookMarkedViewModel, List<Book>>(
                builder: (context, markedBooks) {
                  return _buildContent(booksState, markedBooks, l10n);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
    BooksListState state,
    List<Book> markedBooks,
    AppLocalizations l10n,
  ) {
    if (state is Loading) {
      return const LoadingState();
    }

    if (state is Failure) {
      return ErrorState(
        message: state.errorMessage,
        onRetry: () => context.read<BookListViewModel>().refresh(),
      );
    }

    if (state is NoDataError) {
      return EmptyState(message: l10n.noBooksFound, icon: Icons.search_off);
    }

    if (state is Success) {
      return BooksListView(
        books: state.books,
        hasMore: state.hasMore,
        paginationError: state.paginationError,
        scrollController: _scrollController,
        onRefresh: () => context.read<BookListViewModel>().refresh(),
        onRetry: state.paginationError != null
            ? () => context.read<BookListViewModel>().loadBooks()
            : null,
        onBookmarkTap: (book) =>
            context.read<BooksBookMarkedViewModel>().toggle(book),
        isBookmarked: (id) => markedBooks.any((b) => b.id == id),
        onBookTap: (book) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book)),
          );
        },
      );
    }

    return const SizedBox();
  }
}
