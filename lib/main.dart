import 'dart:io';

import 'package:album_share/core/components/window_titlebar.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:album_share/screens/auth/auth_screen.dart';
import 'package:album_share/services/api_service.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );

  DesktopWindowTitlebar.openWindow();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: AuthScreen(),
    );
  }
}
