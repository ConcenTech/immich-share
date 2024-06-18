import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../models/album.dart';
import '../models/asset.dart';
import '../models/json_map.dart';
import '../models/user.dart';

const _applicationJson = 'application/json';

class ApiService {
  const ApiService(this._dio, this._cookieJar);

  final Dio _dio;
  final CookieJar _cookieJar;

  Future<bool> checkAndSetEndpoint(String serverUrl) async {
    // verify endpoint
    _dio.options.baseUrl = serverUrl;
    _dio.options.headers = {'Accept': _applicationJson};

    _dio.interceptors.clear();
    _dio.interceptors.add(CookieManager(_cookieJar));

    return true;
  }

  /// Attempts to login with the supplied credentials.
  ///
  /// Throws [ApiException] if unsuccessful.
  Future<User> login(String email, String password) async {
    _expectEndpointSet();

    final body = await _post(
      'api/auth/login',
      data: {
        'email': email,
        'password': password,
      },
      headers: {
        'Accept': _applicationJson,
        'Content-Type': _applicationJson,
      },
      sample: JSON_MAP,
    );

    return User.fromJson(body);
  }

  /// Verify the supplied user authentication token is valid.
  ///
  /// Return true if valid, otherwise returns false.
  ///
  /// Throws [ApiException] if unsuccessful.
  Future<bool> validateAuthToken(String token) async {
    _expectEndpointSet();

    final body = await _post(
      'api/auth/validateToken',
      sample: JSON_MAP,
    );

    return body['authStatus'];
  }

  /// Logs out the current user.
  ///
  /// Returns true if user logged out
  ///
  /// Throws [ApiException] if unsuccessful.
  Future<bool> logout() async {
    _expectEndpointSet();

    final body = await _post(
      'api/auth/logout',
      sample: JSON_MAP,
    );

    return body['successful'];
  }

  /// Changes the password of the current user.
  ///
  /// Throws [ApiException] if unsuccessful.
  Future<void> changePassword(String password, String newPassword) async {
    _expectEndpointSet();

    await _post(
      'api/auth/change-password',
      data: {
        "password": password,
        "newPassword": newPassword,
      },
      headers: {
        'Content-Type': _applicationJson,
      },
      sample: JSON_MAP,
    );
  }

  /// Retrieves a list of all albums shared with this user.
  ///
  /// Throws [ApiException] if unsuccessful.
  Future<List<Album>> getSharedAlbums() async {
    _expectEndpointSet();

    final body = await _get(
      'api/albums',
      queryParameters: {'shared': 'true'},
      sample: JSON_LIST,
    );

    return body.map((e) => Album.fromJson(e)).toList();
  }

  /// Gets assets for the selected album.
  ///
  /// Throws [ApiException] if unsuccessful.
  Future<List<Asset>> getAlbumAssets(String albumId) async {
    _expectEndpointSet();

    final body = await _get('api/albums/$albumId', sample: JSON_MAP);

    final assets = List.from(body['assets']);

    return assets
        .map((e) => Asset.fromJson(
              albumId,
              JsonMap.from(e),
            ))
        .toList();
  }

  /// Ensures the server url has been set via a call to [checkAndSetEndpoint]
  void _expectEndpointSet() {
    if (_dio.options.baseUrl.isEmpty) {
      throw ApiException(0, 'Server url has not been set');
    }
  }

  /// Extracts a json object from the request.
  ///
  /// Throws [ApiException] if the request was not valid or extraction failed.
  Future<JsonMap> _extractObjectFromResponse(Response response) async {
    if (response.statusCode == null || response.statusCode! > 201) {
      throw ApiException.fromResponse(response);
    }

    JsonMap? body;

    if (response.data is String) {
      body = await compute(
        (String j) => json.decode(j),
        response.data as String,
      );
    } else if (response.data != null) {
      body = JsonMap.from(response.data);
    }

    if (body == null ||
        body.isEmpty ||
        response.statusCode == HttpStatus.noContent) {
      throw ApiException(
          HttpStatus.noContent, 'No content included with response');
    }

    return body;
  }

  /// Extracts a list of json objects from the request.
  ///
  /// Throws [ApiException] if the request was not valid or extraction failed.
  Future<List<JsonMap>> _extractObjectListFromResponse(
      Response response) async {
    if (response.statusCode == null || response.statusCode! > 201) {
      throw ApiException.fromResponse(response);
    }

    List<JsonMap>? body;

    if (response.data is String) {
      response.data = await compute(
        (String j) => json.decode(j),
        response.data as String,
      );
    }

    if (response.data != null) {
      body = List.from(response.data).map((e) => JsonMap.from(e)).toList();
    }

    if (body == null ||
        body.isEmpty ||
        response.statusCode == HttpStatus.noContent) {
      return [];
    }

    return body;
  }

  /// Sends a post request with the supplied data.
  ///
  /// Returns the response data as a [String]
  ///
  /// Throws [ApiException] if unsuccessful.
  Future<T> _post<T>(String endpoint,
      {JsonMap? data, Map<String, String>? headers, T? sample}) async {
    assert(sample != null && (sample is JsonMap || sample is List<JsonMap>));

    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: headers),
      );

      return sample is JsonMap?
          ? await _extractObjectFromResponse(response) as T
          : await _extractObjectListFromResponse(response) as T;
    } on DioException catch (e) {
      // Unable to reach endpoint.
      print(e.stackTrace);
      print(e.requestOptions);
      throw ApiException(
          0, e.message ?? 'Internal error, request unsuccessful');
    }
  }

  /// Sends a get request with the supplied data.
  ///
  /// Returns the response data as a [String]
  ///
  /// Throws [ApiException] if unsuccessful.
  Future<T> _get<T>(
    String endpoint, {
    String? data,
    Map<String, String>? queryParameters,
    T? sample,
  }) async {
    assert(sample != null && (sample is JsonMap || sample is List<JsonMap>));

    try {
      final response = await _dio.get(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      return sample is JsonMap
          ? await _extractObjectFromResponse(response) as T
          : await _extractObjectListFromResponse(response) as T;
    } on DioException catch (e) {
      // Unable to reach endpoint.
      throw ApiException(
          0, e.message ?? 'Internal error, request unsuccessful');
    }
  }
}

class AcceptHeaderOptions extends Options {
  AcceptHeaderOptions() : super(headers: {'Accept': _applicationJson});
}

class AcceptContentTypeHeaderOptions extends Options {
  AcceptContentTypeHeaderOptions()
      : super(headers: {
          'Accept': _applicationJson,
          'Content-Type': _applicationJson,
        });
}

class ApiException implements Exception {
  ApiException(this.code, this.message);

  ApiException.fromResponse(Response response)
      : code = response.statusCode ?? HttpStatus.badRequest,
        message = response.statusMessage ?? '${response.data}';

  final int code;
  final String message;

  /// Error on client.
  bool get isInternal => code == 0;
}
