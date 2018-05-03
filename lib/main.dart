import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './views/video_cell.dart';
import './model/video.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(new RealWorldApp());

class RealWorldApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RealWorldState();
  }
}

class RealWorldState extends State<RealWorldApp> {
  var _isLoading = false;

  final videos = new List<Video>();

  _fetchData() async {
    final response =
        await http.get("http://api.letsbuildthatapp.com/youtube/home_feed");
    if (response.statusCode == 200) {
      final coursesJson = json.decode(response.body);
      // print(coursesJson);
      coursesJson["videos"].forEach((videoDict) {
        final course = new Video(videoDict["id"], videoDict["name"],
            videoDict["imageUrl"], videoDict["numberOfViews"]);
        videos.add(course);
      });

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Real World App",
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text("Real World App"),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColorDark,
            actions: <Widget>[
              new IconButton(
                icon: new Icon(Icons.refresh),
                onPressed: () {
                  print("Reloading ...");
                  setState(() {
                    _isLoading = true;
                  });
                  _fetchData();
                },
              )
            ],
          ),
          body: new Center(
            child: _isLoading
                ? new CircularProgressIndicator()
                : new ListView.builder(
                    itemCount: this.videos != null ? this.videos.length : 0,
                    itemBuilder: (context, i) {
                      final video = this.videos[i];
                      return new FlatButton(
                          padding: new EdgeInsets.all(0.0),
                          onPressed: () {
                            print("Video cell tapped $i");
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) => new CourseDetail(video),
                                ));
                          },
                          child: new VideoCell(video));
                    }),
          ),
        ));
  }
}

class Lesson {
  final String name;
  final String imageUrl;
  final String duration;
  final int number;

  Lesson(this.name, this.imageUrl, this.duration, this.number);
}

class CourseDetail extends StatefulWidget {
  final Video video;

  CourseDetail(this.video);

  @override
  State<StatefulWidget> createState() {
    return new CourseDetailState(video);
  }
}

class CourseDetailState extends State<CourseDetail> {
  final Video video;
  var _isLoading = true;

  CourseDetailState(this.video);

  @override
  void initState() {
    super.initState();
    _fetchLessons();
  }

  final lessons = new List<Lesson>();

  _fetchLessons() async {
    final urlString =
        'https://api.letsbuildthatapp.com/youtube/course_detail?id=' +
            video.id.toString();
    final response = await http.get(urlString);
    final lessonsJson = json.decode(response.body);
    lessonsJson.forEach((lessonJson) {
      final lesson = new Lesson(lessonJson["name"], lessonJson["imageUrl"],
          lessonJson["duration"], lessonJson["number"]);
      lessons.add(lesson);
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(video.name),
        backgroundColor: Colors.redAccent,
      ),
      body: new Center(
          child: _isLoading
              ? new CircularProgressIndicator()
              : new ListView.builder(
                  itemCount: lessons.length,
                  itemBuilder: (context, i) {
                    final lesson = lessons[i];
                    return new Column(
                      children: <Widget>[
                        new Container(
                          padding: new EdgeInsets.all(8.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Center(
                                child: new CachedNetworkImage(
                                  imageUrl: lesson.imageUrl,
                                  placeholder: new CircularProgressIndicator(),
                                  errorWidget: new Icon(Icons.error),
                                  width: 150.0,
                                ),
                              ),

                              new Container(width: 12.0,),
                              new Flexible(
                                  child: new Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text(lesson.name),
                                      new Container(height: 10.0,),
                                      new Text(lesson.duration),
                                      new Text("Episode #" + lesson.number.toString(),
                                        style: new TextStyle(fontWeight: FontWeight.w800),
                                      )
                                    ],
                                  )
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  })),
    );
  }
}
