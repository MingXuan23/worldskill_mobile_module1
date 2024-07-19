import 'package:flutter/foundation.dart';

class Photo {
  final int id;
  final int view;
  final String link;
  final int popularity;

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
        id: json['id'] ?? 0,
        view: json['view'] ?? 0,
        link: json['link'] ?? '',
        popularity: json['popularity'] ?? 0);
  }
  
  Photo(
      {required this.id,
      required this.view,
      required this.link,
      required this.popularity});
}
