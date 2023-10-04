import 'package:flutter/material.dart';

import 'presentation/pages/main/main_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.build(
        colorScheme: AppColorScheme.light,
      ),
      darkTheme: AppTheme.build(
        colorScheme: AppColorScheme.dark,
      ),
      home: const MainPage(),
    );
  }
}

class AppTheme {
  const AppTheme._();

  static ThemeData build({
    required ColorScheme colorScheme,
  }) =>
      ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          toolbarHeight: kToolbarHeight + 16,
        ),
        listTileTheme: ListTileThemeData(
          tileColor: colorScheme.primaryContainer,
        ),
      );
}

class AppColorScheme {
  const AppColorScheme._();

  static ColorScheme get light {
    const baseColorScheme = ColorScheme.light();

    return ColorScheme.fromSeed(
      seedColor: baseColorScheme.primary,
      secondary: baseColorScheme.secondary,
      error: baseColorScheme.error,
    );
  }

  static ColorScheme get dark {
    const baseColorScheme = ColorScheme.dark();

    return ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: baseColorScheme.primary,
      secondary: baseColorScheme.secondary,
      error: baseColorScheme.error,
    );
  }
}
