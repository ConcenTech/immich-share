import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:album_share/services/database_service.dart';

final databaseProvider = Provider((ref) => DatabaseService());