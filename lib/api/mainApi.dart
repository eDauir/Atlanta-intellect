import 'dart:convert';
import 'package:http/http.dart' as http;

final String url = '78.40.108.112';
final String path = 'digway/backend/main.php';

class Api {
  final String baseUrl = '78.40.108.112';
  final String path = 'digway/backend/main.php';

  Api();

  getData<T>(
      {required Map<String, String?> params,
      String? url,
      String? path,
      T Function(Map<String, dynamic>)? fromJson}) async {
    final uri = Uri.http(url ?? this.baseUrl, path ?? this.path, params);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      if (fromJson == null) return json.decode(response.body);

      // var data = json.decode(response.body);

      // if(data.runtimeType == List) {
      //   return  data.map((el) {
      //     return  fromJson(el);
      //   }).toList();
      // }else {
      //   return fromJson(data);
      // }

      List data = json.decode(response.body).runtimeType != List
          ? [json.decode(response.body)]
          : json.decode(response.body);
      return data.map((el) {
        return fromJson(el);
      }).toList();
    }
    return null;
  }
}


// getExpert2() async {
//   List<Expert> data  = await Api().getData<Expert>(params: {
//     'type': 'user',
//     'subType': 'getWorkers',
//   }, fromJson: Expert.fromJson);
//   print(data.runtimeType);
//   print(data);
//   return data;
// }
