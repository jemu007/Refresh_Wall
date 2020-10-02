import 'package:flutter/material.dart';
import 'package:refresh_wall/ImageView/imageview.dart';
import 'package:refresh_wall/Model/PhotoModel.dart';

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
