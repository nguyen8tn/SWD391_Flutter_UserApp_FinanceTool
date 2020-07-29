import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  var savingQuery = {
    'type': '1',
  };
  var loanQuery = {
    'type': '2',
  };
  SharedPreferences prefs;

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
    }).catchError((e) {
      print(e.toString());
    }).whenComplete(() {
      closeConnection();
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
        '/api/transactions/add-account', savingQuery);
    _ioClient = new IOClient(_httpClient);
    await _ioClient
        .post(uri, headers: headers, body: json.encode(account.toJson()))
        .then((value) {
      print('respone: ' + value.body);
      print('status code: ' + value.statusCode.toString());
      if (value.statusCode == 200 || value.statusCode == 201) {
        final body = jsonDecode(value.body);
        result = SavingAccount.fromJson(body);
      }
    }).catchError((e) {
      print(e.toString());
    }).whenComplete(() {
      closeConnection();
    });
    return result;
  }

  Future<LoanAccount> addLoanAccount(LoanAccount account) async {
    LoanAccount result;
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
        '/api/transactions/add-account', loanQuery);
    _ioClient = new IOClient(_httpClient);
    await _ioClient
        .post(uri, headers: headers, body: json.encode(account.toJson()))
        .then((value) {
      print('respone: ' + value.body);
      print('status code: ' + value.statusCode.toString());
      if (value.statusCode == 200 || value.statusCode == 201) {
        final body = jsonDecode(value.body);
        result = LoanAccount.fromJson(body);
      }
    }).catchError((e) {
      print(e.toString());
    }).whenComplete(() {
      closeConnection();
    });
    return result;
  }

  Future<SavingAccount> updateSavingAccount(SavingAccount savingAccount) async {
    SavingAccount result;
    _httpClient = HttpRequest().bypassSSL();
    if (HttpRequest.prefs != null) {
      print('asdasdsa' + HttpRequest.prefs.getString("apiToken"));
    }
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'applica tion/json',
      'Authorization': 'Bearer ' + HttpRequest.prefs.get("apiToken")
    };
    Uri uri = Uri.https(
        'financial-web-service.azurewebsites.net',
        '/api/transactions/update-account' + savingAccount.id.toString(),
        savingQuery);
    _ioClient = new IOClient(_httpClient);
    await _ioClient
        .put(uri, headers: headers, body: json.encode(savingAccount.toJson()))
        .then((value) {
      print('respone: ' + value.body);
      print('status code: ' + value.statusCode.toString());
      if (value.statusCode == 200 || value.statusCode == 204) {
        final body = jsonDecode(value.body);
        result = SavingAccount.fromJson(body);
      }
    }).catchError((e) {
      print(e.toString());
    }).whenComplete(() {
      closeConnection();
    });
    return result;
  }

  Future<LoanAccount> updateLoanAccount(LoanAccount loanAccount) async {
    LoanAccount result;
    _httpClient = HttpRequest().bypassSSL();
    if (HttpRequest.prefs != null) {
      print('asdasdsa' + HttpRequest.prefs.getString("apiToken"));
    }
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'applica tion/json',
      'Authorization': 'Bearer ' + HttpRequest.prefs.get("apiToken")
    };
    Uri uri = Uri.https(
        'financial-web-service.azurewebsites.net',
        '/api/transactions/update-account' + loanAccount.id.toString(),
        loanQuery);
    _ioClient = new IOClient(_httpClient);
    await _ioClient.delete(uri, headers: headers).then((value) {
      print(value.body);
      print(value.statusCode);
      if (value.statusCode == 200) {
        final body = jsonDecode(value.body);
        result = LoanAccount.fromJson(body);
      }
    }).catchError((e) {
      print(e.toString());
    }).whenComplete(() {
      closeConnection();
    });
    return result;
  }

  Future<List<SavingAccount>> getListSavingAccountByID() async {
    List<SavingAccount> result;
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('UID');
    var uri = Uri.https(
        'financial-web-service.azurewebsites.net',
        '/api/transactions/get-accounts-by-uid-type/' + id.toString(),
        savingQuery);
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

  Future<List<LoanAccount>> getListLoanAccountByID() async {
    List<LoanAccount> result;
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('UID');
    var uri = Uri.https(
        'financial-web-service.azurewebsites.net',
        '/api/transactions/get-accounts-by-uid-type/' + id.toString(),
        loanQuery);
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
      if (value.statusCode == 200 || value.statusCode == 201) {
        final body = jsonDecode(value.body);
        final Iterable json = body;
        result = json.map((e) => LoanAccount.fromJson(e)).toList();
      }
    }).catchError((e) {
      print(e.toString());
    }).whenComplete(() {
      closeConnection();
    });
    return result;
  }

  Future<SavingAccount> getSavingAccountByID(int id) async {
    SavingAccount result;
    var uri = Uri.https('financial-web-service.azurewebsites.net',
        '/api/transactions/get-accounts-by-id/' + id.toString(), savingQuery);
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

        result = SavingAccount.fromJson(body);
      }
    }).catchError((e) {
      print(e.toString());
    }).whenComplete(() {
      closeConnection();
    });
    return result;
  }

  Future<LoanAccount> getLoanAccountByID(int id) async {
    LoanAccount result;
    var uri = Uri.https('financial-web-service.azurewebsites.net',
        '/api/transactions/get-accounts-by-id/' + id.toString(), loanQuery);
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

        result = LoanAccount.fromJson(body);
      }
    }).catchError((e) {
      print(e.toString());
    }).whenComplete(() {
      closeConnection();
    });
    return result;
  }

  Future<bool> deleteAccountByID(int id, int type) async {
    var result = false;
    var uri = Uri.https(
        'financial-web-service.azurewebsites.net',
        '/api/transactions/delete-account/' + id.toString(),
        type == 1 ? savingQuery : loanQuery);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + HttpRequest.prefs.get("apiToken")
    };
    print(uri);
    _httpClient = HttpRequest().bypassSSL();
    IOClient ioClient = new IOClient(_httpClient);
    await ioClient.delete(uri, headers: headers).then((value) {
      print(value.body);
      print(value.statusCode);
      if (value.statusCode == 200 || value.statusCode == 204) {
        result = true;
      }
    }).catchError((e) {
      print(e.toString());
    }).whenComplete(() {
      closeConnection();
    });
    return result;
  }
}
