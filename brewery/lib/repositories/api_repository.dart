import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:brewery/gateways/local_storage_gateway.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

abstract class ApiRepository {
  final String apiUrl;
  LocalStorageGateway localStorageGateway;

  ApiRepository({@required this.apiUrl, @required this.localStorageGateway});

  Future<Map> requestPost(Map input, String uri, [String authToken]) async {
    var body = json.encode(input);

    final Response response = await http.post(Uri.parse(this.apiUrl + uri),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
          "X-AUTH-TOKEN": authToken ?? "",
        },
        body: body);
    return _parseResponse(response);
  }

  Future<Map> requestGet(String uri, [String authToken]) async {
    final Response response =
        await http.get(Uri.parse(this.apiUrl + uri), headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      "X-AUTH-TOKEN": authToken ?? "",
    });
    return _parseResponse(response);
  }

  Future<Map> _parseResponse(Response response) async {
    if (response.statusCode == 200) {
      Map decoded = jsonDecode(response.body);
      return decoded;
    } else if (response.statusCode == 204) {
      return null;
    } else {
      Map decoded = jsonDecode(response.body);
      print("_parseResponse ERROR");
      print(decoded);

      throw Exception(decoded.containsKey('error')
          ? decoded['error']['userMessage']
          : "General error");
    }
  }
}
