import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:worldskill_module1/model/photo.dart';


class ApiM2{
  static String base_url =  '10.131.75.20:8080';

  static Future<int> getPhotoPagination(int limit) async{
      try{
        String url = '/api/m2/getPhotoPagination/$limit';
        Uri uri = Uri.http(base_url,url);
        var response = await http.get(uri);

        if(response.statusCode == 200){
            var page = jsonDecode(response.body)['pages'] as int;
            return page;
        }
        return 9;

      }catch(e){
        return 9;
      }
  }

  static Future<List<Photo>> getPhoto(dynamic limit,dynamic offset) async{
       try{
        String url = '/api/m2/getPhotos';
       Map<String, dynamic> query = {'limit': limit.toString(), 'offset': offset.toString()};
        Uri uri = Uri.http(base_url,url,query);
        var response = await http.get(uri);

        if(response.statusCode == 200){
            var list = jsonDecode(response.body)['photos'] as List;
            var photo = list.map((e)=> Photo.fromJson(e)).toList();
            return photo;
        }
        return [];

      }catch(e){
        return [];
      }
  }
}