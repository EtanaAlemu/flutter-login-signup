import 'package:flutter/material.dart';
import 'package:login_and_register_with_api/model/token_model.dart';
import 'package:login_and_register_with_api/services/token_service.dart';
import 'package:login_and_register_with_api/utils/secure_storage.dart';

class TokenPage extends StatefulWidget {
  const TokenPage({super.key});

  @override
  State<TokenPage> createState() => _TokenPageState();
}

class _TokenPageState extends State<TokenPage> {
  late Future<List<Token>> futureTokens;
  String token = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureTokens = TokenService().getTokens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tokens"),
        ),
        body: Center(
          child: FutureBuilder<List<Token>>(
            future: futureTokens,
            builder: ((context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                    itemBuilder: (context, index) {
                      Token token = snapshot.data?[index];
                      return ListTile(
                        title: Text(token.tokenName),
                        subtitle: Text(token.symbol),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(color: Colors.black26);
                    },
                    itemCount: snapshot.data!.length);
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              return CircularProgressIndicator();
            }),
          ),
        ));
  }
}
