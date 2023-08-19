import 'package:crypto_bazar_application/data/constants/colors.dart';
import 'package:crypto_bazar_application/data/model/coin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DataPage extends StatefulWidget {
  DataPage({super.key, required this.coinList});
  List<Coin> coinList;

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<Coin>? coinList;
  bool isSerchLoadingVisible = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    coinList = widget.coinList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'کریپتو بازار',
          style: TextStyle(fontFamily: 'moraba'),
        ),
        elevation: 1,
        centerTitle: true,
        backgroundColor: kBlack,
      ),
      backgroundColor: kBlack,
      body: SafeArea(
          child: Column(
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextField(
              onChanged: (value) {
                _getSearchList(value);
              },
              cursorColor: kBlack,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: kGreen,
                  hintStyle: TextStyle(fontFamily: 'moraba'),
                  hintText: 'نام رمز ارز‌ : '),
            ),
          ),
          Visibility(
            visible: isSerchLoadingVisible,
            child: Text(
              '...در حال دریافت اطلاعات از سرور',
              style: TextStyle(color: kGreen, fontFamily: 'moraba'),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: kGreen,
              backgroundColor: kBlack,
              onRefresh: () async {
                List<Coin> refreshedData = await _getDataFromAPI();

                setState(() {
                  coinList = refreshedData;
                });
              },
              child: ListView.builder(
                itemBuilder: (context, index) =>
                    _getCoinListTile(coinList![index]),
                itemCount: coinList!.length,
              ),
            ),
          ),
        ],
      )),
    );
  }

  _getCoinListTile(Coin coin) {
    return ListTile(
      title: Text(
        coin.name,
        style: TextStyle(color: kGreen.withOpacity(.7)),
      ),
      subtitle: Text(
        coin.symbol,
        style: TextStyle(color: kGrey),
      ),
      leading: SizedBox(
        width: 25,
        child: Center(
          child: Text(
            coin.rank.toString(),
            style: TextStyle(color: kGrey),
          ),
        ),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    coin.priceUsd.toStringAsFixed(2),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: kGrey,
                    ),
                  ),
                  Text(
                    coin.changePercent24Hr.toStringAsFixed(2) + '%',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: _getChangePercentColor(coin.changePercent24Hr)),
                  )
                ],
              ),
              SizedBox(width: 16),
              SizedBox(
                height: 50,
                child: Center(
                  child: _getChangePercentIcon(coin.changePercent24Hr),
                ),
              ),
            ]),
      ),
    );
  }

  _getChangePercentIcon(double percentage) {
    return percentage < 0
        ? Icon(
            Icons.trending_down,
            color: kRed,
          )
        : Icon(
            Icons.trending_up,
            color: kGreen,
          );
  }

  _getChangePercentColor(double percentage) {
    return percentage < 0 ? kRed : kGreen;
  }

  Future<List<Coin>> _getDataFromAPI() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');

    List<Coin> coinList = response.data['data']
        .map<Coin>((jsonMapObject) => Coin.fromMapJson(jsonMapObject))
        .toList();
    return coinList;
  }

  Future<void> _getSearchList(String value) async {
    if (value.isEmpty) {
      setState(() {
        isSerchLoadingVisible = true;
      });
      var result = await _getDataFromAPI();
      setState(() {
        coinList = result;
        isSerchLoadingVisible = false;
      });
      return;
    }
    List<Coin> coinSearchResult = [];
    coinSearchResult = coinList!
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();

    setState(() {
      coinList = coinSearchResult;
    });
  }
}
