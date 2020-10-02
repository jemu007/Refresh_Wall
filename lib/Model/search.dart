import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:refresh_wall/Model/PhotoModel.dart';
import 'package:refresh_wall/Model/imageview.dart';

class SearchPage extends StatefulWidget {
  String searchQuery;
  SearchPage({this.searchQuery});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<PhotosModel> photos = new List();
  getTrendingWallpaper(String query) async {
    var responce = await http.get(
        "https://api.pexels.com/v1/search?query=$query&per_page=10&page=1",
        headers: {
          "Authorization":
              "563492ad6f917000010000010664c71aac704ff58853c07ad5991753"
        });
    Map<String, dynamic> jsonData = jsonDecode(responce.body);
    jsonData["photos"].forEach((element) {
      // print(element);
      var photoobj = PhotosModel();
      photoobj = PhotosModel.fromMap(element);
      photos.add(photoobj);
      print(element);
    });
    setState(() {});
  }

  @override
  void initState() {
    getTrendingWallpaper(widget.searchQuery);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Refresh")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          searchBar(),
          SizedBox(
            height: 10,
          ),
          Expanded(child: wallpaperList(photos: photos, context: context)),
        ],
      ),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[300],
        ),
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search",
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.search,
                color: Color(0xffFF08C5),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget wallpaperList({List<PhotosModel> photos, context}) {
    return GridView.builder(
        // controller: scrollController,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 16),
        physics: ClampingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 6.0,
          mainAxisSpacing: 6.0,
        ),
        itemCount: photos.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return GridTile(
              child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageView(
                            imgUrl: photos[index].src.portrait,
                          )));
            },
            child: Hero(
              tag: photos[index].src.portrait,
              child: Container(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        photos[index].src.portrait,
                        fit: BoxFit.cover,
                      ))),
            ),
          ));
        });
  }
}
