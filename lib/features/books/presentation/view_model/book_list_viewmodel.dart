import 'package:book_store/core/constants/api_constants.dart';
import 'package:book_store/core/exceptions/exceptions.dart';
import 'package:book_store/features/books/data/model/book.dart';
import 'package:book_store/features/books/data/repository/books_repository.dart';
import 'package:book_store/features/books/presentation/models/book_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:async';
import 'package:book_store/core/localization/locale_view_model.dart';
import 'package:flutter/material.dart';

class BookListViewModel extends Cubit<BooksListState> {
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
    loadBooks(reset: true);

    _localeSubscription = _localeCubit.stream.listen((locale) {
      _currentLang = locale.languageCode;
      loadBooks(reset: true);
    });
  }

  Future<void> loadBooks({bool reset = false}) async {

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
      _emitError('Network error', reset);
    } on ServerException catch (_) {
      _emitError('Server error', reset);
    } on TimeoutException {
      _emitError('Request timed out', reset);
    } on FormatException catch (_) {
      _emitError('Data parsing error', reset);
    } catch (_) {
      _emitError('An unexpected error occurred', reset);
    }

    _isLoadingMore = false;
  }

  void _emitError(String message, bool reset) {
    if (reset) {
      emit(Failure(message, hasMore: _hasMore));
    } else {
      emit(Success([..._books], hasMore: _hasMore, paginationError: message));
    }
  }

  void search(String query) {
    final effectiveQuery = query.trim().isEmpty
        ? ApiConstants.defaultSearch
        : query.trim();

    if (effectiveQuery == _query) return;

    _query = effectiveQuery;
    loadBooks(reset: true);
  }

  Future<void> refresh() async {
    await loadBooks(reset: true);
  }

  @override
  Future<void> close() {
    _localeSubscription.cancel();
    return super.close();
  }
}
