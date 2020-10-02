import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:refresh_wall/Model/PhotoModel.dart';

class API {
  Future<List<PhotosModel>> getTrendingWallpaper(
      int paginationLimit, page, String query) async {
    List<PhotosModel> photos = new List();
    String url =
        "https://api.pexels.com/v1/search?query=$query&per_page=$paginationLimit&page=$page";
    print('url $url');
    var responce = await http.get(url, headers: {
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
    return photos;
  }
}
