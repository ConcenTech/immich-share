import 'package:isar/isar.dart';

import 'json_map.dart';

part 'user.g.dart';

@collection
class User {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.shouldChangePassword,
  });

  /// Used only for offline database
  static const defaultIsarId = 0;

  /// Used only for offline database
  Id get isarId => defaultIsarId;

  // Access token stored in cookies.
  // final String token;
  final String id;
  final String email;
  final String name;
  final bool shouldChangePassword;

  factory User.fromJson(JsonMap json) {
    return User(
      id: json['userId'],
      // Access token stored in cookies.
      // token: json['accessToken'],
      email: json['userEmail'],
      name: json['name'],
      shouldChangePassword: json['shouldChangePassword'],
    );
  }

  @override
  int get hashCode => id.hashCode;
  
  @override
  bool operator ==(Object other) {
    return other is User && other.id == id;
  }
}
