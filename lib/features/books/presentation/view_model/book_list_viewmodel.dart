import 'package:book_store/core/constants/api_constants.dart';
import 'package:book_store/core/exceptions/exceptions.dart';
import 'package:book_store/features/books/data/model/book.dart';
import 'package:book_store/features/books/data/repository/books_repository.dart';
import 'package:book_store/features/books/presentation/models/book_list_state.dart';
import 'package:book_store/features/books/presentation/view_model/book_list_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:async';
import 'package:book_store/core/localization/locale_view_model.dart';
import 'package:flutter/material.dart';

class BookListViewModel extends Bloc<BookListEvent, BooksListState> {
  final BooksRepositoryBase _repository;
  final LocaleViewModel _localeCubit;
  late final StreamSubscription<Locale> _localeSubscription;

  int _page = 0;
  String _query = ApiConstants.defaultSearch;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  List<Book> _books = [];
  String _currentLang = 'en';

  BookListViewModel(this._repository, this._localeCubit) : super(Loading()) {
    _currentLang = _localeCubit.state.languageCode;

    on<LoadBooksEvent>(_onLoadBooks);
    on<SearchBooksEvent>(_onSearch);
    on<RefreshBooksEvent>(_onRefresh);

    add(LoadBooksEvent(reset: true));

    _localeSubscription = _localeCubit.stream.listen((locale) {
      _currentLang = locale.languageCode;
      add(LoadBooksEvent(reset: true));
    });
  }

  Future<void> _onLoadBooks(
    LoadBooksEvent event,
    Emitter<BooksListState> emit,
  ) async {
    final reset = event.reset;

    if (_isLoadingMore) return;
    if (!_hasMore && !reset) return;

    _isLoadingMore = true;

    if (reset) {
      _page = 0;
      _hasMore = true;
      _books = [];
      emit(Loading(hasMore: _hasMore));
    }

    try {
      final books = await _repository.getBooks(
        query: _query,
        page: _page,
        lang: _currentLang,
      );

      if (books.isEmpty) {
        _hasMore = false;

        if (reset && _books.isEmpty) {
          emit(NoDataError());
          _isLoadingMore = false;
          return;
        }
      }

      _page++;
      _books.addAll(books);

      emit(Success(_books, hasMore: _hasMore));
    } on NetworkException catch (_) {
      _emitError('Network error', reset, emit);
    } on ServerException catch (_) {
      _emitError('Server error', reset, emit);
    } on TimeoutException {
      _emitError('Request timed out', reset, emit);
    } on FormatException catch (_) {
      _emitError('Data parsing error', reset, emit);
    } catch (_) {
      _emitError('An unexpected error occurred', reset, emit);
    }

    _isLoadingMore = false;
  }

  void _emitError(String message, bool reset, Emitter<BooksListState> emit) {
    if (reset) {
      emit(Failure(message, hasMore: _hasMore));
    } else {
      emit(Success([..._books], hasMore: _hasMore, paginationError: message));
    }
  }

  Future<void> _onSearch(
    SearchBooksEvent event,
    Emitter<BooksListState> emit,
  ) async {
    final effectiveQuery = event.query.trim().isEmpty
        ? ApiConstants.defaultSearch
        : event.query.trim();

    if (effectiveQuery == _query) return;

    _query = effectiveQuery;
    await _onLoadBooks(LoadBooksEvent(reset: true), emit);
  }

  Future<void> _onRefresh(
    RefreshBooksEvent event,
    Emitter<BooksListState> emit,
  ) async {
    await _onLoadBooks(LoadBooksEvent(reset: true), emit);
  }

  @override
  Future<void> close() {
    _localeSubscription.cancel();
    return super.close();
  }
}
