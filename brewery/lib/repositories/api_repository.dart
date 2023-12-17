import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:brewery/constants.dart';
import 'package:brewery/exceptions/exception.dart';
import 'package:brewery/gateways/local_storage_gateway.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';

abstract class ApiRepository {
  final String apiUrl;
  LocalStorageGateway localStorageGateway;

  ApiRepository({required this.apiUrl, required this.localStorageGateway});

  Future<Map> requestPost(Map input, String uri, [String? authToken]) async {
    var body = json.encode(input);

    try {
      final Response response = await http
          .post(Uri.parse(this.apiUrl + uri),
              headers: {
                HttpHeaders.contentTypeHeader:
                    "application/json; charset=UTF-8",
                "X-AUTH-TOKEN": authToken ?? "",
              },
              body: body)
          .timeout(const Duration(seconds: kRepositoryTimeout));

      return _parseResponse(response);
    } on TimeoutException catch (_) {
      throw Exception("A timeout occurred");
    } on SocketException catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<Map> requestGet(String uri, [String? authToken]) async {
    try {
      final Response response =
          await http.get(Uri.parse(this.apiUrl + uri), headers: {
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        "X-AUTH-TOKEN": authToken ?? "",
      }).timeout(const Duration(seconds: kRepositoryTimeout));

      return _parseResponse(response);
    } on TimeoutException catch (_) {
      throw Exception("A timeout occurred");
    } on SocketException catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<Map> requestDelete(Map input, String uri, [String? authToken]) async {
    var body = json.encode(input);

    try {
      final Response response = await http
          .delete(Uri.parse(this.apiUrl + uri),
              headers: {
                HttpHeaders.contentTypeHeader:
                    "application/json; charset=UTF-8",
                "X-AUTH-TOKEN": authToken ?? "",
              },
              body: body)
          .timeout(const Duration(seconds: kRepositoryTimeout));

      return _parseResponse(response);
    } on TimeoutException catch (_) {
      throw Exception("A timeout occurred");
    } on SocketException catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<Map> _parseResponse(Response response) async {
    if (response.statusCode == 200) {
      try {
        Map decoded = jsonDecode(response.body);
        return decoded;
      } on FormatException catch (error) {
        log('The provided string is not valid JSON');

        Sentry.captureException(
          error,
          hint:
              Hint.withMap({'error': 'The provided string is not valid JSON'}),
        );
      }
      throw ResponseException("Wystąpił błąd z połączeniem z serwerem (1)");
    } else if (response.statusCode == 204) {
      return Map();
    } else {
      Map decoded = {};
      try {
        decoded = jsonDecode(response.body);
        log(decoded.toString());
        Sentry.captureException(
          decoded.toString(),
          hint: Hint.withMap({'error': 'API response onError'}),
        );
      } catch (error) {
        log(error.toString());
        Sentry.captureException(
          error,
          hint: Hint.withMap({'error': 'Server onError'}),
        );
        throw ResponseException("Wystąpił błąd z połączeniem z serwerem (2)");
      }
      throw ResponseException(decoded.containsKey('error')
          ? decoded['error']['userMessage']
          : "Wystąpił błąd z połączeniem z serwerem (3)");
    }
  }
}
