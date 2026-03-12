import 'package:book_store/core/theme/theme_mode_cubit.dart';
import 'package:book_store/core/localization/locale_cubit.dart';
import 'package:book_store/features/books/data/repository/books_repository.dart';
import 'package:book_store/features/books/presentation/view_model/book_list_viewmodel.dart';
import 'package:book_store/features/images_picker/data/datasources/remote_storage_datasource.dart';
import 'package:book_store/features/images_picker/data/repositories/storage_repository_impl.dart';
import 'package:book_store/features/images_picker/domain/repositories/storage_repository.dart';
import 'package:book_store/features/images_picker/domain/usecases/get_image_history_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_store/features/books/presentation/screens/bookmark_screen.dart';
import 'package:book_store/features/books/presentation/screens/books_list_screen.dart';
import 'package:book_store/features/images_picker/presentation/screens/image_history_screen.dart';
import 'package:book_store/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final _pages = const [BooksScreen(), BookMarkScreen(), ImageHistoryScreen()];

  void _toggleThemeMode() {
    context.read<ThemeModeCubit>().toggle();
  }

  IconData _themeIcon(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => Icons.brightness_auto,
      ThemeMode.light => Icons.light_mode,
      ThemeMode.dark => Icons.dark_mode,
    };
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeModeCubit>().state;
    final currentLocale = context.watch<LocaleCubit>().state;
    final l10n = AppLocalizations.of(context)!;

    String getAppBarTitle(int index) {
      switch (index) {
        case 0:
          return l10n.books;
        case 1:
          return l10n.bookmarks;
        case 2:
          return l10n.imageHistory;
        default:
          return l10n.home;
      }
    }

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IRemoteStorageDataSource>(
          create: (_) => RemoteStorageDatasource(),
        ),
        RepositoryProvider<StorageRepository>(
          create: (context) =>
              StorageRepositoryImpl(context.read<IRemoteStorageDataSource>()),
        ),
        RepositoryProvider<GetImageHistoryUseCase>(
          create: (context) =>
              GetImageHistoryUseCase(context.read<StorageRepository>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                BookListViewModel(
                  context.read<BooksRepositoryBase>(),
                  context.read<LocaleCubit>(),
                ),
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text(getAppBarTitle(_index)),
            actions: [
              TextButton(
                onPressed: () {
                  context.read<LocaleCubit>().toggleLocale();
                },
                child: Text(
                  currentLocale.languageCode == 'en' ? 'AR' : 'EN',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(_themeIcon(themeMode)),
                onPressed: _toggleThemeMode,
              ),
            ],
          ),
          body: IndexedStack(index: _index, children: _pages),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (value) {
              setState(() => _index = value);
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.menu_book_outlined),
                selectedIcon: const Icon(Icons.menu_book),
                label: l10n.books,
              ),
              NavigationDestination(
                icon: const Icon(Icons.bookmark_border),
                selectedIcon: const Icon(Icons.bookmark),
                label: l10n.bookmarks,
              ),
              NavigationDestination(
                icon: const Icon(Icons.photo_library_outlined),
                selectedIcon: const Icon(Icons.photo_library),
                label: l10n.imageHistory,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
