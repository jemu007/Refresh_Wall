import 'package:flutter/material.dart';
import 'package:refresh_wall/API/api.dart';
import 'package:refresh_wall/ImageView/imageview.dart';
// import 'package:refresh_wall/ImageView/imageview.dart';
import 'package:refresh_wall/Model/PhotoModel.dart';
// import 'package:refresh_wall/widget_list/search_widget.dart';
// import 'package:refresh_wall/widget_list/wallpaper_widget.dart';

class SearchPage extends StatefulWidget {
  String searchQuery;
  SearchPage({this.searchQuery});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<PhotosModel> photos = new List();
  ScrollController scrollController = ScrollController();

  bool isPageAvailable = true;
  bool isLoading = false;
  // String query;

  var api = API();
  int pagenumber = 0;

  Future getmoreData(int pageNumber) async {
    if (isPageAvailable) {
      if (isLoading) {
        return;
      }

      setState(() {
        isLoading = true;
      });

      var list =
          await api.getTrendingWallpaper(10, pageNumber, widget.searchQuery);
      photos.addAll(list);
      setState(() {
        isLoading = false;
      });
    }
    print("hellooo");
    return await Future.delayed(Duration(milliseconds: 1));
  }

  @override
  void initState() {
    getmoreData(pagenumber++);

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        getmoreData(pagenumber++);
      }
    });
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
              onTap: () {
                // getTrendingWallpaper(searchController.text);
              },
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

  Widget wallpaperList({List<PhotosModel> photos, context}) =>
      photos.length != 0
          ? RefreshIndicator(
              child: GridView.builder(
                  controller: scrollController,
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
                  }),
              onRefresh: () async {
                photos.clear();
                await getmoreData(0);
              },
            )
          : Center(child: CircularProgressIndicator());
}
