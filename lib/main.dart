import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:immich_share/services/api_service.dart';

void main() {
  test();

  // runApp(const MainApp());
}

void test() async {
  try {
    final api = ApiService(Dio());
    print('Setup endpoint');
    await api.checkAndSetEndpoint('https://photos.concentechltd.co.uk/');
    print('login');
    await api.login('test@email.com', 'demo123456');
    print('get shared albums');
    await api.getSharedAlbums();
  } on ApiException catch (e) {
    debugPrint(e.message);
  }

  exit(0);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
