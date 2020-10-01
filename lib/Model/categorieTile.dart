import 'package:flutter/material.dart';

class CategirieTile extends StatelessWidget {
  CategirieTile({@required this.text, this.img});

  final String img;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(children: [
          Image.network(
            img,
              width: 119,
              height: 80,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black38,
            alignment: Alignment.center,
            width: 119,
            height: 80,
            child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
          )
        ]),
      ),
    );
  }
}
