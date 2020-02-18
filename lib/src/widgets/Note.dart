import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  const Note({Key key, this.author, this.photoUrl, this.note})
      : super(key: key);

  final String author;

  final String photoUrl;

  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(photoUrl),
                    ),
                  ),
                ),
                Text(
                  author,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(note),
            ),
          ],
        ),
      ),
    );
  }
}
