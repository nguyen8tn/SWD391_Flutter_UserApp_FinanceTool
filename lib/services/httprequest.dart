import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:swd/models/SavingAccount.dart';

import 'package:swd/models/Bank.dart';
import 'package:swd/models/Caculation.dart';
import 'package:swd/models/Operand.dart';
import 'package:swd/models/User.dart';
import 'dart:convert';
import 'package:http/io_client.dart';
import 'package:swd/services/auth.dart';

class HttpRequest {
  HttpClient _httpClient;
  IOClient _ioClient;
  static SharedPreferences prefs;
  final prefix = 'financial-web-service.azurewebsites.net';

  Future<String> getUserDetails(User user) async {
    String userDetail = "";
    //var queryParameters = {'id': user.uid};
    Uri uri = Uri.https(
        'financial-web-service.azurewebsites.net/', '/api/users/details');
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
    var uri = Uri.https('financial-web-service.azurewebsites.net', '/api/banks',
        queryParameters);

    print(Uri.decodeFull(uri.path));
    _httpClient = bypassSSL();
    IOClient ioClient = new IOClient(_httpClient);
    await ioClient.get(uri).then((value) {
      print(value.body);
      print(value.statusCode);
      if (value.statusCode == 200) {
        final body = jsonDecode(value.body);
        final Iterable json = body[""];
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

  Future<String> login(User user) async {
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
    Uri uri =
        Uri.https('financial-web-service.azurewebsites.net', '/api/auth/login');
    //send request
    IOClient ioClient = new IOClient(httpClient);
    await ioClient
        .post(uri, headers: headers, body: json.encode(user.toJson()))
        .then((value) {
      print("statuscode: " + value.statusCode.toString());
      if (value.statusCode == 200) {
        userDetails = value.body;
        final res = jsonDecode(value.body);
        userDetails = res['jwtString'];
      }
    });
    prefs = await SharedPreferences.getInstance();
    prefs.setString('apiToken', userDetails);
    prefs.setString('uid', user.id);
    return userDetails;
  }

  Future<BankDetail> getBankDetail(String keyword) async {
    BankDetail result;

    var uri = Uri.https(
      'financial-web-service.azurewebsites.net',
      '/api/banks/' + keyword,
    );

    print(Uri.decodeFull(uri.path));
    _httpClient = bypassSSL();
    IOClient ioClient = new IOClient(_httpClient);
    await ioClient.get(uri).then((value) {
      print(value.body);
      print(value.statusCode);
      if (value.statusCode == 200) {
        final body = jsonDecode(value.body);
        result = BankDetail.fromJson(body);
      }
    }).catchError((e) {
      print(e.toString());
    }).whenComplete(() {
      closeConnection();
    });
    return result;
  }

  Future<List<BaseFormula>> getBaseFormula() async {
    List<BaseFormula> result;
    var uri = Uri.https('financial-web-service.azurewebsites.net',
        '/api/caculation/get-all-base-formula');

    print(uri);
    _httpClient = bypassSSL();
    IOClient ioClient = new IOClient(_httpClient);
    await ioClient.get(uri).then((value) {
      print(value.body);
      print(value.statusCode);
      if (value.statusCode == 200) {
        final body = jsonDecode(value.body);
        final Iterable json = body;
        result = json.map((e) => BaseFormula.fromJson(e)).toList();
      }
    }).catchError((e) {
      print(e.toString());
    }).whenComplete(() {
      closeConnection();
    });
    return result;
  }

  Future<List<Operand>> getListOperantByID(int id) async {
    List<Operand> result;
    var uri = Uri.https(
        prefix,
        '/api/caculation/push-user-input-operand-by-base-formula/' +
            id.toString());

    print(uri);
    _httpClient = bypassSSL();
    IOClient ioClient = new IOClient(_httpClient);
    await ioClient.get(uri).then((value) {
      print(value.body);
      print(value.statusCode);
      if (value.statusCode == 200) {
        final body = jsonDecode(value.body);
        final Iterable json = body;
        result = json.map((e) => Operand.fromJson(e)).toList();
      }
    }).catchError((e) {
      print(e.toString());
    }).whenComplete(() {
      closeConnection();
    });
    return result;
  }

  //Saving Accounts
  Future<List<SavingAccount>> getListSavingAccount(int id) async {
    List<SavingAccount> result;
    var uri = Uri.https(
        prefix, '/api/transactions/get-saving-accounts/' + id.toString());

    print(uri);
    _httpClient = bypassSSL();
    IOClient ioClient = new IOClient(_httpClient);
    await ioClient.get(uri).then((value) {
      print(value.body);
      print(value.statusCode);
      if (value.statusCode == 200) {
        final body = jsonDecode(value.body);
        final Iterable json = body;
        result = json.map((e) => SavingAccount.fromJson(e)).toList();
      }
    }).catchError((e) {
      print(e.toString());
    }).whenComplete(() {
      closeConnection();
    });
    return result;
  }

  Future<SavingAccount> addSavingAccount(
      SavingAccount savingAccount, String token) async {
    SavingAccount result;
    Uri uri = Uri.https(prefix, '/api/transactions/add-saving-account/');
    String _url = "";
    print(Uri.decodeFull(uri.path));
    HttpClient httpClient = bypassSSL();
    //send request
    IOClient ioClient = new IOClient(httpClient);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    await ioClient
        .post(uri, headers: headers, body: json.encode(savingAccount.toJson()))
        .then((value) {
      print(value.body);
      print(value.statusCode);
      if (value.statusCode == 200) {
        final json = jsonDecode(value.body);

        result = SavingAccount.fromJson(json);
      }
    }).catchError((e) {
      print(e.toString());
    }).whenComplete(() {
      closeConnection();
    });
    return result;
  }
}
