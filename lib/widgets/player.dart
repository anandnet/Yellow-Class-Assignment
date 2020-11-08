import 'package:assignment/widgets/control_overlay.dart';
import 'package:assignment/widgets/video_feed.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import "package:assignment/main.dart" show cameras;

class Player extends StatefulWidget {
  final String url;
  final String name;
  Player(this.url,this.name);
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  VideoPlayerController _controller;
  @override
  void initState() {
    /*
     File file = new File(widget.filePath);
     _controller = VideoPlayerController.file(
       file
    );*/
    _controller = VideoPlayerController.network(widget.url,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false));

    _controller.addListener(() {
      setState(() {});
    });
    _controller.play();
    _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double feedRight = 40;
  double feedBottom = 60;
  bool isFeedDragged = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            child: Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        VideoPlayer(
                          _controller,
                        ),
                      ],
                    ),
                  ),
                ),
                ControlsOverlay(controller: _controller,vidName:widget.name),
                cameras.length == 2
                    ? AnimatedPositioned(
                        right: feedRight,
                        bottom: feedBottom,
                        child: GestureDetector(
                          onLongPressStart: (details) => setState(() {
                            isFeedDragged = true;
                          }),
                          onLongPressEnd: (details) => setState(() {
                            isFeedDragged = false;
                          }),
                          onLongPressMoveUpdate: (details) {
                            setState(() {
                              feedRight =
                                  size.width - details.globalPosition.dx - 30;
                              feedBottom =
                                  size.height - details.globalPosition.dy - 30;
                            });
                          },
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.white,
                                      width: isFeedDragged ? 4 : 2)),
                              height: 80,
                              width: 80,
                              //color: Colors.amber,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: VideoFeed(cameras)),
                            ),
                          ),
                        ),
                        duration: Duration(milliseconds: 10),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
