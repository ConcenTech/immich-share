import 'package:isar/isar.dart';

import '../core/utils/db_utils.dart';
import 'json_map.dart';

part 'user.g.dart';

@collection
class User {
  const User({
    required this.id,
    required this.token,
    required this.email,
    required this.name,
    required this.shouldChangePassword,
  });

  /// Used only for offline storage
  Id get isarId => fastHash(id);

  final String token;
  final String id;
  final String email;
  final String name;
  final bool shouldChangePassword;

  factory User.fromJson(JsonMap json) {
    return User(
      id: json['userId'],
      token: json['accessToken'],
      email: json['userEmail'],
      name: json['name'],
      shouldChangePassword: json['shouldChangePassword'],
    );
  }
}
