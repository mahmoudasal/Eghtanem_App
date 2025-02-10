// import 'dart:io';
// import 'dart:convert';
// class HttpService {
//   Future<dynamic> sendRequestToServer(dynamic model, String                         reqType, bool isTokenHeader, String token) async {
//       HttpClient client = new HttpClient();
//       client.badCertificateCallback =((X509Certificate cert, String  host, int port) => true);
//       HttpClientRequest request = await         client.postUrl(Uri.parse("https://${serverConstants.serverUrl}$reqType"));
//       request.headers.set('Content-Type', 'application/json');
//       if(isTokenHeader){
//          request.headers.set('Authorization', 'Bearer $token');
//       }
//      request.add(utf8.encode(jsonEncode(model)));
//      HttpClientResponse result = await request.close();
//      if(result.statusCode == 200) {
//         return jsonDecode(await result.transform(utf8.decoder)
//         .join());
//      } else {
//         return null;
//      }
//    }
// }
