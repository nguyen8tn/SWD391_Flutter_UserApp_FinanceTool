import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:swd/models/user.dart';
import 'dart:convert';
import 'package:http/io_client.dart';

class HttpRequest {
  HttpClient _httpClient;
  IOClient _ioClient;

  Future<String> getUserDetails(User user) async {
    String userDetail = "";
    //var queryParameters = {'id': user.uid};
    Uri uri = Uri.https('10.0.2.2:5001', '/api/users/details');
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
}
