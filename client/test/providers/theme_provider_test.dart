import 'package:flutter_test/flutter_test.dart';
import 'package:client/providers/theme_provider.dart';
import 'package:flutter/material.dart';

void main() {
  group('ThemeProvider', () {
    late ThemeProvider themeProvider;

    setUp(() {
      themeProvider = ThemeProvider();
    });

    test('initial themeMode should be light', () {
      expect(themeProvider.themeMode, ThemeMode.light);
    });

    test('isDarkMode should be false when themeMode is light', () {
      expect(themeProvider.isDarkMode, isFalse);
    });

    test('isDarkMode should be true when themeMode is dark', () {
      themeProvider.themeMode = ThemeMode.dark;
      expect(themeProvider.isDarkMode, isTrue);
    });

    test('toggleTheme should update themeMode and notify listeners', () {
      bool listenerNotified = false;
      themeProvider.addListener(() {
        listenerNotified = true;
      });

      themeProvider.toggleTheme(true);

      expect(themeProvider.themeMode, ThemeMode.dark);
      expect(listenerNotified, isTrue);
    });
  });

  group('MyTheme', () {
    test('lightTheme should have the correct scaffold background color', () {
      expect(
        MyTheme.lightTheme.scaffoldBackgroundColor,
        Colors.white,
      );
    });

    test('lightTheme should have the correct color scheme', () {
      final colorScheme = MyTheme.lightTheme.colorScheme;

      expect(colorScheme.primary, Colors.white);
      expect(colorScheme.secondary, Colors.black);
      expect(colorScheme.error, Colors.red);
    });

    test('darkTheme should have the correct scaffold background color', () {
      expect(
        MyTheme.darkTheme.scaffoldBackgroundColor,
        Color.fromARGB(255, 8, 23, 233),
      );
    });

    test('darkTheme should have the correct color scheme', () {
      final colorScheme = MyTheme.darkTheme.colorScheme;

      expect(colorScheme.primary, Color.fromARGB(255, 76, 85, 190));
      expect(colorScheme.secondary, Colors.white);
      expect(colorScheme.error, Colors.red);
    });
  });
}
