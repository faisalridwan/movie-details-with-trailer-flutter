import 'dart:convert';

import 'package:movie_details/model/popular_movies.dart';
import 'package:http/http.dart';
import 'package:movie_details/model/trailer_movies.dart';
import 'package:movie_details/model/detail_movies.dart';

class ApiProvider {
  String apiKey = '53bbdac0b5726fa4d6c61ad08b94dce6';
  String baseUrl = 'https://api.themoviedb.org/3';

  Client client = Client();

  Future<PopularMovies> getPopularMovies() async {
    Response response =
        await client.get('$baseUrl/movie/popular?api_key=$apiKey');

    if (response.statusCode == 200) {
      return PopularMovies.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<TrailerMovies> getTrailerMovies(String id) async {
    Response response =
        await client.get('$baseUrl/movie/$id/videos?api_key=$apiKey');

    if (response.statusCode == 200) {
      return TrailerMovies.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<DetailMovies> getDetailMovies(String id) async {
    Response response = await client.get('$baseUrl/movie/$id?api_key=$apiKey');

    if (response.statusCode == 200) {
      return DetailMovies.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.statusCode);
    }
  }
}
