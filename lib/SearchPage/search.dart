import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:refresh_wall/ImageView/imageview.dart';
import 'package:refresh_wall/Model/PhotoModel.dart';
import 'package:refresh_wall/widget_list/search_widget.dart';
import 'package:refresh_wall/widget_list/wallpaper_widget.dart';

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
    searchController.text = widget.searchQuery;
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
}
