import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/video.dart';

class VideoCell extends StatelessWidget {
  final Video video;
  VideoCell(this.video);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(16.0),
          child: new Container(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Center(
                  child: new CachedNetworkImage(
                      imageUrl: video.imageUrl,
                      placeholder: new CircularProgressIndicator(),
                      errorWidget: new Icon(Icons.error)
                  ),
                ),


                new Container(
                  height: 8.0,
                ),
                new Text(
                  video.name,
                  style: new TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        new Divider(),
      ],
    );
  }
}
