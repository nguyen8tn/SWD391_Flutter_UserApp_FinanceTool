import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:swd/models/LoanAccount.dart';
import 'package:swd/models/SavingAccount.dart';
import 'package:swd/models/Caculation.dart';

import 'httprequest.dart';

class HttpRequestC {
  HttpClient _httpClient;
  IOClient _ioClient;
  void closeConnection() {
    if (_httpClient != null) {
      _httpClient.close(force: true);
    }
    if (_ioClient != null) {
      _ioClient.close();
    }
  }

  Future<List<BaseFormula>> getAllBaseFormula() async {
    List<BaseFormula> result;
    _httpClient = HttpRequest().bypassSSL();
    Uri uri =
        Uri.https('financial-web-service.azurewebsites.net', '/api/auth/login');
    _ioClient = new IOClient(_httpClient);
    await _ioClient.get(uri).then((value) {
      print("statuscode: " + value.statusCode.toString());
      if (value.statusCode == 200) {
        final body = jsonDecode(value.body);
        final Iterable json = body["values"];
        result = json.map((bank) => BaseFormula.fromJson(bank)).toList();
        return result;
      }
    });
    return null;
  }

  Future<SavingAccount> addSavingAccount(SavingAccount account) async {
    SavingAccount result;
    _httpClient = HttpRequest().bypassSSL();
    if (HttpRequest.prefs != null) {
      print('Token: ' + HttpRequest.prefs.getString("apiToken"));
    }
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + HttpRequest.prefs.get("apiToken")
    };
    Uri uri = Uri.https('financial-web-service.azurewebsites.net',
        '/api/transactions/add-saving-account');
    _ioClient = new IOClient(_httpClient);
    await _ioClient
        .post(uri, headers: headers, body: json.encode(account.toJson()))
        .then((value) {
      print('respone: ' + value.body);
      print('status code: ' + value.statusCode.toString());
      if (value.statusCode == 200) {
        final body = jsonDecode(value.body);
        return SavingAccount.fromJson(body);
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  Future<String> deleteSavingAccount() async {
    _httpClient = HttpRequest().bypassSSL();
    if (HttpRequest.prefs != null) {
      print('asdasdsa' + HttpRequest.prefs.getString("apiToken"));
    }
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + HttpRequest.prefs.get("apiToken")
    };
    Uri uri = Uri.https('financial-web-service.azurewebsites.net',
        '/api/transactions/delete-saving-account');
    _ioClient = new IOClient(_httpClient);
    await _ioClient.delete(uri, headers: headers).then((value) {
      if (value.statusCode == 200) {
        final body = jsonDecode(value.body);
        final Iterable json = body["values"];
      }
    });
  }

  Future<String> updateSavingAccount() async {
    _httpClient = HttpRequest().bypassSSL();
    if (HttpRequest.prefs != null) {
      print('asdasdsa' + HttpRequest.prefs.getString("apiToken"));
    }
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'applica tion/json',
      'Authorization': 'Bearer ' + HttpRequest.prefs.get("apiToken")
    };
    Uri uri = Uri.https('financial-web-service.azurewebsites.net',
        '/api/transactions/update-saving-account');
    _ioClient = new IOClient(_httpClient);
    await _ioClient.delete(uri, headers: headers).then((value) {
      if (value.statusCode == 200) {
        final body = jsonDecode(value.body);
        final Iterable json = body["values"];
      }
    });
  }

  Future<SavingAccount> addLoanAccount(SavingAccount account) async {
    SavingAccount result;
    _httpClient = HttpRequest().bypassSSL();
    if (HttpRequest.prefs != null) {
      print('asdasdsa' + HttpRequest.prefs.getString("apiToken"));
    }
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + HttpRequest.prefs.get("apiToken")
    };
    Uri uri = Uri.https('financial-web-service.azurewebsites.net',
        '/api/transactions/add-loan-account');
    _ioClient = new IOClient(_httpClient);
    await _ioClient.post(uri, headers: headers).then((value) {
      if (value.statusCode == 200) {
        final body = jsonDecode(value.body);
        result = body.map((e) => LoanAccount.fromJson(e)).toList();
      }
    });
  }

  Future<List<SavingAccount>> getListSavingAccountByID(String id) async {
    List<SavingAccount> result;
    var uri = Uri.https('financial-web-service.azurewebsites.net',
        '/api/transactions/get-saving-accounts/' + id.toString());
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + HttpRequest.prefs.get("apiToken")
    };
    print(uri);
    _httpClient = HttpRequest().bypassSSL();
    IOClient ioClient = new IOClient(_httpClient);
    await ioClient.get(uri, headers: headers).then((value) {
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
}
