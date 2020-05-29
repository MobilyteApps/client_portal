import 'package:client_portal_app/src/widgets/RoundButton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoPageView extends StatefulWidget {
  const PhotoPageView(
      {Key key, @required this.photos, @required this.initialPage})
      : super(key: key);

  final List photos;

  final int initialPage;

  @override
  _PhotoPageViewState createState() => _PhotoPageViewState();
}

class _PhotoPageViewState extends State<PhotoPageView> {
  PageController pageController;
  int currentPage;
  int totalPages;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialPage);

    //currentPage = widget.initialPage;
    totalPages = widget.photos.length;
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _gallery(pageController),
        _close(context),
        _prev(pageController),
        _next(pageController),
      ],
    );
  }

  Widget _close(context) {
    if (kIsWeb == false) {
      return SizedBox();
    }
    return Positioned(
      top: 0,
      right: -20,
      child: RoundButton(
        backgroundColor: Colors.black,
        textColor: Colors.white,
        child: Icon(
          Icons.close,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _prev(PageController pageController) {
    if (kIsWeb == false) {
      return SizedBox();
    }
    return Positioned(
      left: -15,
      top: MediaQuery.of(context).size.height / 2 - 10,
      child: RoundButton(
        backgroundColor: Colors.black,
        textColor: Colors.white,
        child: Icon(Icons.arrow_back_ios),
        onPressed: () {
          pageController.previousPage(
              duration: Duration(milliseconds: 250), curve: Curves.ease);
        },
      ),
    );
  }

  Widget _next(PageController pageController) {
    if (kIsWeb == false) {
      return SizedBox();
    }

    return Positioned(
      right: -15,
      top: MediaQuery.of(context).size.height / 2 - 10,
      child: RoundButton(
        backgroundColor: Colors.black,
        textColor: Colors.white,
        child: Icon(Icons.arrow_forward_ios),
        onPressed: () {
          pageController.nextPage(
              duration: Duration(milliseconds: 250), curve: Curves.ease);
        },
      ),
    );
  }

  Widget _gallery(pageController) {
    return PhotoViewGallery.builder(
      gaplessPlayback: true,
      pageController: pageController,
      itemCount: widget.photos == null ? 0 : widget.photos.length,
      builder: (context, index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(widget.photos[index]['url']),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2,
        );
      },
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes,
          ),
        ),
      ),
      scrollPhysics: ClampingScrollPhysics(),
    );
  }
}
