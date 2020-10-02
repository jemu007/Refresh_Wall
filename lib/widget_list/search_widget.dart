import 'package:flutter/material.dart';

TextEditingController searchController = TextEditingController();

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
