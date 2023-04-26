import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/app_log.dart';
import '../Models/movies_list_request.dart';
import '../Models/movies_list_response.dart';


class HomeRepository{
  Future<MoviesListResponse> moviesList(MoviesListRequest request)async{
    http.Response response = await http.post(Uri.parse("https://hoblist.com/api/movieList"),body: request.toJson());
    if (kDebugMode) {
      print("statusCode::${response.statusCode}");
    }
    if (response.statusCode == 200){
      AppLog.d("Movies List Response::${response.body}");
      var result = jsonDecode(response.body);

      return MoviesListResponse.fromJson(result);
    }else{
      throw Exception(response.reasonPhrase);
    }

  }
}
