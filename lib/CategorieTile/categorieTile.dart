import 'package:flutter/material.dart';
import 'package:refresh_wall/CategorieTile/categoriePage.dart';

class CategirieTile extends StatelessWidget {
  CategirieTile({@required this.text, this.img});

  final String img;
  final String text;

  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoriePage(
                      categorieName: text.toLowerCase(),
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 9.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(children: [
            Image.network(
              img,
              width: 122,
              height: 80,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black38,
              alignment: Alignment.center,
              width: 122,
              height: 80,
              child: Text(
                text,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
