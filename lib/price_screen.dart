import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

const kColor = Color(0xFF2444D4);

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: kColor,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickerItems,
    );
  }

  Map<String, String> coinValue = {};

  void getData() async {
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      setState(() {
        coinValue = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Tracker 🤑'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CryptoCard(
                cryptoCurrency: 'BTC',
                value: coinValue['BTC'],
                selectedCurrency: selectedCurrency,
                image: Image.asset(
                  'assets/images/btc.png',
                  width: 48,
                  height: 48,
                ),
              ),
              CryptoCard(
                cryptoCurrency: 'ETH',
                value: coinValue['ETH'],
                selectedCurrency: selectedCurrency,
                image: Image.asset('assets/images/eth.png'),
              ),
              CryptoCard(
                cryptoCurrency: 'BNB',
                value: coinValue['BNB'],
                selectedCurrency: selectedCurrency,
                image: Image.asset(
                  'assets/images/bnb.png',
                  width: 47.5,
                  height: 47.5,
                ),
              ),
            ],
          ),
          Container(
            height: 100.0,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            color: Color(0xFF2444D4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Choose a currency: ',style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(width: 5.0),
                Container(
                  child: Platform.isIOS ? iOSPicker() : androidDropdown(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    Key key,
    @required this.value,
    @required this.selectedCurrency,
    @required this.cryptoCurrency,
    @required this.image,
  }) : super(key: key);

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: kColor,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 17.5, horizontal: 30.0),
          child: Row(
            children: [
              image,
              SizedBox(width: 25.0),
              Text(
                '1 $cryptoCurrency = $value $selectedCurrency',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
