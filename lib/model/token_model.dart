class Token {
  final String id;
  final String contractAddress;
  final String tokenName;
  final String symbol;
  final int divisor;
  final String tokenType;
  final int? totalSupply;
  final bool blueCheckmark;
  final String? description;
  final String imageUrl;

  Token(
      {required this.id,
      required this.contractAddress,
      required this.tokenName,
      required this.symbol,
      required this.divisor,
      required this.tokenType,
      this.totalSupply,
      required this.blueCheckmark,
      this.description,
      required this.imageUrl});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      id: json['id'],
      contractAddress: json['contractAddress'],
      tokenName: json['tokenName'],
      symbol: json['symbol'],
      divisor: json['divisor'],
      tokenType: json['tokenType'],
      totalSupply: json['totalSupply'],
      blueCheckmark: json['blueCheckmark'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}
