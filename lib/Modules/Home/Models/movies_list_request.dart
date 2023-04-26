
import 'dart:convert';

MoviesListRequest moviesListRequestFromJson(String str) => MoviesListRequest.fromJson(json.decode(str));

String moviesListRequestToJson(MoviesListRequest data) => json.encode(data.toJson());

class MoviesListRequest {
  MoviesListRequest({
    this.category,
    this.language,
    this.genre,
    this.sort,
  });

  String? category;
  String? language;
  String? genre;
  String? sort;

  factory MoviesListRequest.fromJson(Map<String, dynamic> json) => MoviesListRequest(
    category: json["category"],
    language: json["language"],
    genre: json["genre"],
    sort: json["sort"],
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "language": language,
    "genre": genre,
    "sort": sort,
  };
}
