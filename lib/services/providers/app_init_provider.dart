import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database_provider.dart';

final appInitProvider = FutureProvider((ref) async {
  final database = ref.watch(databaseProvider);
  await database.init();

  
});