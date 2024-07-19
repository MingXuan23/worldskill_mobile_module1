import 'dart:io';

import 'package:worldskill_module1/model/event.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:worldskill_module1/model/ticket.dart';

class ApiService {
  static String baseurl = '10.200.96.165:8080';

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

  static Future<List<Ticket>> getTickets() async {
    try {
      //var url = Uri.http('${baseurl}events');
      //Uri.http(baseurl, 'events');
      var url =  Uri.http(baseurl, '/api/tickets');
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
        var events = jsonList['tickets'] as List;
        var list = events.map((e) => Ticket.fromJson(e)).toList();
        return list;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

   static Future<Ticket?> storeTicket(String type, String name, File image) async {
    try {
      //var url = Uri.http('${baseurl}events');
      //Uri.http(baseurl, 'events');
      var url =  Uri.http(baseurl, '/api/tickets/store');

      var request = http.MultipartRequest('POST', url);

      // Add text fields to the request
     // request.fields.addAll(ticket.toMap());
      request.fields['name'] = name;
      request.fields['type'] = type;


      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      // Send the request
      var response = await request.send();
      
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        var jsonList =
            convert.jsonDecode(respStr) as Map<String, dynamic>;
        //var t = jsonList['ticket'];
        var t =jsonList['ticket'] as Map<String,dynamic>;
        
        return Ticket.fromJson(t);
        
        
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

 static Future<int> deleteTicket(int id) async{
    try {
      //var url = Uri.http('${baseurl}events');
      //Uri.http(baseurl, 'events');
      var url =  Uri.http(baseurl, '/api/tickets/delete/$id');
      // Await the http get response, then decode the json-formatted response.
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },);

      return response.statusCode;
    } catch (e) {
      return 403;
    }
 }
  
}
