import 'dart:convert';
import 'package:http/http.dart' as http;


String apiUrl = 'http://172.105.154.202:8000/api';

class API {
  postRequest({
    required String route,
    required Map<String, String> data,
  }) async {
    String url = apiUrl + route;
    try {
      return await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: _header(),
      );
    } catch (e) {
      print(e.toString());
      return jsonEncode(e);
    }
  }

  _header() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
}