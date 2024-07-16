import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Ticket {
  final int id;
  final DateTime created_at;
  final DateTime updated_at;
  final String type;
  final String seat;
  final String name;
  final String image;

  Ticket(
      {required this.id,
      required this.created_at,
      required this.updated_at,
      required this.type,
      required this.seat,
      required this.name,
      required this.image});

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
        id: json['id'] ?? 0,
        created_at: DateTime.parse(json['created_at']),
        updated_at: DateTime.parse(json['updated_at']),
        type: json['type'] ?? '',
        seat: json['seat'] ?? '',
        name: json['name'] ?? '',
        image: json['image'] ?? '');
  }

  static Future<void> storePosition(List<Ticket> ticketlist) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<int> postion = ticketlist.map((e) => e.id).toList();
    String ticketPosition = jsonEncode(postion);

    pref.setString('ticketPostion', ticketPosition);

  }

 static Future<List<int>> getPosition() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    
    String postionString = pref.getString('ticketPostion')??'[]';

    var postion = jsonDecode(postionString) as List;
    List<int> final_postion = postion.map((e) => e as int).toList();
    return final_postion;

  }

  Map<String,String> toMap(){
    return {
      'type' : type,
      'name' :name
    };
  }

}
