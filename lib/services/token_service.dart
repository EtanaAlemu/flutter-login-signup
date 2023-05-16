import 'dart:convert';

import 'package:login_and_register_with_api/model/token_model.dart';
import 'package:http/http.dart' as http;

class TokenService {
  Future<List<Token>> getTokens() async {
    final respose =
        await http.get(Uri.parse("http://localhost:10000/api/v1/tokens"));

    if (respose.statusCode == 200) {
      final data = jsonDecode(respose.body);
      final List<Token> tokens = [];

      for (var element in data['tokens']) {
        tokens.add(Token.fromJson(element));
      }

      return tokens;
    } else {
      throw Exception("getTokens failed");
    }
  }
}
