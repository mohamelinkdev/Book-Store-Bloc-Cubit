import 'package:book_store/features/books/data/model/book.dart';
import 'package:book_store/features/books/data/repository/books_repository.dart';
import 'package:book_store/features/books/presentation/view_model/books_book_marked_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BooksBookMarkedViewModel extends Bloc<BooksBookMarkedEvent, List<Book>> {
  final BooksRepositoryBase _repository;

  BooksBookMarkedViewModel(this._repository) : super([]) {
    on<LoadBookmarksEvent>(_onLoadBookmarks);
    on<ToggleBookmarkEvent>(_onToggle);

    add(LoadBookmarksEvent());
  }

  void _onLoadBookmarks(
    LoadBookmarksEvent event,
    Emitter<List<Book>> emit,
  ) {
    emit(_repository.getBookmarks());
  }

  Future<void> _onToggle(
    ToggleBookmarkEvent event,
    Emitter<List<Book>> emit,
  ) async {
    await _repository.toggleBookmark(event.book);
    emit(_repository.getBookmarks());
  }
}
