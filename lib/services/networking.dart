import 'package:http/http.dart' as http;
import 'dart:convert';
//https://rest.coinapi.io/v1/exchangerate/BTC/USD/?apikey=F25531FC-708F-49E6-B201-F0BB1F54135A
const coinapiURL = 'https://rest.coinapi.io/v1/exchangerate/';
const apiKey = 'F25531FC-708F-49E6-B201-F0BB1F54135A';

class NetworkHelper {


  Future<dynamic> getExchangeRate(String currency, String coinType) async {
    http.Response response = await http.get('$coinapiURL$coinType/$currency/?apikey=$apiKey');
    print('responce code: ${response.statusCode}');
    if (response.statusCode == 200) {
      var jsonResponse =  jsonDecode(response.body);
      print(jsonResponse['rate']);
      return jsonResponse['rate'];
    } else
      print('Error with responce code: ${response.statusCode}');
  }
}
