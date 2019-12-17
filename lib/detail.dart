import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_video_player/flutter_simple_video_player.dart';
import 'package:movie_details/model/detail_movies.dart';
import 'package:video_player/video_player.dart';

import 'detail.dart';
import 'home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_details/data/api_provider.dart';
import 'package:movie_details/model/popular_movies.dart';
import 'package:movie_details/model/trailer_movies.dart';
import 'package:flutter/src/material/flat_button.dart';
import 'package:youtube_player/youtube_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MovieDetail extends StatefulWidget {
  final Popular movie;

  const MovieDetail({Key key, this.movie}) : super(key: key);

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  ApiProvider provider = ApiProvider();
  Future<TrailerMovies> trailerMovies;
  Future<DetailMovies> detailMovies;

  @override
  void initState() {
    trailerMovies = provider.getTrailerMovies(widget.movie.id.toString());
    detailMovies = provider.getDetailMovies(widget.movie.id.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: FutureBuilder(
        future: detailMovies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DetailMovies detail = snapshot.data;
            String baseUrlImage = 'https://image.tmdb.org/t/p/w500';

            return Column(
              children: <Widget>[
                Container(
                  child: CachedNetworkImage(
                    imageUrl: '$baseUrlImage${detail.backdropPath.toString()}',
                  ),
                ),

                Container(
                  width: double.infinity,
                    margin: EdgeInsets.only(left: 20, top: 20),
                    child: Text(
                      'Description : ',
                      style: TextStyle(fontWeight: FontWeight.bold),

                    )),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text('${detail.overview.toString()}',textAlign: TextAlign.justify),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text('TRAILER',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Container(
                    child: FutureBuilder(
                      future: trailerMovies,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          TrailerMovies trailer = snapshot.data;
                          print('DATA TRAILER ${trailer.id.toString()}');
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: trailer.results.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(top: 20, left: 10),
                                height: 60,
//                                decoration: new BoxDecoration(
//                                    boxShadow: [
//                                      BoxShadow(
//                                        color: Colors.black,
//                                        blurRadius: 12.0, // has the effect of softening the shadow
//                                        spreadRadius: 0.1, // has the effect of extending the shadow
//                                        offset: Offset(
//                                          0.01, // horizontal, move right 10
//                                          0.01, // vertical, move down 10
//                                        ),
//                                      )
//                                    ],
//                                ),
                                child: Card(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                              '${trailer.results[index].name.toString()}',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: RaisedButton.icon(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) => FunkyOverlay(
                                                    trailer:
                                                        trailer.results[index]),
                                              );
                                            },
                                            icon: Icon(Icons.play_arrow),
                                            label: Text("Play!")),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          print('Has Data : ${snapshot.hasData}');
                          return Text('Error!!!!');
                        } else {
                          print('Lagi Loading...');
                          return Center(
                              child: SpinKitHourGlass(color: Colors.black));
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            print('Has Data : ${snapshot.hasData}');
            return Text('Error!!!!');
          } else {
            print('Lagi Loading...');
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SpinKitHourGlass(color: Colors.black),
                Text('Loading...!')
              ],
            );
          }
        },
      ),
    );
  }
}

class FunkyOverlay extends StatefulWidget {
  final Trailer trailer;

  const FunkyOverlay({Key key, this.trailer}) : super(key: key);
  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            child: YoutubePlayer(
              context: context,
              source: widget.trailer.key,
              quality: YoutubeQuality.HD,
            ),
          ),
        ),
      ),
    );
  }
}
