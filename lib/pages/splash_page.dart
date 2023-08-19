import 'package:crypto_bazar_application/data/constants/colors.dart';
import 'package:crypto_bazar_application/data/model/coin.dart';
import 'package:crypto_bazar_application/pages/data_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataFromAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: double.infinity),
            Image.asset('images/logo.png'),
            SizedBox(height: 16),
            SpinKitWave(
              color: kWhite,
              size: 35,
            ),
          ],
        ),
      ),
    );
  }

  _getDataFromAPI() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');

    List<Coin> coinList = response.data['data']
        .map<Coin>((jsonMapObject) => Coin.fromMapJson(jsonMapObject))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataPage(coinList: coinList),
      ),
    );
  }
}
