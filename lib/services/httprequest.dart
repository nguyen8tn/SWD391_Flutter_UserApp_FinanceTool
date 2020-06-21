import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:swd/models/bank.dart';
import 'package:swd/models/user.dart';
import 'dart:convert';
import 'package:http/io_client.dart';
import 'package:swd/services/auth.dart';

class HttpRequest {
  HttpClient _httpClient;
  IOClient _ioClient;

  Future<String> getUserDetails(User user) async {
    String userDetail = "";
    //var queryParameters = {'id': user.uid};
    Uri uri = Uri.https(
        'https://swd-financial-server.azurewebsites.net', '/api/users/details');
    String _url = "";
    print(Uri.decodeFull(uri.path));
    HttpClient httpClient = bypassSSL();
    //send request
    IOClient ioClient = new IOClient(httpClient);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + user.token
    };
    await ioClient
        .post(uri, headers: headers, body: json.encode(user.toJson()))
        .then((value) {
      print(value.body);
      print(value.statusCode);
      if (value.statusCode == 200) {
        userDetail = value.body;
      }
    }).catchError((e) {
      print(e.toString());
    }).whenComplete(() {
      closeConnection();
    });
    return userDetail;
//    final response = await http.get(
//      _url,
//      headers: {}
//    );
//    if (response.statusCode == 200) {
//      print(response.body);
//    } else {
//      print('A network error occurred');
//    }
    //print(responseJson.toString());
    //return User.fromJson(responseJson);
  }

  Future<List<Bank>> fetchBanks(String keyword) async {
    List<Bank> result;
    var queryParameters = {'MinDate': 'one', 'Page': '1', 'Limit': '10'};
    //var uri = Uri.https(
    //'https://swd-financial-server.azurewebsites.net/api/banks', '/api/v1/banks', queryParameters);
    var url = 'https://run.mocky.io/v3/6b591c7f-8a09-40fd-9f21-e1440020a47d';
    //print(Uri.decodeFull(uri.path));
    _httpClient = bypassSSL();
    IOClient ioClient = new IOClient(_httpClient);
    await ioClient.get(url).then((value) {
      print(value.body);
      print(value.statusCode);
      if (value.statusCode == 200) {
        final body = jsonDecode(value.body);
        final Iterable json = body["items"];
        result = json.map((bank) => Bank.fromJson(bank)).toList();
        result.removeWhere(
            (element) => !element.bankName.contains(keyword.toUpperCase()));
      }
    }).catchError((e) {
      print(e.toString());
    }).whenComplete(() {
      closeConnection();
    });
    return result;
  }

  void closeConnection() {
    if (_httpClient != null) {
      _httpClient.close(force: true);
    }
    if (_ioClient != null) {
      _ioClient.close();
    }
  }

  HttpClient bypassSSL() {
    bool trustSelfSigned = true;
    return new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);
  }

  Future<String> login(User user) async{
    String userDetails = "";
    //header
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + user.token
    };
    //ssl
    HttpClient httpClient = bypassSSL();
    //path
    Uri uri = Uri.https(
        '192.168.1.5:45455', '/api/auth/login');
    //send request
    IOClient ioClient = new IOClient(httpClient);
    await ioClient
        .post(uri, headers: headers, body: json.encode(user.toJson())).then((value) {
      print("statuscode: "+ value.statusCode.toString());
      if(value.statusCode == 200) {
        userDetails = value.body;
      }
    });
    return userDetails;
  }
}
