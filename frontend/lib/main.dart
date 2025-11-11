import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/products/bloc/products_bloc.dart';
import 'features/products/data/product_repository.dart';
import 'features/cart/bloc/cart_bloc.dart';
import 'features/cart/data/cart_repository.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/splash_screen.dart';

/// Application entry point
void main() {
  runApp(const App());
}

/// Root widget that sets up dependency injection and BLoC providers
/// Provides repositories and blocs to the entire app
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      // Provide repositories for dependency injection
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => ProductRepository()),
        RepositoryProvider(create: (_) => CartRepository()),
      ],
      child: MultiBlocProvider(
        // Provide BLoCs for state management
        providers: [
          BlocProvider(create: (ctx) => AuthBloc(ctx.read<AuthRepository>())),
          BlocProvider(
              create: (ctx) => ProductsBloc(ctx.read<ProductRepository>())
                ..add(ProductsRequested())), // Load products on app start
          BlocProvider(create: (ctx) => CartBloc(ctx.read<CartRepository>())),
        ],
        child: const AppWithLocale(),
      ),
    );
  }
}

/// Widget that manages app locale and theme
/// Handles language switching and Material Design 3 theming
class AppWithLocale extends StatefulWidget {
  const AppWithLocale({super.key});

  @override
  State<AppWithLocale> createState() => AppWithLocaleState();
}

class AppWithLocaleState extends State<AppWithLocale> {
  /// Current app locale (default: English)
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
  }

  /// Updates app locale and triggers rebuild
  void setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
