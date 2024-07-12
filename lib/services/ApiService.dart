import 'package:worldskill_module1/model/event.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class ApiService {
  static String baseurl = '10.131.75.20:8080';

  static Future<List<Event>> getEvents() async {
    try {
      //var url = Uri.http('${baseurl}events');
      //Uri.http(baseurl, 'events');
      var url =  Uri.http(baseurl, '/api/events');
      // Await the http get response, then decode the json-formatted response.
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        var jsonList =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        var events = jsonList['events'] as List;
        var list = events.map((e) => Event.fromJson(e)).toList();
        return list;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<int> updateEvent(Event event) async {
    try {
      //var url = Uri.http('${baseurl}events');
      //Uri.http(baseurl, 'events');
      String status = 'Read';
      var url =  Uri.http(baseurl, '/api/events/updateStatus/${event.id}/${status}');
      // Await the http get response, then decode the json-formatted response.
      var response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        return response.statusCode ;
      }
    } catch (e) {
      return 400;
    }
  }
}
