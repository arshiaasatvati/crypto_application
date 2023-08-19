class Coin {
  String id;
  int rank;
  String symbol;
  String name;
  double changePercent24Hr;
  double priceUsd;
  double marketCapUsd;

  Coin({
    required this.id,
    required this.rank,
    required this.symbol,
    required this.name,
    required this.changePercent24Hr,
    required this.priceUsd,
    required this.marketCapUsd,
  });

  factory Coin.fromMapJson(Map<String, dynamic> jsonMapObject) {
    return Coin(
      id: jsonMapObject['id'],
      rank: int.parse(jsonMapObject['rank']),
      symbol: jsonMapObject['symbol'],
      name: jsonMapObject['name'],
      changePercent24Hr: double.parse(jsonMapObject['changePercent24Hr']),
      priceUsd: double.parse(jsonMapObject['priceUsd']),
      marketCapUsd: double.parse(jsonMapObject['marketCapUsd']),
    );
  }
}
