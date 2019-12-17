import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'string/color.dart';
import 'detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_details/data/api_provider.dart';
import 'package:movie_details/model/popular_movies.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ApiProvider provider = ApiProvider();
  Future<PopularMovies> popularMovies;
  String baseUrlImage = 'https://image.tmdb.org/t/p/w500';

  @override
  void initState() {
    popularMovies = provider.getPopularMovies();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: putih,
        centerTitle: true,
        title:
            Text('Movies Trailer App', style: TextStyle(color: Colors.black)),
      ),
      body: FutureBuilder(
        future: popularMovies,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print('Has data: ${snapshot.hasData}');
            PopularMovies popular = snapshot.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 10, right: 10, left: 10),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                        labelText: 'Search Judul Movie',
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 200,
                    width: 400,
                    child: CarouselSlider(
                        autoPlay: true,
                        viewportFraction: 0.8,
                        items: List.generate(5, (index) {
                          return Container(
                            margin: EdgeInsets.only(left: 10, bottom: 20),
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl:
                                      '$baseUrlImage${popular.results[index].backdropPath.toString()}',
                                  fit: BoxFit.cover,
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    child: Text(
                                      (index + 1).toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    margin: EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: putih.withOpacity(0.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 150, right: 90),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: biru,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                  child: Container(
                                    child: Text(
                                      ('${popular.results[index].title.toString()}')
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: putih,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }))),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              'Sedang Tayang',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ))),
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Text('Selengkapnya >',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey))),
                  ],
                ),
                Container(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.results.length,
                    itemBuilder: (BuildContext context, int index) {
                      return moviesItem(
                          poster: '${snapshot.data.results[index].posterPath}',
                          title: '${snapshot.data.results[index].title}',
                          date: '${snapshot.data.results[index].releaseDate}',
                          voteAverage:
                              '${snapshot.data.results[index].voteAverage}',
                          index: index,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => MovieDetail(
                                movie: snapshot.data.results[index],
                              ),
                            ));
                          });
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    // Where the linear gradient begins and ends
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    colors: [
                      // Colors are easy thanks to Flutter's Colors class.
                      Colors.yellow[300],
                      Colors.yellow[900],
                    ],
                  )),
                  child: Container(
                    margin: EdgeInsets.only(left: 15),
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.card_giftcard,
                          size: 15,
                          color: putih,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            'BAGIKAN KODE & DAPATKAN POIN ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: putih),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            print('Has data: ${snapshot.hasError}');
            return Text('Error!!!');
          } else {
            print('Lagi loading....');
            return Center(child: SpinKitHourGlass(color: Colors.black));
          }
        },
      ),
    );
  }

  InkWell moviesItem(
      {String poster,
      String title,
      String date,
      String voteAverage,
      int index,
      Function onTap}) {
    String baseUrlImage = 'https://image.tmdb.org/t/p/w500';
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(5),
        width: 150,
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Container(
                height: 230,
                child: Stack(
                  children: <Widget>[
                    Container(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: '$baseUrlImage$poster',
                        imageBuilder: (context, imageProvider) => Container(
                          width: 150,
                          height: 360,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Container(
                          width: 25,
                          height: 25,
                          child: Center(
                            child: Icon(Icons.error),
                          ),
                        ),
                      ),
                    )),
                    index % 2 == 1 //if dalam container
                        ? Container(
                            child: Container(
                              child: Text(
                                ('PRE-SALE').toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              margin: EdgeInsets.all(6),
                              padding: EdgeInsets.all(3),
                              alignment: Alignment.center,
                              width: 80,
                              height: 20,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    // Where the linear gradient begins and ends
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    // Add one stop for each color. Stops should increase from 0 to 1
                                    colors: [
                                      // Colors are easy thanks to Flutter's Colors class.
                                      Colors.yellow[800],
                                      Colors.yellow[400],
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                          )
                        : Container(),
                    Container(
                      width: 150,
                      height: 50,
                      margin: EdgeInsets.only(top: 184),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: biru,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: Container(
                        child: Text(
                          ('Tonton Trailer').toString(),
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),

              child: Text(
                (title),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
