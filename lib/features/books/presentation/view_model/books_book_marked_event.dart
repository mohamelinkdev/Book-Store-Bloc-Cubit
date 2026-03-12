import 'package:book_store/features/books/data/model/book.dart';

sealed class BooksBookMarkedEvent {}

class LoadBookmarksEvent extends BooksBookMarkedEvent {}

class ToggleBookmarkEvent extends BooksBookMarkedEvent {
  final Book book;
  ToggleBookmarkEvent(this.book);
}
