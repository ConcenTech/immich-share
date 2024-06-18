import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immich_share/screens/auth/auth_screen.dart';
import 'package:immich_share/services/api_service.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

void test() async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final cookieJar = PersistCookieJar(storage: FileStorage(dir.path));
    final api = ApiService(Dio(), cookieJar);
    print('Setup endpoint');
    await api.checkAndSetEndpoint('https://photos.concentechltd.co.uk/');
    print('login');
    await api.login('test@email.com', 'demo123456');
    print('get shared albums');
    final albums = await api.getSharedAlbums();
    for (var album in albums) {
      print(album);
    }
  } on ApiException catch (e) {
    debugPrint(e.message);
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthScreen(),
    );
  }
}
