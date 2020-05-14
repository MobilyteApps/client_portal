import 'package:client_portal_app/src/widgets/RoundButton.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoPageView extends StatelessWidget {
  const PhotoPageView(
      {Key key, @required this.photos, @required this.initialPage})
      : super(key: key);

  final List photos;

  final int initialPage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _gallery(),
        RoundButton(
          backgroundColor: Colors.black,
          textColor: Colors.white,
          child: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  Widget _gallery() {
    var pageController = PageController(initialPage: initialPage);
    return PhotoViewGallery.builder(
      pageController: pageController,
      itemCount: photos == null ? 0 : photos.length,
      builder: (context, index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(photos[index]['url']),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2,
        );
      },
      scrollPhysics: BouncingScrollPhysics(),
    );
  }
}
