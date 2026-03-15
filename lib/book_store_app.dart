import 'package:book_store/features/books/data/repository/books_repository.dart';
import 'package:book_store/features/books/presentation/view_model/books_book_marked_view_model.dart';
import 'package:book_store/features/splash/splash_screen.dart';
import 'package:book_store/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_view_model.dart';
import 'core/localization/locale_view_model.dart';

class BookStoreApp extends StatelessWidget {
  const BookStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<BooksRepositoryBase>(
          create: (_) => BooksRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeModeViewModel()),
          BlocProvider(create: (_) => LocaleViewModel()),
          BlocProvider(
            create: (context) =>
                BooksBookMarkedViewModel(context.read<BooksRepositoryBase>()),
          ),
        ],
        child: BlocBuilder<ThemeModeViewModel, ThemeMode>(
          builder: (context, themeMode) {
            return BlocBuilder<LocaleViewModel, Locale>(
              builder: (context, currentLocale) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  themeMode: themeMode,
                  locale: currentLocale,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: AppLocalizations.supportedLocales,
                  home: const SplashScreen(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
