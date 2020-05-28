import 'package:bitcoin_ticker/services/networking.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'INR';
  double bRate;
  double lRate;
  double eRate;
  NetworkHelper networkHelper = NetworkHelper();

  void updateUI() async {
    bRate = await networkHelper.getExchangeRate(selectedCurrency, 'BTC');
    eRate = await networkHelper.getExchangeRate(selectedCurrency, 'ETH');
    lRate = await networkHelper.getExchangeRate(selectedCurrency, 'LTC');

    print(bRate);
    print(eRate);
    print(lRate);
  }

  @override
  void initState() {
    super.initState();
    print('called init state');
    updateUI();
    print('init values:');
  }

  /*
  Funtion to get the material style dropDownButton
  */
  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(child: Text(currency), value: currency);
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (newValue) {
        setState(() {
          selectedCurrency = newValue;
          updateUI();
        });
      },
    );
  }

  //funtion to get the IOS style picker
  CupertinoPicker IOSPicker() {
    List<Widget> pickerItems = [];
    for (String currency in currenciesList) {
      Widget newItem = Text(currency);
      pickerItems.add(newItem);
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          updateUI();
        });
      },
      children: pickerItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ReusableCard(
                coinType: 'BTC',
                currency: selectedCurrency,
                rate: bRate,
              ),
              ReusableCard(
                coinType: 'ETH',
                currency: selectedCurrency,
                rate: eRate,
              ),
              ReusableCard(
                coinType: 'LTC',
                currency: selectedCurrency,
                rate: lRate,
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? IOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class ReusableCard extends StatelessWidget {
  final String coinType;
  final double rate;
  final String currency;

  ReusableCard(
      {@required this.coinType, @required this.currency, @required this.rate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $coinType = ${rate.toStringAsFixed(2)} $currency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
