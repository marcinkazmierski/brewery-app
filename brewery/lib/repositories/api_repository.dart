import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:brewery/constants.dart';
import 'package:brewery/exceptions/exception.dart';
import 'package:brewery/gateways/local_storage_gateway.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

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
      Map decoded = jsonDecode(response.body);
      return decoded;
    } else if (response.statusCode == 204) {
      return Map();
    } else {
      Map decoded = jsonDecode(response.body);
      log(decoded.toString());
      throw ResponseException(decoded.containsKey('error')
          ? decoded['error']['userMessage']
          : "General error");
    }
  }
}
