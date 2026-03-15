sealed class BookListEvent {}

class LoadBooksEvent extends BookListEvent {
  final bool reset;
  LoadBooksEvent({this.reset = false});
}

class SearchBooksEvent extends BookListEvent {
  final String query;
  SearchBooksEvent(this.query);
}

class RefreshBooksEvent extends BookListEvent {}
