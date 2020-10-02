import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refresh_wall/Model/PhotoModel.dart';
import 'package:refresh_wall/Model/api.dart';
import 'package:refresh_wall/Model/categorie.dart';
import 'package:refresh_wall/Model/categorieTile.dart';
import 'package:refresh_wall/Model/imageview.dart';
import 'package:refresh_wall/Model/list.dart';
import 'package:refresh_wall/Model/search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<CategorieModel> categories = new List();
  List<PhotosModel> photos = new List();
  ScrollController scrollController = ScrollController();
  bool isPageAvailable = true;
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

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

      var list = await api.getTrendingWallpaper(10, pageNumber);
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
    categories = getCategories();
    getmoreData(pagenumber++);

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        getmoreData(pagenumber++);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Refresh")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          searchBar(),
          Container(
            height: 80,
            child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategirieTile(
                    img: categories[index].imgUrl,
                    text: categories[index].categorieName,
                  );
                }),
          ),
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
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search",
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchPage(
                              searchQuery: searchController.text,
                            )));
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

  Widget wallpaperList({List<PhotosModel> photos, context}) {
    return photos.length != 0
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
            // ListView.builder(
            //     itemCount: photos.length,
            //     shrinkWrap: true,
            //     itemBuilder: (BuildContext ctxt, int index) {
            //       return GridTile(
            //           child: Container(
            //               child: ClipRRect(
            //                   borderRadius: BorderRadius.circular(16),
            //                   child: Image.network(
            //                     photos[index].src.portrait,
            //                     fit: BoxFit.cover,
            //                   ))));
            //     }),

            // children: [
            //   GridView.count(
            //       shrinkWrap: true,
            //       padding: EdgeInsets.symmetric(horizontal: 16),
            //       physics: ClampingScrollPhysics(),
            //       crossAxisCount: 2,
            //       mainAxisSpacing: 6.0,
            //       childAspectRatio: 0.6,
            //       crossAxisSpacing: 6.0,
            //       children: photos.map((e) {
            // return GridTile(
            //     child: Container(
            //         child: ClipRRect(
            //             borderRadius: BorderRadius.circular(16),
            //             child: Image.network(
            //               e.src.portrait,
            //               fit: BoxFit.cover,
            //             ))));
            //       }).toList()),
            // ],

            onRefresh: () async {
              photos.clear();
              await getmoreData(0);
            },
          )
        : Center(child: CircularProgressIndicator());
  }

  // Future getData(bool isRefresh) async {
  //   if (isPageAvailable) {
  //     if (isLoading) {
  //       return;
  //     }
  //     setState(() {
  //       isLoading = true;
  //     });

  //     var newPhotos = await api.getTrendingWallpaper(10, 0);

  //     photos.addAll(newPhotos);
  //     setState(() {
  //       isLoading = false;
  //     });

  //     return await Future.delayed(Duration(milliseconds: 10));
  //   }
  // }
}
