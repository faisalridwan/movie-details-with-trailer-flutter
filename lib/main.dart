import 'package:flutter/material.dart';
import 'detail.dart';
import 'home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_details/data/api_provider.dart';
import 'package:movie_details/model/popular_movies.dart';

void main() => runApp(MoviewApp());

class MoviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies Trailer App',
      theme: ThemeData(
        primarySwatch: Colors.white,
      ),
      home: Home(),
    );
  }
}
