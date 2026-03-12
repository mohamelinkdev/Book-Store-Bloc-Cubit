import 'package:book_store/features/books/data/model/book.dart';
import 'package:book_store/features/books/data/repository/books_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BooksBookMarkedCubit extends Cubit<List<Book>> {
  final BooksRepositoryBase _repository;

  BooksBookMarkedCubit(this._repository) : super([]) {
    _loadBookmarks();
  }

  void _loadBookmarks() {
    emit(_repository.getBookmarks());
  }

  Future<void> toggle(Book book) async {
    await _repository.toggleBookmark(book);
    _loadBookmarks();
  }
}
