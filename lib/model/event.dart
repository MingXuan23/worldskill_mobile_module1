import 'package:shared_preferences/shared_preferences.dart';

class Event {
  final int id;
  final DateTime created_at;
  final DateTime updated_at;
  final String title;
  final String desc;
  final String status;

  Future<int> updateCount() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var count = pref.getInt('event-${id}');
    count = count??0;
    count ++;
    pref.setInt('event-${id}', count);
    return count;
      
  }


  List<String> image = [];

  Event(
      {required this.id,
      required this.created_at,
      required this.updated_at,
      required this.title,
      required this.desc,
      required this.status});

  factory Event.fromJson(Map<String, dynamic> json) {
    Event e =  Event(
        id: json['id'] ?? 0,
        created_at: DateTime.parse(json['created_at']),
        updated_at: DateTime.parse(json['updated_at']),
        title: json['title'] ?? '',
        desc: json['desc'] ?? '',
        status: json['status'] ?? '');

    e.image = ['${e.id}-1.png','${e.id}-2.png','${e.id}-3.png'];
    return e;
  }
}
