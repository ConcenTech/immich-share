import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/album.dart';
import '../models/asset.dart';
import '../models/endpoint.dart';
import '../models/user.dart';

class DatabaseService {
  Isar? _isar;

  Isar get _db {
    if (_isar == null) {
      throw DatabaseException('The database has not been opened.', 'get _db');
    }
    return _isar!;
  }

  Future<T> _readTxn<T>(Future<T> Function() callback, String origin) async {
    try {
      return await _db.txn(callback);
    } on IsarError catch (e) {
      throw DatabaseException(e.message, origin);
    }
  }

  Future<void> _writeTxn<T>(
      Future<T> Function() callback, String origin) async {
    try {
      await _db.writeTxn(callback);
    } on IsarError catch (e) {
      throw DatabaseException(e.message, origin);
    }
  }

  /// Opens the database ready for reading and writing.
  Future<void> init() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open([], directory: dir.path);
    } catch (e) {
      throw DatabaseException('Failed to open the database.', 'init', '$e');
    }
  }

  /// Removes all data from the offline database.
  ///
  /// Enpoint retained unless [endpoint] set to true.
  Future<void> clear([bool endpoint = false]) async {
    try {
      await _db.writeTxn(() async {
        await _db.users.clear();
        await _db.albums.clear();
        await _db.assets.clear();
        if (endpoint) {
          await _db.endpoints.clear();
        }
      });
    } on IsarError catch (e) {
      throw DatabaseException(
          'Failed to clear the database', 'clear', e.message);
    }
  }

  /// Gets the server url endpoint if set, otherwise returns null.
  ///
  /// Throws [DatabaseException] if the operation fails.
  Future<Endpoint?> getEndpoint() {
    return _readTxn(
      () => _db.endpoints.get(Endpoint.id),
      'getEndpoint',
    );
  }

  /// Inserts or updates the server url endpoint.
  ///
  /// Throws [DatabaseException] if the operation fails.
  Future<void> setEndpoint(Endpoint endpoint) {
    return _writeTxn(
      () => _db.endpoints.put(endpoint),
      'setEndpoint',
    );
  }

  /// Gets the current user if set, otherwise returns null.
  ///
  /// Throws [DatabaseException] if the operation fails.
  Future<User?> getUser() {
    return _readTxn<User?>(
      () => _db.users.get(User.defaultIsarId),
      'getUser',
    );
  }

  /// Inserts or updates the current user.
  ///
  /// Throws [DatabaseException] if the operation fails.
  Future<void> setUser(User user) {
    return _writeTxn(() => _db.users.put(user), 'setUser');
  }

  Future<List<Album>> getAlbums() {
    return _readTxn(
      () => _db.albums.where().anyIsarId().findAll(),
      'getAlbums',
    );
  }

  /// Retrieves assets for the selected album.
  ///
  /// If album is null, all assets are retrieved.
  Future<List<Asset>> getAssets([Album? album]) {
    return _readTxn(
      () => album == null
          ? _db.assets.where().anyIsarId().findAll()
          : _db.assets.where().filter().albumIdEqualTo(album.id).findAll(),
      'getAssets',
    );
  }
}

class DatabaseException implements Exception {
  DatabaseException(
    this.message,
    this.method, [
    this.details,
  ]);

  final String message;
  final String? details;
  final String method;

  String debugMessage() => 'DatabaseService.$method: $message \n$details';
}
